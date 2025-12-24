//
//  GameView.swift
//  TicTacToe
//
//  Created by Jonathan Yeo on 24/12/2025.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameState = GameState()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Score Section
            VStack(spacing: 16) {
                Text(gameState.turnText())
                    .font(.title)
                    .bold()
                
                HStack(spacing: 40) {
                    VStack {
                        Text("Cross")
                            .font(.headline)
                        Text("\(gameState.crossScore)")
                            .font(.title)
                            .bold()
                    }
                    
                    VStack {
                        Text("Circle")
                            .font(.headline)
                        Text("\(gameState.circleScore)")
                            .font(.title)
                            .bold()
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // Game Board
            let borderSize = CGFloat(5)
            VStack(spacing: borderSize) {
                ForEach(0...2, id: \.self) { row in
                    HStack(spacing: borderSize) {
                        ForEach(0...2, id: \.self) { column in
                            let cell = gameState.board[row][column]
                            
                            Text(cell.displayTile())
                                .font(.system(size: 60))
                                .bold()
                                .foregroundStyle(cell.tileColour())
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .background(Color.white)
                                .onTapGesture {
                                    gameState.placeTile(row, column)
                                }
                        }
                    }
                }
            }
            .background(Color.black)
            .padding()
            
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End Game") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("Tic Tac Toe")
        .inNavigationStack()
    }
}

#Preview {
    GameView()
}
