//
//  CardView.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var color: Color  // 前景色
    var color2: Color?  // 前景色的线性渐变
    
    @State private var animatedBonusRemaining: Double = 0
    
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
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }.cardify(isFaceUp: card.isFaceUp, color: color, color2: color2)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) * DrawingConstants.fontSizeScale /  DrawingConstants.fontSize
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
        CardView(card: EmojiMemoryGame.Card(content: "😀", isFaceUp: true, id: 1), color: .red)
    }
}

