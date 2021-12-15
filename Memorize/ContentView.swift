//
//  ContentView.swift
//  Memorize
//
//  Created by Hongxing Liao on 2021/6/17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    init(viewModel: EmojiMemoryGame = EmojiMemoryGame()) {
        self.viewModel = viewModel
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
                Text("\(viewModel.theme.name)")
                    .font(.largeTitle)
                Text("\(viewModel.score)")
                    .font(.largeTitle)
            }
            Spacer()
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: viewModel.cards.count)))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, color: viewModel.color, color2: viewModel.color2)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
                .foregroundColor(.red)
            }
            
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
            viewModel.startNewGame()
        } label: {
            //Image(systemName: "calendar.badge.plus")
            Text("New Game")
                .font(.title)
        }
    }
    
    var restart: some View {
        Button {
            viewModel.restartGame()
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
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("12 Pro Max")
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("12 Pro Max Dark")
    }
}
