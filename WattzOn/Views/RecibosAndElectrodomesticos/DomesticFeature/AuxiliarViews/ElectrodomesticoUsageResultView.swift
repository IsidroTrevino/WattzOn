//
//  ElectrodomesticoUsageResultView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 25/11/24.
//

// ElectrodomesticoUsageResultView.swift

import SwiftUI

struct ElectrodomesticoUsageResultView: View {
    @EnvironmentObject var router: Router

    let consumoKWh: Double
    let costo: Double
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Resultados")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.yellow)
                    Text("Consumo: \(consumoKWh, specifier: "%.2f") kWh")
                        .font(.title2)
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                    Text("Costo: $\(costo, specifier: "%.2f") MXN")
                        .font(.title2)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                // Volver a las pantallas anteriores
                // Puedes ajustar esto según cómo manejes la navegación con tu Router
                router.goBack()
                router.goBack()
            }) {
                Text("Volver")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#FFA800"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
        .navigationBarHidden(true)

    }
}
