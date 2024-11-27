//
//  ElectrodomesticoUsage.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

// ElectrodomesticoUsage.swift

import Foundation

struct ElectrodomesticoUsage: Identifiable, Codable {
    let id: Int // Correspondiente al id del Electrodomestico
    var horasUsoDiario: Double
    var diasUsoPeriodo: Int
    var consumoKWh: Double
    var costo: Double
}
