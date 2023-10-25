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
        case setRepos([String])
    }
    
    struct State {
        var repos: [String] = []
    }
    
    var initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            if let query = query {
                let array = Array(query).map { String($0) }
                return Observable.just(Mutation.setRepos(array))
            } else {
                return Observable.just(Mutation.setRepos([]))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setRepos(repos):
            var newState = state
            newState.repos = repos
            return newState
        }
    }
}
