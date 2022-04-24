//
//  CompatibleViewModifier.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/4/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func compatibleNavigationTitle(with text: LocalizedStringKey, displayMode: NavigationBarItem.TitleDisplayMode = .inline) -> some View {
        if #available(iOS 14, *) {
            self.navigationTitle(text)
                .navigationBarTitleDisplayMode(displayMode)
        }
        else {
            self.navigationBarTitle(Text(text), displayMode: displayMode)
        }
    }
    
    @ViewBuilder
    func compatibleOverlay<V>(alignment: Alignment = .center, content: () -> V) -> some View where V: View {
        if #available(iOS 15, *) {
            self.overlay(alignment: alignment, content: content)
        } else {
            self.overlay(content(), alignment: alignment)
        }
    }
}
