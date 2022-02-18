//
//  Cardify.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/2/14.
//

import SwiftUI

struct Cardify: ViewModifier  {
    
    var isFaceUp: Bool
    var color: Color  // 前景色
    var color2: Color?  // 前景色的线性渐变
    
    func body(content: Content) -> some View {
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    content
                } else {
                    if let color2 = color2 {
                        shape.fill(LinearGradient.init(colors: [color, color2], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1)))
                            
                    } else {
                        shape.fill()
                           
                    }
                    
                }
            }.foregroundColor(color)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: Color = .red, color2: Color? = nil) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color: color, color2: color2))
    }
    
}


