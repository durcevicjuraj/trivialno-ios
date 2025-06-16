//
//  ShakeDetector.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 11.06.2025..
//

import SwiftUI
import UIKit

struct ShakeListener: UIViewControllerRepresentable {
    var onShake: () -> Void

    func makeUIViewController(context: Context) -> ShakeListenerController {
        let controller = ShakeListenerController()
        controller.onShake = onShake
        return controller
    }

    func updateUIViewController(_ uiViewController: ShakeListenerController, context: Context) {}

    class ShakeListenerController: UIViewController {
        var onShake: (() -> Void)?

        override var canBecomeFirstResponder: Bool { true }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            becomeFirstResponder()
        }

        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                onShake?()
            }
        }
    }
}
