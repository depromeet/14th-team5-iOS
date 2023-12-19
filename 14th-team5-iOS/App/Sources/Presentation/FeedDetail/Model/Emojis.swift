//
//  Emojis.swift
//  App
//
//  Created by 마경미 on 14.12.23.
//

import Foundation

enum Emojis: Int {
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
    
    var emojiIndex: Int {
        return self.rawValue
    }
    
    static var allEmojis: [Emojis] {
        return [.standard, .heart, .clap, .good, .funny]
    }
    
    static func emoji(forIndex index: Int) -> Emojis {
        return Emojis(rawValue: index) ?? .standard
    }
}
