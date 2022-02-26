//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @State private var dealt = Set<Int>()
    
    @Namespace private var dealingNamespace
    
    init(viewModel: EmojiMemoryGame = EmojiMemoryGame()) {
        self.game = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("Memorize!").font(.largeTitle)
                HStack {
                    start
                    Spacer()
                    restart
                }
                .font(.largeTitle)
                .padding(.horizontal)
                Spacer()
                HStack {
                    Text("\(game.theme.name)")
                        .font(.largeTitle)
                    Text("\(game.score)")
                        .font(.largeTitle)
                }
                Spacer()
                gameBody
                Spacer()
                shuffle
                Spacer()
            }
            deckBody
        }
        .padding(.horizontal)
        
    }
    
    var start: some View {
        Button ("New Game") {
            game.startNewGame()
        }
    }
    
    var restart: some View {
        Button ("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    var shuffle: some View {
        Button("shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }

    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if isUnDealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card, color: game.color, color2: game.color2)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale).animation(.easeInOut))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        })
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUnDealt)) { card in
                CardView(card: card, color: game.color, color2: game.color2)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardViewConstants.deckWidth, height: CardViewConstants.deckHeight, alignment: Alignment.center)
        .onTapGesture {
            // 发卡片
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    

    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id }) {
            delay = Double(index) * (CardViewConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardViewConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex{ $0.id == card.id } ?? 0)
    }
    
    private struct CardViewConstants {
        static let deckWidth: CGFloat = 60
        static let deckHeight: CGFloat = 90
        static let dealDuration: Double = 0.7
        static let totalDealDuration: Double = 2
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(viewModel: game)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("12 Pro Max")
//        EmojiMemoryGameView(viewModel: game)
//            .preferredColorScheme(.dark)
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
//            .previewDisplayName("12 Pro Max Dark")
    }
}
