//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yau Chin Pang on 5/12/2023.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var questionAnswered = 0
    @State private var gameEnded = false
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    
    var body: some View {
        // VStack = vertical
        // HStack = horizontal
        // ZStack = depth (from top to bottom)
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ],center: .top ,startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            // .ignoresSafeArea() to ignore the chin, forehead
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        // Color.red <- set the entire stack bkg to be red
                        // it is treated as its own view!! and automatically expand to the whole space
                        // Spacer() = takes up the whole space
                        
                        // background(.blue.gradient) -> the blue color at the top is subtle, while growing darker towards the end
                        
                        // button: role: .destructive (affects styling + accessibility)
                        // buttonStyle (.bordered, .borderedProminent)
                        // these are system standard
                        // label: Label("text", systemImage: "SFIcon") <- smart, automatically decides on what to show, icon  or text?
                        
                        Text("Tap the text of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                            .fontWeight(.heavy)
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flaggedTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }.padding()
            
        }.alert("Game ended", isPresented: $gameEnded) {
            Button("Reset", action: reset)
        } message: {
            Text("Your final result is \(score)")
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestions)
        } message: {
            Text(scoreMessage)
        }
    }
    
    func flaggedTapped(_ number: Int) {
        questionAnswered += 1
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
        } else {
            score -= 1
            scoreTitle = "Wrong"
            scoreMessage = "That's the flag of \(countries[number])"
        }
        if questionAnswered == 8 {
            gameEnded = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestions() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        questionAnswered = 0
        score = 0
        askQuestions()
    }
}

#Preview {
    ContentView()
}
