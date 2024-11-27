//
//  TipsViewModel.swift
//  WattzOn
//
//  Created by Debanhi Medina on 07/11/24.
//


import Foundation
import SwiftUI

class TipsViewModel: ObservableObject {
    @Published var arrTip = [TipsModel]()
    
    init() {
        getTips()
    }
    
    func getTips() {
        var tip: TipsModel
        
        tip = TipsModel(
            tipName: "¿Cómo reducir el consumo eléctrico?",
            description: "Reducir el consumo eléctrico es una excelente forma de ahorrar dinero y cuidar el medio ambiente.",
            estrategia1: "Uso eficiente de la iluminación",
            textEs1: "Cambia a bombillas LED...",
            estrategia2: "Electrodomésticos eficientes",
            textEs2: "Selecciona electrodomésticos con etiqueta de eficiencia energética...",
            estrategia3: "Calefacción y refrigeración",
            textEs3: "Ajusta el termostato...",
            estrategia4: "Uso consciente de agua caliente",
            textEs4: "Reduce la temperatura del calentador de agua...",
            estrategia5: "Cocina de manera eficiente",
            textEs5: "Usa tapas en las ollas...",
            color: .yellow
        )
        arrTip.append(tip)
        
        // Add other tips similarly...
        // For brevity, I'm only adding one tip here
    }
}

class ConsumptionViewModel: ObservableObject {
    @Published var categories: [ConsumptionCategory] = [
        ConsumptionCategory(name: "Ahorro de luz", icon: "moon", progress: 0.7, color: .yellow),
        ConsumptionCategory(name: "Uso de electrodomésticos", icon: "house", progress: 0.5, color: .orange),
        ConsumptionCategory(name: "Uso de dispositivos", icon: "star", progress: 0.3, color: .green)
    ]
}

struct ConsumptionCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let progress: Double // Value between 0 and 1
    let color: Color
}


// DailyTaskView.swift

import SwiftUI

struct DailyTaskView: View {
    let task: DailyTask

    var body: some View {
        VStack {
            Text(task.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            Text("Ahorra: $\(task.savingsAmount, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.green)

            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(task.isCompleted ? .green : .gray)
                .padding(.bottom)
        }
        .frame(width: 150, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }
}

// DailyTasksViewModel.swift

import SwiftUI

class DailyTasksViewModel: ObservableObject {
    @Published var tasks: [DailyTask] = [
        DailyTask(name: "Apagar la luz 1 hora", savingsAmount: 0.73),
        DailyTask(name: "No prender el clima 1 día", savingsAmount: 8.60),
        DailyTask(name: "Desconectar eletrónicos", savingsAmount: 4.0)
    ]
}
