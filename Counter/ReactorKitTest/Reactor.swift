//
//  Reactor.swift
//  ReactorKitTest
//
//  Created by seungwooKim on 2023/10/24.
//

import ReactorKit
import RxSwift

final class ViewReactor: Reactor {
    // 사용자의 액션
    enum Action {
        case increase
        case decrease
    }
    
    // state를 바꾸는 가장 작은 단위
    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
        case setAlertMessage(String)
    }
    
    struct State {
        var value: Int = 0
        var isLoading: Bool = false
        @Pulse var alertMessage: String?
//        var alertMessage: String? = ""
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            // 액션에 따라서 다음 뮤테이션을 반환
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue)
                    .delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertMessage("Increased!!"))
            ])
            
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue)
                    .delay(.seconds(1), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setAlertMessage("Decreased!!"))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let.setAlertMessage(message):
            newState.alertMessage = message
        }
        return newState
    }
}

