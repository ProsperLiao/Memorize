//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/3/22.
//
// Theme's View

import SwiftUI

struct ThemeChooser: View {
    @EnvironmentObject var store: ThemeStore
    
    @State private var games = [Int: EmojiMemoryGame]()
    
    @State private var lastChoosenTheme: Theme?
    
    var body: some View {
        List {
            ForEach(store.themes) { theme in
                let row = NavigationLink {
                    destination(for: theme)
                        .onAppear {
                            if (lastChoosenTheme != theme) {
                                games[theme.id]?.restart()
                                lastChoosenTheme = theme
                            }
                        }
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(theme.name)
                            Spacer()
                            Text("emojis: \(theme.emojis.count)")
                        }
                        Text(theme.emojis.reduce(""){ $0 + $1 })
                    }
                }
                
                if let fillStyle = theme.color.fillStyle {
                    row.listRowBackground(fillStyle)
                } else {
                    row.listRowBackground(theme.color.forgroundColor)
                }
            }
        }
            .listStyle(PlainListStyle())
            .navigationTitle("Emoji Theme List")
            .navigationBarTitleDisplayMode(.inline)
        
    }
    
    private func destination(for theme: Theme) -> some View {
        if let game = games[theme.id] {
            return EmojiMemoryGameView(viewModel: game)
        } else {
            let game = EmojiMemoryGame(with: theme)
            games[theme.id] = game
            return EmojiMemoryGameView(viewModel: game)
        }
    }
}

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        let store = ThemeStore(named: "preview")
        ThemeChooser()
            .environmentObject(store)
    }
}
