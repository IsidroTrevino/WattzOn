//
//  HomeModels.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

import SwiftUI
import Charts

struct ChartView: View {
    var consumptionData: [ConsumptionData]
    
    var body: some View {
        if consumptionData.isEmpty {
            Text("No hay datos para mostrar.")
                .foregroundColor(.gray)
                .padding()
        } else {
            Chart {
                ForEach(consumptionData) { data in
                    BarMark(
                        x: .value("Periodo", data.day),
                        y: .value("Consumo", data.consumption)
                    )
                    .foregroundStyle(Color(hex: "#FFA800"))
                }
            }
            .chartYAxisLabel("Consumo (kWh)", position: .leading)
            .chartXAxisLabel("Periodo", position: .bottom)
            .frame(maxHeight: UIScreen.main.bounds.height / 2, alignment: .center)
            .padding()
        }
    }
}

import SwiftUI

struct LightbulbView: View {
    var consumption: Double
    
    var body: some View {
        ZStack {
            Image(systemName: "lightbulb.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.yellow.opacity(0.3))
                .frame(width: 100, height: 200)
            
            VStack {
                Text("\(consumption, specifier: "%.2f") kWh")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
}

import Foundation

struct ConsumptionData: Identifiable {
    let id = UUID()
    let day: String
    let consumption: Double
}
