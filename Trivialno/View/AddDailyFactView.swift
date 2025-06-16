//
//  AddDailyFact.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import SwiftUI

struct AddDailyFactView: View {
    
    @StateObject private var viewModel = AddDailyFactViewModel()
    
    @State private var factEN: String = ""
    @State private var factHR: String = ""
    @State private var statusMessage: String?


    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("English")) {
                    TextField("Fact (EN)", text: $factEN)
                }

                // Croatian section
                Section(header: Text("Hrvatski")) {
                    TextField("Činjenica (HR)", text: $factHR)
                }
                
                Button("addFact") {
                    
                    let fact = DailyFact(
                        text: [
                            "en": factEN,
                            "hr": factHR
                        ]
                    )

                    viewModel.addFact(fact) { result in
                        switch result {
                        case .success:
                            statusMessage = "✅ Fact added successfully."
                            clearForm()
                        case .failure(let error):
                            statusMessage = "❌ Error: \(error.localizedDescription)"
                        }
                    }
                }
                .disabled(!isFormValid)
            }
        }
    }
    
    
    private var isFormValid: Bool {
        !factEN.isEmpty &&
        !factHR.isEmpty
    }

    private func clearForm() {
        factEN = ""
        factHR = ""
    }
}

#Preview {
    AddDailyFactView()
}
