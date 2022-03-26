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
    
    @State private var editMode: EditMode = .inactive
    
    @State private var themeToEdit: Theme?
    
    var body: some View {
        List {
            ForEach(store.themes) { theme in
                let row = NavigationLink (
                    destination: destination(for: theme)
                        .onAppear {
                            if (lastChoosenTheme != theme) {
                                withAnimation {
                                    games[theme.id]?.restart()
                                }
                                lastChoosenTheme = theme
                            }
                        }
                ) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(theme.name)
                            Spacer()
                            Text("number of cards: \(theme.numberOfPairOfCards)")
                        }
                        Text(theme.emojis)
                    }
                    .gesture(editMode == .active ? tap(theme) : nil)
                    
                }
                
                if let fillStyle = theme.color.fillStyle {
                    row.listRowBackground(fillStyle)
                } else {
                    row.listRowBackground(theme.color.forgroundColor)
                }
            }
            .onDelete { indexSet in
                store.themes.remove(atOffsets: indexSet)
            }
        }
        .sheet(item: $themeToEdit) {
            if let theme = lastChoosenTheme {
                withAnimation {
                    games[theme.id]?.theme = store.themes[theme]
                }
            }
        } content: { themeToEdit in
            ThemeEditor(theme: $store.themes[themeToEdit])
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Emoji Theme List")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: addButton, trailing: EditButton())
        .environment(\.editMode, $editMode)
        
    }
    
    private var addButton: some View {
        Button {
            themeToEdit = store.insertTheme(name: "New", emojis: "", color: ThemeColor(first: Color(UIColor.red)))
        } label: {
            Image(systemName: "plus")
        }
        
    }
    
    private func tap(_ theme: Theme) -> some Gesture {
        TapGesture().onEnded {
            themeToEdit = theme
        }
    }
    
    private func destination(for theme: Theme) -> some View {
        if let game = games[theme.id] {
            return EmojiMemoryGameView(viewModel: game)
        } else {
            let game = EmojiMemoryGame(with: theme)
            DispatchQueue.main.async {
                games.updateValue(game, forKey: theme.id)
            }
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
