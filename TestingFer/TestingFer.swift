//
//  TestingFer.swift
//  TestingFer
//
//  Created by Fernando Espidio on 30/11/24.
//

import Testing
import Foundation

@testable import WattzOn

struct TestingFer {

    @Test func testConsumptionAndCostCalculation() {
        // Given
        let tarifas = [
            ConsumptionSimulationLikeInViews.Tarifa(nivel: "Básico", limiteSuperior: 150.0, tarifa: 0.933),
            ConsumptionSimulationLikeInViews.Tarifa(nivel: "Intermedio", limiteSuperior: 280.0, tarifa: 1.12),
            ConsumptionSimulationLikeInViews.Tarifa(nivel: "Excedente", limiteSuperior: nil, tarifa: 3.15)
        ]

        let calculator = ConsumptionSimulationLikeInViews(tarifas: tarifas)
        let potenciaWatts = 1000.0 // 1 kW
        let horasDiarias = 2.0 // 2 hours per day
        let diasSemana = 7 // 7 days per week
        let semanas = 8

        // Expected consumption
        let expectedConsumoKWh = calculator.calcularConsumoKWh(
            potenciaWatts: potenciaWatts,
            horasDiarias: horasDiarias,
            diasSemana: diasSemana,
            semanas: semanas
        )

        // Expected cost
        let expectedCosto = calculator.calcularCosto(consumoKWh: expectedConsumoKWh)

        // When
        let consumoKWh = expectedConsumoKWh
        let costo = expectedCosto

        // Then
        #expect(abs(consumoKWh - expectedConsumoKWh) < 0.001, "Consumo kWh calculation is incorrect")
        #expect(abs(costo - expectedCosto) < 0.001, "Costo calculation is incorrect")
    }
}

struct ConsumptionSimulationLikeInViews {
    struct Tarifa {
        let nivel: String
        let limiteSuperior: Double? // Nil for unlimited
        let tarifa: Double
    }
    
    let tarifas: [Tarifa]
    
    func calcularConsumoKWh(potenciaWatts: Double, horasDiarias: Double, diasSemana: Int, semanas: Int = 8) -> Double {
        let potenciaKW = potenciaWatts / 1000 // Convert to kW
        return potenciaKW * horasDiarias * Double(diasSemana) * Double(semanas)
    }
    
    func calcularCosto(consumoKWh: Double) -> Double {
        var consumoRestante = consumoKWh
        var costoTotal: Double = 0.0
        var consumoAcumulado = 0.0
        
        for tarifa in tarifas {
            let limiteSuperior = tarifa.limiteSuperior ?? Double.greatestFiniteMagnitude
            let limite = limiteSuperior - consumoAcumulado
            
            if limite > 0 {
                let consumoEnNivel = min(consumoRestante, limite)
                costoTotal += consumoEnNivel * tarifa.tarifa
                consumoRestante -= consumoEnNivel
                consumoAcumulado += consumoEnNivel
                
                if consumoRestante <= 0 {
                    break
                }
            } else {
                consumoAcumulado = limiteSuperior
            }
        }
        
        return costoTotal
    }
}
