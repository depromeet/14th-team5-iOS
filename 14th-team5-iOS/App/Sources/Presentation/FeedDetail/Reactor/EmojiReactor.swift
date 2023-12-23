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
        case tappedSelectableEmojiStackView
        /// emoji count + 1
        case tappedSelectableEmojiButton(Emojis)
        /// emoji count - 1
        case tappedSelectedEmojiCountButton(Emojis)
        case receiveEmojiData([Emojis: Int])
    }
    
    enum Mutation {
        case showSelectableEmojiStackView
        case selectEmoji(Emojis)
        case unselectEmoji(Emojis)
        case setUpEmojiCountStackView([Emojis: Int])
    }
    
    struct State {
        var isShowingSelectableEmojiStackView: Bool = false
        var selectedEmoji: (Emojis?, Int) = (nil, 0)
        var unselectedEmoji: (Emojis?, Int) = (nil, 0)
        var emojiData: [Emojis: Int] = [:]
    }
    
    let initialState: State = State()
}

extension EmojiReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tappedSelectableEmojiStackView:
            return Observable.just(Mutation.showSelectableEmojiStackView)
        case let .receiveEmojiData(data):
            return Observable.just(Mutation.setUpEmojiCountStackView(data))
        case let .tappedSelectableEmojiButton(emoji):
            return Observable.just(Mutation.selectEmoji(emoji))
        case let .tappedSelectedEmojiCountButton(emoji):
            return Observable.just(Mutation.unselectEmoji(emoji))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .showSelectableEmojiStackView:
            newState.isShowingSelectableEmojiStackView.toggle()
        case let .setUpEmojiCountStackView(data):
            newState.emojiData = data
        case let .selectEmoji(emoji):
            newState.emojiData[emoji, default: 0] += 1
            newState.selectedEmoji = (emoji, newState.emojiData[emoji] ?? 0)
        case let .unselectEmoji(emoji):
            newState.emojiData[emoji, default: 0] -= 1
            newState.unselectedEmoji = (emoji, newState.emojiData[emoji] ?? 0)
        }
        return newState
    }
}

