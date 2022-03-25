//
//  ThemeStore.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/3/22.
//
// Theme's ViewModel

import SwiftUI

struct Theme: Equatable, Identifiable {
    let id: Int
    let name: String
    let emojis: Set<String>
    let color: ThemeColor
    let defaultNumberOfPair: Int?
    
    fileprivate init(id: Int, name: String, emojis: Set<String>, color: ThemeColor, defaultNumberOfPair: Int? = nil) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.defaultNumberOfPair = defaultNumberOfPair
        self.id = id
    }
}

enum ThemeColor: Equatable {
    case plain(String)
    case gradient(String, String)
    
    var forgroundColor: Color {
        switch self {
        case .plain(let color):
            return parseColor(color)
        case .gradient(let first, _):
            return parseColor(first)
        }
    }
    
    var fillStyle: LinearGradient? {
        switch self {
        case .plain:
            return nil
        case .gradient(let first, let second):
            return LinearGradient.init(colors: [parseColor(first), parseColor(second)], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1))
        }
    }
    
    private func parseColor(_ color: String) -> Color {
        switch color {
        case "black":
            return .black
        case "blue":
            return .blue
        case "gray":
            return .gray
        case "green":
            return .green
        case "orange":
            return .orange
        case "pink":
            return .pink
        case "purple":
            return .purple
        case "white":
            return .white
        case "yellow":
            return .yellow
        default:
            return .red
        }
    }
    
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes = [Theme]()
    
    init(named name: String) {
        self.name = name
        
        if themes.isEmpty {
            insertTheme(name: "Vehichle", emojis: Set(["🚗", "🚕", "🚙", "🚓", "🚌", "🚎", "🚑", "🏎", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔", "🚍", "🚘", "🚖", "✈️", "🛫", "🛬", "🛥", "🛳", "⛴"]), color: .plain("yellow"), defaultNumberOfPair: 2)
            insertTheme(name: "Animals", emojis: Set(["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐧", "🐦", "🐤", "🐣", "🐥"]), color: .plain("blue"), defaultNumberOfPair: 8)
            insertTheme(name: "Food", emojis: Set(["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶", "🫑", "🌽", "🥕"]), color: .gradient("green", "purple"), defaultNumberOfPair: 20)
            insertTheme(name: "Halloween", emojis: Set(["😈", "👹", "👺", "🤡", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "🎃"]), color: .plain("gray"), defaultNumberOfPair: nil)
            insertTheme(name: "Ball", emojis: Set(["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉"]), color: .gradient("red", "blue"))
            insertTheme(name: "Flag", emojis: Set(["🚩", "🏳️‍🌈", "🇦🇴", "🇧🇸", "🇧🇼", "🇧🇧", "🇻🇬", "🇧🇳", "🇨🇦", "🇨🇳", "🇨🇽", "🇨🇨", "🇰🇲", "🇨🇬", "🇪🇪", "🇪🇨", "🇨🇷", "🇨🇰", "🇧🇫", "🇧🇯"]), color : .plain("purple"))
        }
    }
    
    // MARK: - Intent(s)
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(0, index), themes.count - 1)
        return themes[safeIndex]
    }
    
    func insertTheme(name: String, emojis: Set<String>, color: ThemeColor, defaultNumberOfPair: Int? = nil, at index: Int = 0) {
        let uniqueThemeId = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(id: uniqueThemeId, name: name, emojis: emojis, color: color, defaultNumberOfPair: defaultNumberOfPair)
        let safeIndex = min(max(0, index), themes.count)
        themes.insert(theme, at: safeIndex)
    }
}



