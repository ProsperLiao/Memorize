//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/10/3.
//

import Foundation

// View Model
class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    
    typealias Card = MemoryGame<String>.Card
    
    private static func createMemoryGame(with theme: Theme, numberOfPairOfCard: Int? = nil) -> MemoryGame<String> {
        var numberOfPair = numberOfPairOfCard ?? theme.numberOfPairOfCards
        if numberOfPair < 0 {
            numberOfPair = 0
        }
        numberOfPair = theme.emojis.count < numberOfPair ? theme.emojis.count : numberOfPair
        
        let emojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfCards: numberOfPair) { pairIndex in
            String(emojis[pairIndex])
        }
    }
    
    init(with theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(with: theme)
    }
    
    var theme: Theme {
        didSet {
            if oldValue != theme {
                restart()
            }
        }
    }
    
    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var color: ThemeColor {
        return theme.color
    }
    
    @Published private var dealt = Set<Int>()
    
    
    func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    func isUnDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }

    
    // MARK: - Intent(s)
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
        
    func restart() {
        model = EmojiMemoryGame.createMemoryGame(with: theme)
        dealt = []
    }
}
