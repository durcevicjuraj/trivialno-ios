//
//  String+FlagEmoji.swift
//  Trivialno
//
//  Created by Juraj Đurčević on 06.06.2025..
//

import Foundation

extension String {
    var flagEmoji: String {
        let base: UInt32 = 127397
        return self.uppercased().unicodeScalars.compactMap {
            UnicodeScalar(base + $0.value)
        }.map { String($0) }.joined()
    }
}
