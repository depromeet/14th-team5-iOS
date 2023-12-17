//
//  Emojis.swift
//  App
//
//  Created by 마경미 on 14.12.23.
//

import Foundation

enum Emojis {
    case standard
    case heart
    case clap
    case good
    case funny
    
    var emojiString: String {
        switch self {
        case .standard:
            return "🙂"
        case .heart:
            return "❤️"
        case .clap:
            return "👏"
        case .good:
            return "👍"
        case .funny:
            return "😂"
        }
    }
    
    static var allEmojis: [Emojis] {
        return [.standard, .heart, .clap, .good, .funny]
    }
}
