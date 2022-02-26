//
//  FlipView.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/2/20.
//

import SwiftUI

struct FlipView<FrontViewType: View, BackViewType: View>: View {
    @ViewBuilder var front: FrontViewType
    @ViewBuilder var back: BackViewType
    
    @State private var flipped = false
    var showBack: Bool
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                front.opacity(flipped ? 0 : 1)
                back.opacity(flipped ? 1 : 0)
            }
            .flipEffect(flipped: $flipped, angle: showBack ? 180 : 0, axis: (x: 0, y: 1))
            Spacer()
        }
    }
}

struct FlipEffect: GeometryEffect {
    
    var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }
    
    @Binding var flipped: Bool
    var angle: Double
    let axis: (x: CGFloat, y: CGFloat)
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        DispatchQueue.main.async {
            self.flipped = self.angle >= 90 && self.angle < 270
        }
        
        let tweakedAngle = flipped ? -180 + angle : angle
        let a = CGFloat(Angle(degrees: tweakedAngle).radians)
        
        var transform3d = CATransform3DIdentity;
        transform3d.m34 = -1/max(size.width, size.height)
        
        transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
}
    
extension View {
    func flipEffect(flipped: Binding<Bool>, angle: Double, axis: (x: CGFloat, y: CGFloat)) -> some View {
        self.modifier(FlipEffect(flipped: flipped, angle: angle, axis: axis))
    }
    
}
