//
//  ElectrodomesticosListView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

// ElectrodomesticosListView.swift

import SwiftUI

struct ElectrodomesticosListView: View {
    @EnvironmentObject var electrodomesticoViewModel: ElectrodomesticoViewModel
    @EnvironmentObject var usageViewModel: ElectrodomesticoUsageViewModel
    var consumoTotalPeriodo: Double
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(electrodomesticoViewModel.electrodomesticos) { electrodomestico in
                if let usage = usageViewModel.getUsage(forElectrodomesticoId: electrodomestico.electrodomesticoId ?? 0) {
                    let consumoKWh = usage.consumoKWh
                    let porcentajeConsumo = consumoTotalPeriodo > 0 ? (consumoKWh / consumoTotalPeriodo) * 100 : 0.0
                    let costo = usage.costo
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(electrodomestico.nombre)
                                .font(.headline)
                            Text("Consumo: \(consumoKWh, specifier: "%.2f") kWh")
                            Text("Costo: $\(costo, specifier: "%.2f") MXN")
                        }
                        Spacer()
                        Text("\(porcentajeConsumo, specifier: "%.2f")%")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                    .padding()
                }
            }
            .navigationTitle("Electrodomésticos")
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        // Ensure the view updates when data changes
        .onReceive(electrodomesticoViewModel.$electrodomesticos) { _ in
            // This will trigger the view to refresh when electrodomesticos change
        }
        .onReceive(usageViewModel.$usages) { _ in
            // This will trigger the view to refresh when usages change
        }
    }
}
