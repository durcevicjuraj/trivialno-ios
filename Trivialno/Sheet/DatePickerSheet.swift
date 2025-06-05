//
//  DatePickerSheet.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//

import SwiftUI

struct DatePickerSheet: View {
    @Binding var date: Date
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $date, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()

            Button("select") {
                isPresented = false
            }
            .padding()
        }
        .presentationDetents([.medium])
    }
}

