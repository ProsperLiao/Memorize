//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
