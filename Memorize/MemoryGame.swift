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
    
    private(set) var id: UUID
    
    init(numberOfCards: Int, createCardContent: (Int) -> CardContent) {
        id = UUID()
        cards = [Card]()
        for pairIndex in 0..<numberOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        shuffle()
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[potentialMatchIndex].content == cards[chosenIndex].content {
                    cards[potentialMatchIndex].isMatched = true
                    cards[chosenIndex].isMatched = true
                    var earned = 0
                    
                    if cards[potentialMatchIndex].bonusTimeLimit > 0 {
                        earned += lround(10.0 * cards[potentialMatchIndex].bonusTimeRemaining / cards[potentialMatchIndex].bonusTimeLimit)
                    }
                    if cards[chosenIndex].bonusTimeLimit > 0 {
                        earned += lround(10.0 * cards[chosenIndex].bonusTimeRemaining / cards[chosenIndex].bonusTimeLimit)
                    }
                    
                    earned = min(max(1, earned), 20)
                    
                    score += earned
                } else {
                    var penalized = 0
                    if cards[potentialMatchIndex].isSeen || cards[chosenIndex].isSeen {
                        if cards[potentialMatchIndex].bonusTimeLimit > 0 {
                            penalized -= lround(10.0 * (1 - cards[potentialMatchIndex].bonusTimeRemaining / cards[potentialMatchIndex].bonusTimeLimit))
                        }
                        if cards[chosenIndex].bonusTimeLimit > 0 {
                            penalized -= lround(10.0 * (1 - cards[chosenIndex].bonusTimeRemaining / cards[chosenIndex].bonusTimeLimit))
                        }
                        
                        penalized = min(max(-20, penalized), -1)
                    }
                    cards[chosenIndex].isSeen = true
                    cards[potentialMatchIndex].isSeen = true
                    
                    score += penalized
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
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startConsumeBonusTime()
                } else {
                    stopConsumeBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                if isMatched {
                    stopConsumeBonusTime()
                }
            }
        }
        var isSeen = false
        let id: Int
        
        // MARK: - Bonus Time
        // 在卡片翻面后，
        // 如果玩家在限制时间内配对成功，
        // 则可获得额外的奖励分数.
        // 配对消耗时间越少，获得分数越高，
        // 时间耗尽，奖励分数为零.
        
        // 奖励分的限时，如果设值为零时，表示不使用奖励
        var bonusTimeLimit: TimeInterval = 6
        
        // 被翻面(当前面朝上)的时间点, 非nil时表示当前面朝上
        var lastFaceUpDate: Date?
        
        // 过去被翻面的累计总时长，不包括当前正在翻面的时间
        var pastFaceUpTime: TimeInterval = 0
        
        // 卡片面朝上所累计的总时长， 包括当前面朝上的的时长
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // 剩余的奖励时长
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        //剩余的奖励百分比
        var bonusRemaining: Double {
            bonusTimeLimit > 0 ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // 是否赚取奖励(在奖励时限内配对成功)
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        // 当前是否面朝上，及未配对，且未用尽奖励时间窗口
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // 开始计时
        private mutating func startConsumeBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // 停止计时
        private mutating func stopConsumeBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
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

