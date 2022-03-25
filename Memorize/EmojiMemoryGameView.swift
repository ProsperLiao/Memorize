//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    init(viewModel: EmojiMemoryGame) {
        self.game = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Text("score: \(game.score)").font(.largeTitle)
                    Spacer()
                    shuffle
                }
                
                Spacer()
                gameBody
            }
            deckBody
        }
        .padding(.horizontal)
        .navigationTitle("\(game.theme.name)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                HStack {
                    restart
                    newGame
                })
    }
    
    var newGame: some View {
        Button {
            // FIXME: -
        } label: {
            Text("New")
        }
    }
    
    var restart: some View {
        Button {
            withAnimation {
                game.restart()
            }
        } label: {
            Image(systemName: "restart.circle")
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
            if game.isUnDealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                CardView(card: card, color: game.color)
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
            ForEach(game.cards.filter(game.isUnDealt)) { card in
                CardView(card: card, color: game.color)
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
                    game.deal(card)
                }
            }
        }
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
        let store = ThemeStore(named: "preview")
        let theme = store.theme(at: 2)
        let game = EmojiMemoryGame(with: theme)
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
