//
//  GeneralUseFunctions.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

import Foundation
import SwiftUI

func getCurrentUsuario() -> (usuarioId: Int, token: String)? {
    if let token = UserDefaults.standard.string(forKey: "token") {
        let usuarioId = UserDefaults.standard.integer(forKey: "usuarioId")

        if usuarioId != 0 {
            return (usuarioId: usuarioId, token: token)
        }
    }
    return nil
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 4), (int >> 4) & 0xF, int & 0xF)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
