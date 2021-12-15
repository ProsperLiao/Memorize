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
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
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
                
                indexOfTheOneAndOnlyFaceUpCard = nil
                dateOfTheOneAndOnlyFaceUpCardToggled = nil
            } else {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                dateOfTheOneAndOnlyFaceUpCardToggled = Date()
            }
           
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    struct Card: Identifiable {
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        var id: Int
    }
}

