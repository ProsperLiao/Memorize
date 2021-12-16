//
//  MemoryGame.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/10/3.
//

// Model
import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp}).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue)}}
    }
    
    private var dateOfTheOneAndOnlyFaceUpCardToggled: Date?
    
    private(set) var score = 0
    
    init(numberOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[potentialMatchIndex].content == cards[chosenIndex].content {
                    cards[potentialMatchIndex].isMatched = true
                    cards[chosenIndex].isMatched = true
                    var earned = 2
                    
                    if let dateOfTheOneAndOnlyFaceUpCardToggled = dateOfTheOneAndOnlyFaceUpCardToggled {
                        let duration = abs(round(dateOfTheOneAndOnlyFaceUpCardToggled.timeIntervalSinceNow))
                        let scale = Int(max(10 - duration, 1))
                        earned *= scale
                    }
                    score += earned
                } else {
                    var penalized = 0
                    if cards[potentialMatchIndex].isSeen {
                        penalized += 1
                    }
                    if cards[chosenIndex].isSeen {
                        penalized += 1
                    }
                    cards[chosenIndex].isSeen = true
                    cards[potentialMatchIndex].isSeen = true
                    
                    if let dateOfTheOneAndOnlyFaceUpCardToggled = dateOfTheOneAndOnlyFaceUpCardToggled {
                        let duration = abs(round(dateOfTheOneAndOnlyFaceUpCardToggled.timeIntervalSinceNow))
                        let scale = Int(max(10 - duration, 1))
                        penalized *= scale
                    }
                    score -= penalized
                }

                dateOfTheOneAndOnlyFaceUpCardToggled = nil
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                dateOfTheOneAndOnlyFaceUpCardToggled = Date()
            }
           
            
        }
    }
    
    struct Card: Identifiable {
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        let id: Int
    }
}

extension Array {
    var oneAndOnly: Element? {
        if count == 1 {
            return first
        } else {
            return nil
        }
    }
}

