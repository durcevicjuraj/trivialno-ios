//
//  PlayViewModel.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//
import Foundation
import SwiftUI
import FirebaseFirestore
import UserNotifications

class PlayViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var selectedAnswer: Int? = nil
    @Published var showAnswers: Bool = false
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 30
    @Published var gameFinished = false
    @Published var usedDoublePoints = false
    @Published var used5050 = false
    @Published var usedSkip = false
    @Published var usedDoublePointsOverall = false
    private var used5050Overall = false
    private var usedSkipOverall = false
    @Published var hiddenAnswers: Set<Int> = []
    var userManager: UserManager?

    private var timer: Timer?

    var currentQuestion: Question? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var effectivePoints: Int {
        score * timeRemaining
    }

    func fetchQuestions() {
        let db = Firestore.firestore()
        db.collection("questions").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            let all: [Question] = documents.compactMap { doc in
                let data = doc.data()
                guard
                    let categoryRaw = data["category"] as? String,
                    let typeRaw = data["type"] as? String,
                    let difficultyRaw = data["difficulty"] as? String,
                    let question = data["question"] as? [String: String],
                    let correctAnswer = data["correct_answer"] as? [String: String],
                    let allAnswers = data["all_answers"] as? [String: [String]],
                    let category = QuestionCategory(rawValue: categoryRaw),
                    let type = QuestionType(rawValue: typeRaw),
                    let difficulty = QuestionDifficulty(rawValue: difficultyRaw)
                else {
                    return nil
                }

                return Question(
                    id: doc.documentID,
                    category: category,
                    type: type,
                    difficulty: difficulty,
                    question: question,
                    correct_answer: correctAnswer,
                    all_answers: allAnswers
                )
            }.shuffled()

            DispatchQueue.main.async {
                self.questions = Array(all.prefix(5))
                self.startTimer()
            }
        }
    }

    func startTimer() {
        stopTimer()
        timeRemaining = 30
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                DispatchQueue.main.async {
                    self.finishGame()
                }
            }
        }
    }


    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func resetGame() {
        stopTimer()
        questions = []
        currentIndex = 0
        selectedAnswer = nil
        score = 0
        timeRemaining = 30
        gameFinished = false
        usedDoublePoints = false
        used5050 = false
        usedSkip = false
        hiddenAnswers = []
        fetchQuestions()
        usedDoublePointsOverall = false
        used5050Overall = false
        usedSkipOverall = false
    }

    func selectAnswer(text: String) {
        guard let question = currentQuestion else { return }
        guard let lang = Locale.current.language.languageCode?.identifier,
              let correct = question.correct_answer[lang]
        else { return }

        selectedAnswer = question.all_answers[lang]?.firstIndex(of: text)
        showAnswers = true

        let earned = usedDoublePoints ? question.points * 2 : question.points

        if text == correct {
            score += earned
        } else {
            score = max(0, score - 5) // subtract 5, but don't go below 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.nextQuestion()
        }
    }

    func nextQuestion() {
        selectedAnswer = nil
        showAnswers = false
        usedDoublePoints = false
        hiddenAnswers = []
        currentIndex += 1
        if currentIndex >= questions.count {
            finishGame()
        }
    }
    
    func sendRankChangeNotification(newRank: UserRank) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("newRankTitle", comment: "")
        content.body = String(format: NSLocalizedString("newRankBody", comment: ""), newRank.localizedName)
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }


    func finishGame() {
        stopTimer()
        gameFinished = true
        selectedAnswer = nil
        showAnswers = false
        
        if let userManager = userManager,
           var user = userManager.currentUser {

            let newEntry = ScoreEntry(
                score: score,
                date: Date(),
                used5050: used5050Overall,
                usedSkip: usedSkipOverall,
                usedDP: usedDoublePointsOverall,
                questionsAnswered: questions.count
            )
            
            if(score >= 50){
                user.elo += 10
            }
            else if(score >= 25){
                user.elo += 5
            }
            else if(score >= 10){
                user.elo += 1
            }
            else if(score >= 0){
                user.elo -= 5
            }
            else{
                user.elo -= 10
            }
            
            if (user.elo < 0){
                user.elo = 0
            }
            
            let previousRank = user.rank
            
            // Rank up or down check
            if(user.elo >= 1000 && user.rank != .quizmaster){
                user.rank = .quizmaster
            }
            else if(user.elo >= 800 && user.elo < 1000 && user.rank != .diamond){
                user.rank = .diamond
            }
            else if(user.elo >= 600 && user.elo < 800 && user.rank != .platinum){
                user.rank = .platinum
            }
            else if(user.elo >= 400 && user.elo < 600 && user.rank != .gold){
                user.rank = .gold
            }
            else if(user.elo >= 200 && user.elo < 400 && user.rank != .silver){
                user.rank = .silver
            }
            else if(user.elo < 200 && user.rank != .bronze){
                user.rank = .bronze
            }
            
            if user.rank != previousRank {
                sendRankChangeNotification(newRank: user.rank)
            }
            
            
            user.scores.append(newEntry)
            userManager.currentUser = user

            // Save updated user to Firestore
            do {
                try Firestore.firestore().collection("users").document(user.uid).setData(from: user)
                print("✅ Score saved to Firestore")
            } catch {
                print("❌ Failed to save score: \(error.localizedDescription)")
            }
        }
    }


    func use5050() {
        guard let question = currentQuestion,
              let lang = Locale.current.language.languageCode?.identifier,
              let correct = question.correct_answer[lang],
              let all = question.all_answers[lang],
              !used5050 else { return }

        used5050 = true
        used5050Overall = true
        let wrong = all.enumerated().filter { $0.element != correct }.map { $0.offset }.shuffled()
        hiddenAnswers = Set(wrong.prefix(2))
    }

    func useSkip() {
        guard !usedSkip else { return }
        usedSkip = true
        usedSkipOverall = true
        nextQuestion()
    }

    func useDoublePoints() {
        guard !usedDoublePoints else { return }
        usedDoublePoints = true
        usedDoublePointsOverall = true
    }
    
    func shuffleAnswersForCurrentQuestion() {
        guard let question = currentQuestion,
              let lang = Locale.current.language.languageCode?.identifier,
              var answers = question.all_answers[lang] else { return }

        // Step 1: get the hidden answer strings
        let originalAnswers = answers
        let hiddenAnswerStrings = hiddenAnswers.map { originalAnswers[$0] }

        // Step 2: shuffle the answers
        answers.shuffle()
        questions[currentIndex].all_answers[lang] = answers

        // Step 3: find new indexes for the same hidden answers
        hiddenAnswers = Set(
            answers.enumerated()
                .filter { hiddenAnswerStrings.contains($0.element) }
                .map { $0.offset }
        )

        selectedAnswer = nil
        showAnswers = false
    }

}
