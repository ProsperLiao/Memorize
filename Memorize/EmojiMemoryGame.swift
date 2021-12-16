//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/10/3.
//


// View Model
import Foundation
import UIKit
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    private static func createMemoryGame(with theme: Theme, numberOfPairOfCard: Int? = nil) -> MemoryGame<String> {
        var numberOfPair = numberOfPairOfCard ?? (theme.defaultNumberOfPair ?? Int.random(in: 0..<theme.emojis.count))
        if numberOfPair < 0 {
            numberOfPair = 0
        }
        numberOfPair = theme.emojis.count < numberOfPair ? theme.emojis.count : numberOfPair
        
        let emojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfCards: numberOfPair) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    init() {
        let theme = Theme.themes.randomElement()!
        currentTheme = theme
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
    @Published private var currentTheme: Theme
    
    @Published private var model: MemoryGame<String>
    
    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var theme: Theme {
        return currentTheme
    }
    
    var color: Color {
        return parseColor(currentTheme.color)
    }
    
    var color2: Color? {
        guard let color = currentTheme.color2 else {
            return nil
        }
        return parseColor(color)
    }
    
    private func parseColor(_ color: String) -> Color {
        switch color {
        case "yellow":
            return .yellow
        case "blue":
            return .blue
        case "green":
            return .green
        case "purple":
            return .purple
        default:
            return .red
        }
    }
    
    // MARK: - Intent(s)
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func startNewGame() {
        currentTheme = Theme.themes.randomElement()!
        model = EmojiMemoryGame.createMemoryGame(with: currentTheme)
    }
    
    func restartGame() {
        model = EmojiMemoryGame.createMemoryGame(with: currentTheme)
    }
    
    func chooseTheme() {
        
    }
}
