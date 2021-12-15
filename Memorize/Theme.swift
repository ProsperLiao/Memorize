//
//  Theme.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/10/4.
//

import Foundation

struct Theme {
    static let themes = [
         Theme(name: "Vehichle", emojis: Set(["🚗", "🚕", "🚙", "🚓", "🚌", "🚎", "🚑", "🏎", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🚲", "🛵", "🏍", "🛺", "🚨", "🚔", "🚍", "🚘", "🚖", "✈️", "🛫", "🛬", "🛥", "🛳", "⛴"]), color: "yellow", defaultNumberOfPair: 2),
         Theme(name: "Animals", emojis: Set(["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🙈", "🙉", "🙊", "🐒", "🐔", "🐧", "🐦", "🐤", "🐣", "🐥"]), color: "blue", defaultNumberOfPair: 8),
         Theme(name: "Food", emojis: Set(["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥥", "🥝", "🍅", "🍆", "🥑", "🥦", "🥬", "🥒", "🌶", "🫑", "🌽", "🥕"]), color: "green", color2: "purple", defaultNumberOfPair: 20),
         Theme(name: "Halloween", emojis: Set(["😈", "👹", "👺", "🤡", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "🎃"]), color: "gray", defaultNumberOfPair: nil),
         Theme(name: "Ball", emojis: Set(["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉"]), color: "red", defaultNumberOfPair: 3),
         Theme(name: "Flag", emojis: Set(["🚩", "🏳️‍🌈", "🇦🇴", "🇧🇸", "🇧🇼", "🇧🇧", "🇻🇬", "🇧🇳", "🇨🇦", "🇨🇳", "🇨🇽", "🇨🇨", "🇰🇲", "🇨🇬", "🇪🇪", "🇪🇨", "🇨🇷", "🇨🇰", "🇧🇫", "🇧🇯"]), color: "purple")
     ]
    
    let name: String
    let emojis: Set<String>
    let color: String
    let color2: String?
    let defaultNumberOfPair: Int?
    
    init(name: String, emojis: Set<String>, color: String, color2: String? = nil, defaultNumberOfPair: Int?) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.color2 = color2
        self.defaultNumberOfPair = defaultNumberOfPair
    }
    
    init(name: String, emojis: Set<String>, color: String,color2: String? = nil) {
        self.name = name
        self.emojis = emojis
        self.defaultNumberOfPair = emojis.count
        self.color = color
        self.color2 = color2
    }
}
