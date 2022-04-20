//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Hongxing Liao on 2022/3/25.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    @State var emojisToAdd: String = ""

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                numberOfCardsSection
                colorSection
                addEmojisSection
                emojisSection
                removedEmojisSection
            }
            .navigationBarItems(trailing: close)
            .navigationTitle("Edit \(theme.name)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var close: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark.circle")
        }
        .font(.system(size: 20))
        .foregroundColor(.gray)
    }
    
    var nameSection: some View {
        Section {
            TextField("", text: $theme.name)
        } header: {
            Text("Name")
        }
    }
    
    var addEmojisSection: some View {
        Section {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojisToAdd in
                    addEmojis(emojisToAdd)
                }
        } header: {
            Text("Add Emojis")
        }
    }
    
    var emojisSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.map({ String($0) }), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            if theme.emojis.count > 2 {
                                theme.emojis.removeAll {
                                    String($0) == emoji
                                }
                                theme.removedEmojis = (emoji + theme.removedEmojis) .withNoRepeatedCharacters
                            }
                        }
                }
            }
            .font(.system(size: 40))
        } header: {
            Text("Emojis")
        }
    }
    
    var removedEmojisSection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.removedEmojis.map({ String($0) }), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            theme.removedEmojis.removeAll {
                                String($0) == emoji
                            }
                            theme.emojis = (emoji + theme.emojis) .withNoRepeatedCharacters
                        }
                }
            }
            .font(.system(size: 40))
        } header: {
            Text("Removed Emojis")
        }
    }
    
    var colorSection: some View {
        Section {
            Toggle(isOn: $theme.color.isLinearGradient) {
                Text("Linear Gradient")
            }
            ColorPicker("First", selection: $theme.color.first)
            
            if theme.color.isLinearGradient {
                ColorPicker("Second", selection: $theme.color.second)
                let linearGradient = LinearGradient(colors: [theme.color.first, theme.color.second], startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 1, y: 1))
                Rectangle().fill(linearGradient)
            } else {
                Rectangle().fill(theme.color.first)
            }
        } header: {
            Text("Color")
        }
    }
    
    
    var numberOfCardsSection: some View {
        var rangeStart = Theme.minPairOfCardsCount
        if theme.emojis.count < Theme.minPairOfCardsCount {
            rangeStart = theme.emojis.count
        }
        return Section {
            Stepper(value: $theme.numberOfPairOfCards, in: rangeStart...theme.emojis.count) {
                Text("\(theme.numberOfPairOfCards)")
            }
        } header: {
            Text("Number of Pair of Cards:")
        }
    }
    
    private func addEmojis(_ emojisToAdd: String) {
        let emojis = emojisToAdd.filter({ $0.isEmoji})
        theme.emojis = (emojis + theme.emojis).withNoRepeatedCharacters
        theme.removedEmojis = theme.removedEmojis.filter ({ !emojis.contains($0) })
    }

}

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        let theme = ThemeStore(named: "test").theme(at: 2)
        ThemeEditor(theme: .constant(theme))
    }
}
