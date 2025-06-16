//
//  ResultView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import SwiftUI

struct ResultView: View {
    let score: Int
    let timeLeft: Int
    let used5050: Bool
    let usedSkip: Bool
    let usedDoublePoints: Bool
    let onPlayAgain: () -> Void
    
    @State private var animatedScore = 0
    @State private var animatedTimeLeft = 30
    @State private var show5050 = false
    @State private var showSkip = false
    @State private var showDP = false
    
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack{
            
            AdaptiveBackgroundView()
            
            VStack(spacing: 24) {
                Text("gameOver")
                    .font(.largeTitle)
                    .bold()
                
                Text("\(animatedScore) pts")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(score >= 0 ? Color.green : Color.red)
                    .monospacedDigit()
                
                HStack{
                Text("\(animatedTimeLeft)")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .monospacedDigit()
                    Text("secondsLeft")
                        .font(.system(size: 20))

                }
                .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .dark ? Color.darkBG: Color.lightBG)
                    )

                
                Text("powerUpsUsed")
                    .font(.system(size: 20))
                    .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorScheme == .dark ? Color.darkBG: Color.lightBG)
                        )
                
                HStack(spacing: 10) {
                    Spacer(minLength: 28)

                    Image(systemName: "circle.lefthalf.filled.inverse")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(show5050 && used5050 ? .green : .gray)
                        .animation(.easeOut(duration: 0.3), value: show5050)

                    Image(systemName: "arrowshape.right.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(showSkip && usedSkip ? .green : .gray)
                        .animation(.easeOut(duration: 0.3), value: showSkip)

                    Image(systemName: "figure.american.football.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(showDP && usedDoublePoints ? .green : .gray)
                        .animation(.easeOut(duration: 0.3), value: showDP)

                    Spacer(minLength: 0)
                }


                
                Button(action: onPlayAgain) {
                    Text("playAgain")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
                .padding(.top, 20)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                animateScore()
            }
        }
    }
    
    func animateScore() {
        let scoreSteps = score
        let scoreInterval = 2.0 / Double(scoreSteps)

        Timer.scheduledTimer(withTimeInterval: scoreInterval, repeats: true) { timer in
            if animatedScore < score {
                animatedScore += max(1, score / scoreSteps)
                if animatedScore > score {
                    animatedScore = score
                }
            } else {
                timer.invalidate()
                animateTimeLeft()
            }
        }
    }

    func animateTimeLeft() {
        let steps = 30 - timeLeft
        guard steps > 0 else { return }

        let interval = 1.0 / Double(steps)

        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if animatedTimeLeft > timeLeft {
                animatedTimeLeft -= 1
            } else {
                timer.invalidate()
                revealUsedIcons()
            }
        }
    }
    
    func revealUsedIcons() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            show5050 = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showSkip = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            showDP = true
        }
    }


}

#Preview {
    ResultView(score: 50, timeLeft: 10, used5050: true, usedSkip: false, usedDoublePoints: true, onPlayAgain: {})
}
