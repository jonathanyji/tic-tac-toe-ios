//
//  MPGameMove.swift
//  TicTacToe
//
//  Multiplayer game move model
//

import Foundation

enum MPGameAction: String, Codable {
    case start
    case move
    case reset
    case end
}

struct MPGameMove: Codable {
    let action: MPGameAction
    let row: Int?
    let col: Int?
    let playerName: String?

    init(action: MPGameAction, row: Int? = nil, col: Int? = nil, playerName: String? = nil) {
        self.action = action
        self.row = row
        self.col = col
        self.playerName = playerName
    }
}
