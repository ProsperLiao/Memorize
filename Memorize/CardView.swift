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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:  -250 - 90)).padding(DrawingConstants.piePadding).opacity(DrawingConstants.pieOpacity)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    if let color2 = color2 {
                        shape.fill(LinearGradient.init(colors: [color, color2], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1)))
                            
                    } else {
                        shape.fill()
                           
                    }
                    
                }
            }.foregroundColor(color)
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontSizeScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let fontSizeScale: CGFloat = 0.7
        static let lineWidth: CGFloat = 3
        static let piePadding: CGFloat = 7
        static let pieOpacity: CGFloat = 0.5
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: EmojiMemoryGame.Card(content: "😀", isFaceUp: true, id: 1), color: .red)
    }
}

