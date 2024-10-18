//
//  HomeView.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//

import SwiftUI
import Charts

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Home")
                    .font(.title)
                    .bold()
                    .padding(.horizontal, 20)
                Spacer()
            }
            
            VStack(spacing: 10) {
                Text("Has Ahorrado")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("\(viewModel.consumoEnergetico.ahorro, specifier: "%.2f") MXN")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.orange)
                
                Text("\(viewModel.consumoEnergetico.consumo, specifier: "%.0f") kWh")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.15))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
            )
            .padding(.horizontal, 20)
            
            HStack {
                Text("Tu consumo Energético")
                    .font(.headline)
                    .padding(.horizontal, 20)
                Spacer()
            }
            
            ChartView()
                .frame(height: 180)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.15))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                )
                .padding(.horizontal, 20)
            
            LightbulbView(consumption: viewModel.consumoEnergetico.consumo / 1000) //
                .frame(width: 100, height: 200)
                .padding(.top, 20)
            
            Spacer()
        }
        .padding(.top, 10)
    }
}

struct ChartView: View {
    var body: some View {
        Chart {
            ForEach(consumptionData) { data in
                LineMark(
                    x: .value("Día", data.day),
                    y: .value("Consumo", data.consumption)
                )
                .foregroundStyle(Color.orange)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: 0...1000)
        .chartXAxis {
            AxisMarks(values: .automatic)
        }
    }
}

struct LightbulbView: View {
    var consumption: Double
    
    var body: some View {
        ZStack {
            Image(systemName: "lightbulb.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.yellow.opacity(0.3))
                .frame(width: 100, height: 200)
            
        }
    }
}

// Modelo de datos para el gráfico
struct ConsumptionData: Identifiable {
    let id = UUID()
    let day: Int
    let consumption: Double
}

// Datos de muestra para el gráfico
let consumptionData: [ConsumptionData] = [
    ConsumptionData(day: 1, consumption: 300),
    ConsumptionData(day: 2, consumption: 450),
    ConsumptionData(day: 3, consumption: 400),
    ConsumptionData(day: 4, consumption: 650),
    ConsumptionData(day: 5, consumption: 700),
    ConsumptionData(day: 6, consumption: 600),
    ConsumptionData(day: 7, consumption: 750),
    ConsumptionData(day: 8, consumption: 900),
    ConsumptionData(day: 9, consumption: 850),
    ConsumptionData(day: 10, consumption: 950)
]

#Preview {
    HomeView()
}
