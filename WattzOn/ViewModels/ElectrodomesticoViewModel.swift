//
//  ElectrodomesticoViewModel.swift
//  WattzOn
//
//  Created by Isidro Treviño on 07/11/24.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class ElectrodomesticoViewModel: ObservableObject {
    @Published var electrodomesticos: [Electrodomestico] = []
    @Environment(\.modelContext) var modelContext

    func fetchElectrodomesticos(for userId: Int) async {
        guard let url = URL(string: "https://wattzonapi.onrender.com/api/wattzon/electrodomestico/usuario/\(userId)") else {
            print("URL inválida")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([Electrodomestico].self, from: data)
            self.electrodomesticos = decodedData
            
            // Guardar en SwiftData
            for electrodomestico in decodedData {
                modelContext.insert(electrodomestico)
            }
            
            try modelContext.save()
        } catch {
            print("Error al obtener electrodomésticos: \(error)")
        }
    }
}
