//
//  CardView.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var color: ThemeColor
    
    @State private var animatedBonusRemaining: Double = 0
    
    @State private var scaleForMatched: CGFloat = 1
    
    @State private var isRotating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isConsumingBonusTime {
                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:  360*(1 - animatedBonusRemaining) - 90))
                        .onAppear {
                            animatedBonusRemaining = card.bonusRemaining
                            withAnimation(.linear(duration: card.bonusTimeLimit * card.bonusRemaining)) {
                                animatedBonusRemaining = 0
                            }
                        }
                        .padding(DrawingConstants.piePadding)
                        .opacity(DrawingConstants.pieOpacity)
                }
                
                Text(card.content)
                    .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isRotating)
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                    .onChange(of: card.isMatched) { isMatched in
                        if isMatched {
                            withAnimation(.linear(duration: 1)) {
                                scaleForMatched = 1.5
                            }
                        }
                    }
                    .animationObserver(for: scaleForMatched, onComplete: {
                        withAnimation(.linear(duration: 1)) {
                            scaleForMatched = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isRotating = true
                        }
                    })

            }.cardify(isFaceUp: card.isFaceUp, color: color)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        scaleForMatched * min(size.width, size.height) * DrawingConstants.fontSizeScale /  DrawingConstants.fontSize
    }
    
    private struct DrawingConstants {
        static let fontSize: CGFloat = 32
        static let fontSizeScale: CGFloat = 0.7
        static let piePadding: CGFloat = 7
        static let pieOpacity: CGFloat = 0.5
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: EmojiMemoryGame.Card(content: "😀", isFaceUp: true, id: 1), color: ThemeColor(first: Color(UIColor.red)))
    }
}

