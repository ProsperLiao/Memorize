//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let store = ThemeStore(named: "default")
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ThemeChooser()
                    .environmentObject(store)
                Text("Please select theme", comment: "Tip for user to select a theme when start this app")
                    .font(.largeTitle)
            }
        }
    }
}
