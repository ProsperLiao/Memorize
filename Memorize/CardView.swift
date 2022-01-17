//
//  CardView.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var color: Color
    var color2: Color?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    if let color2 = color2 {
                        shape.fill(LinearGradient.init(colors: [color, color2], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1)))
                            
                    } else {
                        shape.fill()
                            .foregroundColor(color)
                    }
                    
                }
            }
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontSizeScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let fontSizeScale: CGFloat = 0.75
        static let lineWidth: CGFloat = 3
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: EmojiMemoryGame.Card(content: "1", id: 1), color: .red)
    }
}

