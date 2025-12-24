//
//  ViewModifiers.swift
//  TicTacToe
//
//  Created by Jonathan Yeo on 24/12/2025.
//

import SwiftUI

// Provides backward-compatible navigation for iOS.
struct NavStackContainer: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            // Uses NavigationStack on iOS 16+
            NavigationStack {
                content
            }
        } else {
            // falls back to NavigationView on older versions.
            NavigationView {
                content
            }
            .navigationViewStyle(.stack)
        }
    }
}

// Usage:
// ```
// ContentView()
//     .inNavigationStack()
// ```
extension View {
    public func inNavigationStack() -> some View {
        return self.modifier(NavStackContainer())
    }
}
