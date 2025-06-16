//
//  MainMenuButtonStyle.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 06.06.2025..
//

import SwiftUI
import Foundation

struct MainMenuButtonStyle: ButtonStyle {
    private enum Shape {
        case rectangle
        case ellipse
    }
    
    private var foregroundColor: Color
    private var backgroundColor: Color
    private var shape: Shape
    private var cornerRadius: CGFloat = 0
    private var yOffseet: CGFloat {
        shape == .rectangle ? 4 : 8
    }
    
    //Initialiser for rectangular button
    init(foregroundColor: Color, backgroundColor: Color, cornerRadius: CGFloat) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.shape = .rectangle
        self.cornerRadius = cornerRadius
    }
    
    //Initialiser for ellipse button
    init (foregroundColor: Color, backgroundColor: Color) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.shape = .ellipse
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            buttonShape(color: backgroundColor)
            buttonShape(color: foregroundColor)
                .offset(y: configuration.isPressed ? 0 : -yOffseet)
            configuration.label
                .foregroundStyle(backgroundColor)
                .offset(y: yOffseet)
                .offset(y: configuration.isPressed ? yOffseet : 0)
        }
    }
    
    @ViewBuilder
    private func buttonShape(color: Color) -> some View {
        switch shape{
        case .rectangle:
            RoundedRectangle(cornerRadius: cornerRadius).fill(color)
        case .ellipse:
            Ellipse().fill(color)
        }
    }
}

