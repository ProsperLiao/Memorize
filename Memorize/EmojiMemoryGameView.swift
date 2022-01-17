//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame
    
    init(viewModel: EmojiMemoryGame = EmojiMemoryGame()) {
        self.game = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            HStack {
                start
                Spacer()
                restart
            }
            .font(.largeTitle)
            .padding(.horizontal)
            Spacer()
            HStack {
                Text("\(game.theme.name)")
                    .font(.largeTitle)
                Text("\(game.score)")
                    .font(.largeTitle)
            }
            Spacer()
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                CardView(card: card, color: game.color, color2: game.color2)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            })
                        
//                    }
//                }
//                .foregroundColor(.red)
//            }
            
//            Spacer()
//            HStack {
//                Spacer()
//                vehichle
//                Spacer()
//                animal
//                Spacer()
//                food
//                Spacer()
//            }
//            .font(.largeTitle)
//            .padding(.horizontal)
            Spacer()
            
        }
        .padding(.horizontal)
        
    }
    
    var start: some View {
        Button {
            game.startNewGame()
        } label: {
            //Image(systemName: "calendar.badge.plus")
            Text("New Game")
                .font(.title)
        }
    }
    
    var restart: some View {
        Button {
            game.restartGame()
        } label: {
//            Image(systemName: "restart.circle")
            Text("Restart")
                .font(.title)
        }
    }
//
//    var vehichle: some View {
//        Button {
//            emojis = vehichles.shuffled()
//            emojiCount = Int.random(in: 4...emojis.count)
//        } label: {
//            VStack {
//                Image(systemName: "car")
//                Text("Vehichle").font(.body)
//            }
//
//        }
//    }
//
//    var animal: some View {
//        Button {
//            emojis = animals.shuffled()
//            emojiCount = Int.random(in: 4...emojis.count)
//        } label: {
//            VStack {
//                Image(systemName: "pawprint.circle")
//                Text("Animal").font(.body)
//            }
//        }
//    }
//
//    var food: some View {
//        Button {
//            emojis = foods.shuffled()
//            emojiCount = Int.random(in: 4...emojis.count)
//        } label: {
//            VStack {
//                Image(systemName: "heart.circle")
//                Text("Food").font(.body)
//            }
//        }
//    }
    
    func widthThatBestFits(cardCount: Int) -> CGFloat {
        return 65
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("12 Pro Max")
        EmojiMemoryGameView()
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("12 Pro Max Dark")
    }
}
