//
//  Pie.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/1/21.
//

import SwiftUI

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2.0
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        path.addLine(to: center)
        return path
    }
}

struct Pie_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Pie(startAngle: Angle(degrees: -90), endAngle: Angle(degrees:  -150)).stroke(Color.blue)
        }
    }
}
