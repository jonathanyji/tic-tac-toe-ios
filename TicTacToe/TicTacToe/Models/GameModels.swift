//
//  GameModels.swift
//  TicTacToe
//
//  Created by Jonathan Yeo on 24/12/2025.
//

enum GameType {
    case single, bot, peer, undertermined

    var displayName: String {
        switch self {
        case .single:
            return "Share your iPhone/iPad and play against a friend."
        case .bot:
            return "Play against a bot."
        case .peer:
            return "Invite someone near you who has this app running to play."
        case .undertermined:
            return ""
        }
    }
}

enum BotDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var description: String {
        switch self {
        case .easy:
            return "Easy to beat"
        case .medium:
            return "Fair challenge"
        case .hard:
            return "Very challenging"
        }
    }
}

