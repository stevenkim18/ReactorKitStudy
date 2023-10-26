//
//  Reactor.swift
//  GithubSearch
//
//  Created by seungwooKim on 2023/10/25.
//

import Foundation
import ReactorKit

class GithubSearchReactor: Reactor {
    enum Action {
        case updateQuery(String?)
    }
    
    enum Mutation {
        case setQuery(String?)      // 사용자 입력한 단어
        case setRepos([String])     // 데이터들
    }
    
    struct State {
        var query: String?
        var repos: [String] = []
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                self.search(query: query)
                    .take(until: self.action.filter(isUpdateQueryAction(_:)))
                    .map { Mutation.setRepos($0) }
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
        case let .setRepos(repos):
            var newState = state
            newState.repos = repos
            return newState
        }
    }
}

extension GithubSearchReactor {
    private func url(for query: String?) -> URL? {
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)")
    }
    
    private func search(query: String?) -> Observable<[String]> {
        guard let url = self.url(for: query) else { return .just([]) }
        return URLSession.shared.rx.json(url: url)
            .map { json -> [String] in
                guard let dict = json as? [String: Any] else { return [] }
                guard let items = dict["items"] as? [[String: Any]] else { return [] }
                return items.compactMap { $0["full_name"] as? String }
            }
    }
    
    private func isUpdateQueryAction(_ action: Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
}
