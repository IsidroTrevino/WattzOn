//
//  TipsModel.swift
//  WattzOn
//
//  Created by Debanhi Medina on 07/11/24.
//


import SwiftUI

struct TipsModel: Identifiable, Equatable, Hashable {
    let id = UUID()
    let tipName: String
    let description: String
    let estrategia1: String
    let textEs1: String
    let estrategia2: String
    let textEs2: String
    let estrategia3: String
    let textEs3: String
    let estrategia4: String
    let textEs4: String
    let estrategia5: String
    let textEs5: String
    let color: Color
    
    static let defaultTip = TipsModel(
        tipName: "Tip Name",
        description: "Description",
        estrategia1: "Strategy 1",
        textEs1: "Text for strategy 1",
        estrategia2: "Strategy 2",
        textEs2: "Text for strategy 2",
        estrategia3: "Strategy 3",
        textEs3: "Text for strategy 3",
        estrategia4: "Strategy 4",
        textEs4: "Text for strategy 4",
        estrategia5: "Strategy 5",
        textEs5: "Text for strategy 5",
        color: .blue
    )
    
    // Implementación de Equatable
    static func == (lhs: TipsModel, rhs: TipsModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Conformidad al protocolo Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

// DailyTask.swift

import Foundation

struct DailyTask: Identifiable {
    let id = UUID()
    let name: String
    var isCompleted: Bool = false
    let savingsAmount: Double // Amount to increment savings
}
