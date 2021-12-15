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
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20.0)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: MemoryGame<String>.Card(content: "1", id: 1), color: .red)
    }
}

