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
    
    @State public var lastChosenTheme: Theme? {
        didSet {
            withAnimation {
                if let lastChosenTheme = lastChosenTheme, lastChosenTheme != oldValue {
                    games[lastChosenTheme.id]?.restart()
                }
            }
        }
    }
    
    @State public var selectedTheme: Theme? {
        didSet {
            if let theme = selectedTheme {
                lastChosenTheme = theme
            }
        }
    }
    
    private func selectedThemeBinding() -> Binding<Theme?> {
        let binding = Binding<Theme?>(
            get: {
                selectedTheme
            },
            set: {
                selectedTheme = $0
            }
        )
        return binding
    }
    
    @State private var editMode: EditMode = .inactive
    
    @State private var themeToEdit: Theme?
    
    var body: some View {
        List {
            ForEach(store.themes) { theme in
                NavigationLink(tag: theme, selection: selectedThemeBinding(), destination: { destination(for: theme)} ) {
                    listRow(for: theme)
                }
                .disabled(isThemeDisabled(theme))
                .padding(.vertical, 10)
                .contentShape(Rectangle())
                .gesture(editMode == .active ? tap(theme) : nil)
            }
            .onDelete { indexSet in
                store.themes.remove(atOffsets: indexSet)
            }
        }
        .sheet(item: $themeToEdit) {
            if let theme = lastChosenTheme {
                withAnimation {
                    games[theme.id]?.theme = store.themes[theme]
                }
            }
        } content: { themeToEdit in
            ThemeEditor(theme: $store.themes[themeToEdit])
        }
        .listStyle(PlainListStyle())
        .compatibleNavigationTitle(with: LocalizedStringKey("Emoji Theme List"))
        .navigationBarItems(leading: editMode == .active ? nil : addButton, trailing: EditButton())
        .environment(\.editMode, $editMode)
        
    }
    
    private var addButton: some View {
        Button {
            themeToEdit = store.insertTheme(name: "New", emojis: "", color: ThemeColor(first: Color(UIColor.red)))
            lastChosenTheme = themeToEdit
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
    
    private func isThemeDisabled(_ theme: Theme) -> Bool {
        !(editMode == .inactive && theme.emojis.count >= Theme.minPairOfCardsCount  || editMode == .active)
    }
    
    private func listRow(for theme: Theme) -> some View {
        HStack {
            if let lastChosenTheme = lastChosenTheme, let game = games[theme.id], theme == lastChosenTheme, game.isPlaying {
                Rectangle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.green)
                    .compatibleOverlay {
                        Rectangle()
                            .stroke(Color.gray, lineWidth: 1)
                    }
                    .rotationEffect(Angle(degrees: 45))
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(theme.name).font(.headline)
                Text("number of cards: \(theme.numberOfPairOfCards)", comment: "how much of pairs of cards of the theme").font(.caption)
                Text(theme.emojis).lineLimit(1)
            }
            
            Spacer()
            
            let card = RoundedRectangle(cornerRadius: 5)
            Group {
                if let fillStyle = theme.color.fillStyle {
                    card.fill(fillStyle)
                } else {
                    card.fill(theme.color.forgroundColor)
                }
            }
            .opacity(0.8)
            .aspectRatio(2/3, contentMode: .fit)
            .frame(height: 60)
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
