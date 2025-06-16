//
//  BackgroundView.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 10.06.2025..
//

import SwiftUI

struct AdaptiveBackgroundView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
                Image(colorScheme == .dark ? "darkBackground" : "lightBackground")
                    .ignoresSafeArea()
            }
}



