//
//  Cardify.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/2/14.
//

import SwiftUI

struct Cardify: ViewModifier  {
    var isFaceUp: Bool
    
    var color: ThemeColor
    
    func body(content: Content) -> some View {
        FlipView(front: {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            content
        }, back: {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if let fillStyle = color.fillStyle {
                shape.fill(fillStyle)
            } else {
                shape.fill(color.forgroundColor)
            }
        }, showBack: !isFaceUp)
            .foregroundColor(color.forgroundColor)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: ThemeColor = .plain("red")) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
    
}


