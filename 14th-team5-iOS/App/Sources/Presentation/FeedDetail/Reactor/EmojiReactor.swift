//
//  EmojiReactor.swift
//  App
//
//  Created by 마경미 on 12.12.23.
//

import Foundation
import Core
import ReactorKit

final class EmojiReactor: Reactor {
    enum Action {
        case receiveEmojiData([EmojiData])
        case tapAddEmojiButton
//        case emojiButtonTapped(Int)
        case standardEmojiButtonTapped(Emojis)
    }
    
    enum Mutation {
        case updateEmojiCount([EmojiData])
        case showStandardEmojiView
        case addEmojiCount(Emojis)
    }
    
    struct State {
        var isShowingStandardEmojiView: Bool = false
//        var tappedEmojiIndex: Int? = nil
        var emojiData: [EmojiData] = [
            EmojiData(emoji: .standard, count: 0),
            EmojiData(emoji: .heart, count: 0),
            EmojiData(emoji: .clap, count: 0),
            EmojiData(emoji: .good, count: 0),
            EmojiData(emoji: .funny, count: 0)
        ]
    }
    
    let initialState: State = State()
}

extension EmojiReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case let .emojiButtonTapped(index):
            // 이모지 더하기 +
//            return Observable.just(Mutation.addEmojiCount(index))
        case .tapAddEmojiButton:
            return Observable.just(Mutation.showStandardEmojiView)
        case let .receiveEmojiData(data):
            return Observable.just(Mutation.updateEmojiCount(data))
        case let .standardEmojiButtonTapped(emoji):
            return Observable.just(Mutation.addEmojiCount(emoji))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
//        case let .addEmojiCount(index):
//            if newState.emojiData[index].count == 0 {
//                newState.emojiData.append(Emojis.)
//            }
//            newState.emojiData[index].count += 1
        case .showStandardEmojiView:
            newState.isShowingStandardEmojiView = true
        case let .updateEmojiCount(data):
            newState.emojiData = data
        case let .addEmojiCount(emoji):
            newState.emojiData[emoji.emojiIndex].count += 1
        }
        return newState
    }
}

