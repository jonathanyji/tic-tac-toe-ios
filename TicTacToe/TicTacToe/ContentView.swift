//
//  ContentView.swift
//  TicTacToe
//
//  Created by Jonathan Yeo on 24/12/2025.
//

import SwiftUI

struct ContentView: View {

    @State private var gameType: GameType = .undertermined
    @State private var yourName = ""
    @State private var opponentName = ""
    @State private var botDifficulty: BotDifficulty = .medium
    @FocusState private var focus: Bool
    @State private var startGame = false
    
    
    var body: some View {
        VStack {
            Picker("Select Game", selection: $gameType){
                Text("Select Game Type").tag(GameType.undertermined)
                Text("Two Sharing Device").tag(GameType.single)
                Text("Challenge a bot").tag(GameType.bot)
                Text("Challenge a friend").tag(GameType.peer)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2)
            )
            .accentColor(.primary)
            
            
            Text(gameType.displayName.description).padding()
            
            VStack{
                switch gameType {
                case .single:
                    VStack {
                        TextField("Your Name", text: $yourName)
                        TextField("Opponent Name", text: $opponentName)
                    }
                case .bot:
                    VStack(spacing: 16) {
                        TextField("Your Name", text: $yourName)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bot Difficulty")
                                .font(.headline)
                            Picker("Difficulty", selection: $botDifficulty) {
                                ForEach(BotDifficulty.allCases, id: \.self) { difficulty in
                                    Text(difficulty.rawValue).tag(difficulty)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                case .peer:
                    EmptyView()
                case .undertermined:
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .frame(width: 350)
            
            if gameType != .peer {
                Button("Start Game") {
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undertermined ||
                    (gameType == .bot && yourName.isEmpty) ||
                    (gameType == .single && (yourName.isEmpty || opponentName.isEmpty))
                )
            }
        }
        .padding()
        .navigationTitle("Tic Tac Toe")
        .fullScreenCover(isPresented: $startGame, content: {
            GameView(
                gameType: gameType,
                playerName: yourName.isEmpty ? "Player" : yourName,
                opponentName: gameType == .bot ? "Bot" : (opponentName.isEmpty ? "Opponent" : opponentName),
                botDifficulty: botDifficulty
            )
        })
        .inNavigationStack()
        
    }
}

#Preview {
    ContentView()
}
