//
//  ThemeStore.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/3/22.
//
// Theme's ViewModel

import SwiftUI

struct ThemeConstants {
    static let pairsOfCardsLimit = 15
}

struct Theme: Equatable, Identifiable, Hashable, Codable {
    static let minPairOfCardsCount = 2
    
    let id: Int
    var name: String
    var emojis: String {
        didSet {
            if numberOfPairOfCards > emojis.count || emojis.count <= Theme.minPairOfCardsCount {
                numberOfPairOfCards = emojis.count
            }
        }
    }
    var removedEmojis: String = ""
    var color: ThemeColor
    var numberOfPairOfCards: Int
    
    fileprivate init(id: Int, name: String, emojis: String, color: ThemeColor, numberOfPairOfCards: Int) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfPairOfCards = numberOfPairOfCards
        self.id = id
    }
}

struct ThemeColor: Equatable, Hashable, Codable {
    var first: Color = Color(UIColor.red)
    var second: Color = Color(UIColor.red)
    var isLinearGradient: Bool
    
    enum CodingKeys: String, CodingKey {
        case first, second, isLinearGradient
    }
    
    func encode(to encoder: Encoder) throws {
        let firstRGBA = RGBAColor(color: first)
        let secondRGBA = RGBAColor(color: second)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstRGBA, forKey: .first)
        try container.encode(secondRGBA, forKey: .second)
        try container.encode(isLinearGradient, forKey: .isLinearGradient)
    }
    
    init(first: Color, second: Color = .red, isLinearGradient: Bool = false) {
        self.first = first
        self.second = second
        self.isLinearGradient = isLinearGradient
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let firstRGBA = try container.decode(RGBAColor.self, forKey: .first)
        let secondRGBA = try container.decode(RGBAColor.self, forKey: .second)
        isLinearGradient = try container.decode(Bool.self, forKey: .isLinearGradient)
        first = Color(rgbaColor: firstRGBA)
        second = Color(rgbaColor: secondRGBA)
    }
}

extension ThemeColor {
    var forgroundColor: Color {
        first
    }
    
    var fillStyle: LinearGradient? {
        if isLinearGradient {
            return LinearGradient(colors: [first, second], startPoint: .init(x: 0, y: 0), endPoint: .init(x: 0, y: 1))
        } else {
            return nil
        }
    }
}

class ThemeStore: ObservableObject {
    let name: String
    
    private var autoSaveTimer: Timer?
    
    @Published var themes = [Theme]() {
        didSet {
            scheduledSave()
        }
    }
    
    struct Constants {
        static let autoSaveTimeInterval = 5.0
    }
    
    
    init(named name: String) {
        self.name = name
        
        restoreFromUserDefault()
        
        if themes.isEmpty {
            print("using built-in themes")
            insertTheme(name: "Vehichle", emojis: ["🚗", "🚕", "🚙", "🚓", "🚌", "🚎", "🚑", "🏎", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔", "🚍", "🚘", "🚖", "✈️", "🛫", "🛬", "🛥", "🛳", "⛴"].reduce("", {$0 + $1}), color: ThemeColor(first: Color(UIColor.yellow)), numberOfPairOfCards: 2)
            insertTheme(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐧", "🐦", "🐤", "🐣", "🐥"].reduce("", {$0 + $1}), color: ThemeColor(first: Color(UIColor.blue)), numberOfPairOfCards: 8)
            insertTheme(name: "Food", emojis: ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶", "🫑", "🌽", "🥕"].reduce("", {$0 + $1}), color: ThemeColor(first: Color(UIColor.green), second: Color(UIColor.purple), isLinearGradient: true), numberOfPairOfCards: 20)
            insertTheme(name: "Halloween", emojis: ["😈", "👹", "👺", "🤡", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "🎃"].reduce("", {$0 + $1}), color: ThemeColor(first: Color(UIColor.gray)), numberOfPairOfCards: nil)
            insertTheme(name: "Ball", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉"].reduce("", {$0 + $1}), color: ThemeColor(first: Color(UIColor.red), second: Color(UIColor.blue), isLinearGradient: true))
            insertTheme(name: "Flag", emojis: ["🚩", "🏳️‍🌈", "🇦🇴", "🇧🇸", "🇧🇼", "🇧🇧", "🇻🇬", "🇧🇳", "🇨🇦", "🇨🇳", "🇨🇽", "🇨🇨", "🇰🇲", "🇨🇬", "🇪🇪", "🇪🇨", "🇨🇷", "🇨🇰", "🇧🇫", "🇧🇯"].reduce("", {$0 + $1}), color : ThemeColor(first: Color(UIColor.purple)))
            insertTheme(name: "Emoji", emojis: "😀🥹😅😂🤣😊😇🙃😉😍🥰😋😙😜🧐😎🤩🥳😟😕😡🤬🤯😳🥵🥶😱😭😓🤗🤮😵‍💫😬😪", color: ThemeColor(first: Color(UIColor.gray)))
        } else {
            print("Successfully loaded from UserDefault. Themes: \(themes)")
        }
    }
    
    private var userDefaultKey: String {
        "Memorize::userDefaultKek:\(name)"
    }
    
    private func scheduledSave() {
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: Constants.autoSaveTimeInterval, repeats: false) { _ in
            self.autoSave()
            self.autoSaveTimer = nil
        }
    }
    
    private func autoSave() {
        if let json = try? JSONEncoder().encode(themes) {
            UserDefaults.standard.set(json, forKey: userDefaultKey)
        }
    }
    
    private func restoreFromUserDefault() {
        if let data = UserDefaults.standard.data(forKey: userDefaultKey), let decodedThemes = try? JSONDecoder().decode([Theme].self, from: data) {
            themes = decodedThemes
        }
    }
    
    // MARK: - Intent(s)
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(0, index), themes.count - 1)
        return themes[safeIndex]
    }
    
    @discardableResult
    func insertTheme(name: String, emojis: String, color: ThemeColor, numberOfPairOfCards: Int? = nil, at index: Int = 0) -> Theme {
        let uniqueThemeId = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        var numberOfPair = numberOfPairOfCards ?? emojis.count
        numberOfPair = min(max(0, numberOfPair), min(ThemeConstants.pairsOfCardsLimit, emojis.count))
        let safeEmojis = emojis.withNoRepeatedCharacters.filter({ $0.isEmoji })
        let theme = Theme(id: uniqueThemeId, name: name, emojis: safeEmojis, color: color, numberOfPairOfCards: numberOfPair)
        let safeIndex = min(max(0, index), themes.count)
        themes.insert(theme, at: safeIndex)
        return theme
    }
    
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 2, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
}



