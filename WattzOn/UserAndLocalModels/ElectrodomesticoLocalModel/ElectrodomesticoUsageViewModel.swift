//
//  ElectrodomesticoUsageViewModel.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

// ElectrodomesticoUsageViewModel.swift

import Foundation
import SwiftUI

class ElectrodomesticoUsageViewModel: ObservableObject {
    @Published var usages: [ElectrodomesticoUsage] = []
    
    init() {
        loadUsages()
    }
    
    // Función para cargar los datos desde UserDefaults
    func loadUsages() {
        if let data = UserDefaults.standard.data(forKey: "ElectrodomesticoUsages"),
           let savedUsages = try? JSONDecoder().decode([ElectrodomesticoUsage].self, from: data) {
            self.usages = savedUsages
        }
    }
    
    // Función para guardar los datos en UserDefaults
    func saveUsages() {
        if let data = try? JSONEncoder().encode(usages) {
            UserDefaults.standard.set(data, forKey: "ElectrodomesticoUsages")
        }
    }
    
    // Función para agregar un nuevo uso
    func addUsage(_ usage: ElectrodomesticoUsage) {
        // Eliminar si ya existe uno con el mismo id
        usages.removeAll { $0.id == usage.id }
        usages.append(usage)
        saveUsages()
    }
    
    // Función para obtener el uso de un electrodoméstico específico
    func getUsage(forElectrodomesticoId id: Int) -> ElectrodomesticoUsage? {
        return usages.first { $0.id == id }
    }
}
