//
//  GameState.swift
//  TicTacToe
//
//  Created by Jonathan Yeo on 24/12/2025.
//

import Foundation

class GameState: ObservableObject {
    @Published var board = [[Cell]]()
    @Published var turn = Tile.Cross
    @Published var crossScore = 0
    @Published var circleScore = 0
    @Published var showAlert = false
    @Published var alertMessage = "Draw"
    @Published var isThinking = false

    let gameType: GameType
    let playerName: String
    let opponentName: String
    let botDifficulty: BotDifficulty

    init(gameType: GameType = .single, playerName: String = "Cross", opponentName: String = "Circle", botDifficulty: BotDifficulty = .medium) {
        self.gameType = gameType
        self.playerName = playerName
        self.opponentName = opponentName
        self.botDifficulty = botDifficulty
        resetBoard()
    }
    
    func placeTile(_ row: Int, _ column: Int){

        if (board[row][column].tile != Tile.Empty){
            return
        }

        board[row][column].tile = turn == Tile.Cross ? Tile.Cross : Tile.Circle

        if (checkForVictory()) {
            if (turn == Tile.Cross){
                crossScore += 1
            } else {
                circleScore += 1
            }
            let winner = turn == Tile.Cross ? playerName : opponentName
            alertMessage = winner + " Wins!"
            showAlert = true
        } else {
            turn = turn == Tile.Cross ? Tile.Circle : Tile.Cross
        }

        if (checkForDraw()) {
            alertMessage = "Draw"
            showAlert = true
        }
    }
    
    func checkForDraw() -> Bool {
        for row in board {
            for cell in row {
                if cell.tile == Tile.Empty {
                    return false
                }
            }
        }
        return true
    }
    
    func checkForVictory() -> Bool {
        
        // Vertical victory
        if isTurnTile(0, 0) && isTurnTile(1, 0) && isTurnTile(2, 0){
            return true
        }
        if isTurnTile(0, 1) && isTurnTile(1, 1) && isTurnTile(2, 1){
            return true
        }
        if isTurnTile(0, 2) && isTurnTile(1, 2) && isTurnTile(2, 2){
            return true
        }
        
        // Horizontal victory
        if isTurnTile(0, 0) && isTurnTile(0, 1) && isTurnTile(0, 2){
            return true
        }
        if isTurnTile(1, 0) && isTurnTile(1, 1) && isTurnTile(1, 2){
            return true
        }
        if isTurnTile(2, 0) && isTurnTile(2, 1) && isTurnTile(2, 2){
            return true
        }
        
        // Diagonal victory
        if isTurnTile(0, 0) && isTurnTile(1, 1) && isTurnTile(2, 2){
            return true
        }
        if isTurnTile(0, 2) && isTurnTile(1, 1) && isTurnTile(2, 0){
            return true
        }
        
        return false
    }
    
    func isTurnTile(_ row: Int, _ column: Int) -> Bool {
        return board[row][column].tile == turn
    }
    
    func resetBoard() {
        var newBoard = [[Cell]]()

        for _ in 0...2 {
            var row = [Cell]()
            for _ in 0...2 {
                row.append(
                    Cell(tile: Tile.Empty)
                )
            }
            newBoard.append(row)
        }

        board = newBoard
        turn = .Cross
    }
    
    func turnText() -> String {
        if isThinking {
            return "Bot is thinking..."
        }
        let currentPlayer = turn == Tile.Cross ? playerName : opponentName
        return "\(currentPlayer)'s Turn"
    }
}
