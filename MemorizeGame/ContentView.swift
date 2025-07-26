//
//  ContentView.swift
//  MemorizeGame
//
//  Created by Luidgi Varela Carneiro on 17/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var emojis: [String] = ["👻", "🎃", "🕷️", "😈","💀", "🕸️", "🧙🏻‍♀️", "🙀", "👹", "😱", "☠️", "🍭","👻", "🎃", "🕷️", "😈","💀", "🕸️", "🧙🏻‍♀️", "🙀", "👹", "😱", "☠️", "🍭"].shuffled()
    @State var cardCount: Int = 24
    
    @State var selectedIndices: [Int] = []  // Armazena os índices das cartas selecionadas
    @State var matchedIndices: [Int] = []   // Armazena os índices das cartas já combinadas
    
    var body: some View {
        VStack{
            Text("Memorize!")
                .font(.custom("Jersey 10", size: 50))
            
            ScrollView{
                cards
            }
            
            Button(action: {
                emojis.shuffle()
                selectedIndices = []
                matchedIndices = []
            }) {
                Text("Schuffle")
                    .font(.custom("Jersey 10", size: 35))
                    .padding()
                    .foregroundColor(.orange)
            }
        }
        .padding()
    }
    
    var cards: some View{
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]){
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index], isFaceUp: selectedIndices.contains(index) || matchedIndices.contains(index))
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        handleCardTap(at: index)
                    }
            }
        }
        .foregroundColor(.orange)
    }
    
    func handleCardTap(at index: Int) {
        // Se duas cartas já estiverem selecionadas, não permita mais seleções até que estejam ocultadas ou combinadas
        if selectedIndices.count == 2 {
            return
        }
        
        if !selectedIndices.contains(index) && !matchedIndices.contains(index) {
            selectedIndices.append(index)
        }
        
        if selectedIndices.count == 2 {
            let firstIndex = selectedIndices[0]
            let secondIndex = selectedIndices[1]
            
            if emojis[firstIndex] == emojis[secondIndex] {
                // Se as cartas forem iguais, adicione os índices ao matchedIndices
                matchedIndices.append(contentsOf: selectedIndices)
                selectedIndices = []
            } else {
                // Se as cartas forem diferentes, vire-as novamente após um atraso
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    selectedIndices = []
                }
            }
        }
    }
}

// Construtor da carta
struct CardView: View {
    let content: String
    var isFaceUp: Bool
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
    }
}

#Preview {
    ContentView()
}
