//
//  GameAI.swift
//  TicTacToe
//
//  Bot AI strategies and logic
//

import Foundation

extension GameState {

    // MARK: - Bot Move Execution

    func deviceMove() async {
        // Guard against multiple concurrent calls
        guard !isThinking else { return }
        // Only move if it's actually the bot's turn (Circle)
        guard turn == .Circle else { return }

        isThinking = true
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Double-check turn hasn't changed during sleep
        guard turn == .Circle else {
            isThinking = false
            return
        }

        // Try to find the best move
        if let move = findBestMove() {
            placeTile(move.row, move.column)
        }

        isThinking = false
    }

    // MARK: - Difficulty Strategy Selection

    func findBestMove() -> (row: Int, column: Int)? {
        switch botDifficulty {
        case .easy:
            return findEasyMove()
        case .medium:
            return findMediumMove()
        case .hard:
            return findHardMove()
        }
    }

    // MARK: - Easy Difficulty

    // Easy: Random moves with occasional mistakes
    private func findEasyMove() -> (row: Int, column: Int)? {
        var availableMoves: [(Int, Int)] = []

        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col].tile == .Empty {
                    availableMoves.append((row, col))
                }
            }
        }

        // 30% chance to block or win, 70% random
        if Int.random(in: 1...10) <= 3 {
            let opponentTile = turn == .Cross ? Tile.Circle : Tile.Cross
            if let blockMove = findWinningMove(for: opponentTile) {
                return blockMove
            }
            if let winMove = findWinningMove(for: turn) {
                return winMove
            }
        }

        return availableMoves.randomElement()
    }

    // MARK: - Medium Difficulty

    // Medium: Balanced strategy with some randomness
    private func findMediumMove() -> (row: Int, column: Int)? {
        // 60% chance to play smart, 40% chance to play randomly
        if Int.random(in: 1...10) <= 4 {
            return findEasyMove()
        }

        // Strategy 1: Try to win (always take winning move)
        if let winMove = findWinningMove(for: turn) {
            return winMove
        }

        // Strategy 2: Block opponent from winning (70% of the time)
        if Int.random(in: 1...10) <= 7 {
            let opponentTile = turn == .Cross ? Tile.Circle : Tile.Cross
            if let blockMove = findWinningMove(for: opponentTile) {
                return blockMove
            }
        }

        // Strategy 3: Sometimes take center (50% chance)
        if board[1][1].tile == .Empty && Bool.random() {
            return (1, 1)
        }

        // Strategy 4: Take a random available space
        var availableMoves: [(Int, Int)] = []
        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col].tile == .Empty {
                    availableMoves.append((row, col))
                }
            }
        }

        return availableMoves.randomElement()
    }

    // MARK: - Hard Difficulty (Minimax)

    // Hard: Minimax algorithm with occasional mistakes (90% optimal, 10% random)
    private func findHardMove() -> (row: Int, column: Int)? {
        // 10% chance to make a strategic move instead of perfect move
        // This makes it beatable but still very challenging
        if Int.random(in: 1...10) == 1 {
            // Use medium strategy instead
            return findMediumMove()
        }

        let botTile = turn
        let playerTile: Tile = turn == .Cross ? .Circle : .Cross

        // Create a copy of the board to work with (don't modify @Published board)
        var boardCopy = board

        var bestScore = Int.min
        var bestMove: (row: Int, column: Int)? = nil

        for row in 0..<3 {
            for col in 0..<3 {
                if boardCopy[row][col].tile == .Empty {
                    // Try this move for the bot
                    boardCopy[row][col].tile = botTile
                    let score = minimax(board: &boardCopy, depth: 0, isMaximizing: false, botTile: botTile, playerTile: playerTile)
                    boardCopy[row][col].tile = .Empty

                    if score > bestScore {
                        bestScore = score
                        bestMove = (row, col)
                    }
                }
            }
        }

        return bestMove
    }

    private func minimax(board: inout [[Cell]], depth: Int, isMaximizing: Bool, botTile: Tile, playerTile: Tile) -> Int {
        // Check if bot wins
        if checkWinForTile(board, tile: botTile) {
            return 10 - depth
        }

        // Check if player wins
        if checkWinForTile(board, tile: playerTile) {
            return depth - 10
        }

        // Check for draw
        if checkForDraw(board) {
            return 0
        }

        if isMaximizing {
            // Bot's turn - maximize score
            var maxScore = Int.min
            for row in 0..<3 {
                for col in 0..<3 {
                    if board[row][col].tile == .Empty {
                        board[row][col].tile = botTile
                        let score = minimax(board: &board, depth: depth + 1, isMaximizing: false, botTile: botTile, playerTile: playerTile)
                        board[row][col].tile = .Empty
                        maxScore = max(maxScore, score)
                    }
                }
            }
            return maxScore
        } else {
            // Player's turn - minimize score
            var minScore = Int.max
            for row in 0..<3 {
                for col in 0..<3 {
                    if board[row][col].tile == .Empty {
                        board[row][col].tile = playerTile
                        let score = minimax(board: &board, depth: depth + 1, isMaximizing: true, botTile: botTile, playerTile: playerTile)
                        board[row][col].tile = .Empty
                        minScore = min(minScore, score)
                    }
                }
            }
            return minScore
        }
    }

    // MARK: - Helper Functions

    private func checkWinForTile(_ board: [[Cell]], tile: Tile) -> Bool {
        // Check rows
        for row in 0..<3 {
            if board[row][0].tile == tile && board[row][1].tile == tile && board[row][2].tile == tile {
                return true
            }
        }

        // Check columns
        for col in 0..<3 {
            if board[0][col].tile == tile && board[1][col].tile == tile && board[2][col].tile == tile {
                return true
            }
        }

        // Check diagonals
        if board[0][0].tile == tile && board[1][1].tile == tile && board[2][2].tile == tile {
            return true
        }
        if board[0][2].tile == tile && board[1][1].tile == tile && board[2][0].tile == tile {
            return true
        }

        return false
    }

    private func checkForDraw(_ board: [[Cell]]) -> Bool {
        for row in board {
            for cell in row {
                if cell.tile == Tile.Empty {
                    return false
                }
            }
        }
        return true
    }

    func findWinningMove(for tile: Tile) -> (row: Int, column: Int)? {
        // Check all possible moves to see if any would result in a win
        for row in 0..<3 {
            for col in 0..<3 {
                if board[row][col].tile == .Empty {
                    // Temporarily place the tile
                    board[row][col].tile = tile
                    let savedTurn = turn
                    turn = tile

                    // Check if this creates a win
                    let isWin = checkForVictory()

                    // Restore the board
                    board[row][col].tile = .Empty
                    turn = savedTurn

                    if isWin {
                        return (row, col)
                    }
                }
            }
        }
        return nil
    }
}
