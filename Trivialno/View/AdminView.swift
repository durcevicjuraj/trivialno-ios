//
//  AdminView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 05.06.2025..
//

import SwiftUI

struct AdminView: View {
    
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AddQuestionView()) {
                    Label("addQuestion", systemImage: "plus.circle")
                }

                NavigationLink(destination: BrowseQuestionsView()) {
                    Label("browseQuestions", systemImage: "pencil.circle")
                }

                NavigationLink(destination: BrowseUsersView()) {
                    Label("browseUsers", systemImage: "person.2.badge.gearshape.fill")
                }
                
                NavigationLink(destination: AddDailyFactView()) {
                    Label("addDailyFact", systemImage: "sunrise.fill")
                }
            }
            .navigationTitle("adminPanel")
        }
    }
}

#Preview {
    AdminView()
}
