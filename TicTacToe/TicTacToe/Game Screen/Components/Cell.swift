//
//  Cell.swift
//  TicTacToe
//
//  Created by Jonathan Yeo on 24/12/2025.
//

import Foundation
import SwiftUICore

struct Cell {
    var tile: Tile
    
    func displayTile() -> String {
        switch(tile){
            case Tile.Cross:
                return "X"
            case Tile.Circle:
                return "O"
            default:
                return ""
        }
    }
    
    func tileColour() -> Color {
        switch(tile){
            case Tile.Cross:
                return Color.red
            case Tile.Circle:
                return Color.black
            default:
                return Color.black
        }
    }
    
}

enum Tile {
    case Cross
    case Circle
    case Empty
}
