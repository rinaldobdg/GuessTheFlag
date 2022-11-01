//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Benny Rinaldo on 26/10/22.
//

import SwiftUI

struct ContentView: View {
   
    @State private var showingScore = false    //the alert is showing
    @State private var scoreTitle = ""  //title to be shown in the alert
    @State private var userScore = 0  //the user's score playing the game
    @State private var gameFinished = false   //the game is finished after 8 questions completed
    @State private var totalPlayed = 0 // tracking the number of questions answered
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2) //decide which country flag should be tapped
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag").font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number]).renderingMode(.original)
                                .clipShape(Capsule()).shadow(radius: 5)}
                    }
                    
                    Button("Restart") {
                        gameFinished = true
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Text("Total Guessed: \(totalPlayed)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
            //Text("Well done!")
        }
        .alert("Restarting", isPresented: $gameFinished) {
            Button("Restart", action: reset)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your final score is \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if totalPlayed == (8-1) {
            gameFinished = true
        }
        else {
            if number == correctAnswer {
                scoreTitle = "Correct!"
                userScore += 1
            } else {
                scoreTitle = "Wrong! That is the flag of  \(countries[number])"
            }
        }
        
        totalPlayed += 1
        showingScore = true
    }
    
    //resets the game by shuffling up the countries and picking a new correct answer
    func askQuestion() {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
            scoreTitle = "You have finished all 8 guesses"
            userScore = 0
            totalPlayed = 0
            countries.shuffle()
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
