//
//  CountryPickerSheet.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 04.06.2025..
//
import SwiftUI

struct CountryPickerSheet: View {
    @Binding var selectedCountry: String
    @Binding var isPresented: Bool

    private let countryRegions: [Locale.Region] = {
        Locale.Region.isoRegions
            .filter { $0.identifier.count == 2 && $0.identifier.uppercased() == $0.identifier }
            .sorted {
                let name1 = Locale.current.localizedString(forRegionCode: $0.identifier) ?? $0.identifier
                let name2 = Locale.current.localizedString(forRegionCode: $1.identifier) ?? $1.identifier
                return name1 < name2
            }
    }()


    var body: some View {
        VStack {
            Picker("Country", selection: $selectedCountry) {
                ForEach(countryRegions, id: \.identifier) { region in
                    let code = region.identifier
                    let name = Locale.current.localizedString(forRegionCode: code) ?? code
                    let flag = flagEmoji(for: code)
                    Text("\(flag) \(name)").tag(code)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(maxHeight: 200)
            .clipped()

            Button("Done") {
                isPresented = false
            }
            .padding()
        }
        .presentationDetents([.medium])
    }

    // ✅ Flag emoji generator
    private func flagEmoji(for countryCode: String) -> String {
        countryCode
            .uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(127397 + $0.value) }
            .map { String($0) }
            .joined()
    }
}
