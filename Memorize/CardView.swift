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
                Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:  -250 - 90)).padding(DrawingConstants.piePadding).opacity(DrawingConstants.pieOpacity)
                Text(card.content).font(font(in: geometry.size))
            }.cardify(isFaceUp: card.isFaceUp, color: color, color2: color2)
        }
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontSizeScale)
    }
    
    private struct DrawingConstants {
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

