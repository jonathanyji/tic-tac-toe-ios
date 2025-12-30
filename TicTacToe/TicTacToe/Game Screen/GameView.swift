//
//  GameView.swift
//  TicTacToe
//
//  Created by Jonathan Yeo on 24/12/2025.
//

import SwiftUI

struct GameView: View {

    let gameType: GameType
    let playerName: String
    let opponentName: String
    let botDifficulty: BotDifficulty

    @StateObject var gameState: GameState
    @Environment(\.dismiss) var dismiss

    init(gameType: GameType = .single, playerName: String = "Cross", opponentName: String = "Circle", botDifficulty: BotDifficulty = .medium) {
        self.gameType = gameType
        self.playerName = playerName
        self.opponentName = opponentName
        self.botDifficulty = botDifficulty
        _gameState = StateObject(wrappedValue: GameState(gameType: gameType, playerName: playerName, opponentName: opponentName, botDifficulty: botDifficulty))
    }
    
    var body: some View {
        NavigationView {
            mainContent
                .navigationTitle("Tic Tac Toe")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("End Game") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                    }
                }
        }
        .navigationViewStyle(.stack)
    }

    @ViewBuilder
    private var mainContent: some View {
        VStack {
            // Score Section
            scoreSection

            Spacer()

            // Game Board
            gameBoard

            Spacer()
        }
        .alert(isPresented: $gameState.showAlert) {
            Alert(
                title: Text(gameState.alertMessage),
                dismissButton: .default(Text("OK")) {
                    gameState.resetBoard()
                }
            )
        }
        .onChange(of: gameState.turn) { newTurn in
            if gameState.gameType == .bot && newTurn == .Circle && !gameState.showAlert && !gameState.isThinking {
                Task {
                    await gameState.deviceMove()
                }
            }
        }
    }

    @ViewBuilder
    private var scoreSection: some View {
        VStack(spacing: 16) {
            Text(gameState.turnText())
                .font(.title)
                .bold()

            HStack(spacing: 40) {
                VStack {
                    Text(gameState.playerName)
                        .font(.headline)
                    Text("\(gameState.crossScore)")
                        .font(.title)
                        .bold()
                }

                VStack {
                    Text(gameState.opponentName)
                        .font(.headline)
                    Text("\(gameState.circleScore)")
                        .font(.title)
                        .bold()
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private var gameBoard: some View {
        let borderSize = CGFloat(5)
        VStack(spacing: borderSize) {
            ForEach(0...2, id: \.self) { row in
                HStack(spacing: borderSize) {
                    ForEach(0...2, id: \.self) { column in
                        cellView(row: row, column: column)
                    }
                }
            }
        }
        .background(Color.black)
        .padding()
    }

    private func cellView(row: Int, column: Int) -> some View {
        let cell = gameState.board[row][column]

        return Text(cell.displayTile())
            .font(.system(size: 60))
            .bold()
            .foregroundStyle(cell.tileColour())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(Color.white)
            .onTapGesture {
                if gameState.gameType == .bot && gameState.turn == .Circle {
                    return  // Don't allow tapping when it's bot's turn
                }
                gameState.placeTile(row, column)
            }
    }
}

#Preview {
    GameView()
}
