//
//  HousePorcentage.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

// CasaProgresivaView.swift

import SwiftUI

struct CasaProgresivaView: View {
    @StateObject private var electrodomesticoViewModel = ElectrodomesticoViewModel()
    @StateObject private var reciboViewModel = ReciboViewModel()
    @EnvironmentObject var usageViewModel: ElectrodomesticoUsageViewModel
    @EnvironmentObject var tabSelection: TabSelection
    
    @State private var consumoTotalPeriodo: Double = 0.0
    @State private var costoTotalPeriodo: Double = 0.0
    @State private var porcentajeConsumoRegistrado: Double = 0.0
    @State private var showElectrodomesticosList = false
    @State private var porcentajeCompletado: Double = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Consumo del Último Periodo")
                    .font(.title)
                    .padding()
                Spacer()
                Button(action: {
                    Task {
                        await electrodomesticoViewModel.fetchElectrodomesticos()
                        await reciboViewModel.fetchRecibos()
                        calcularConsumo()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                }
                .padding(.trailing, 20)
            }
            
            Text("Consumo: \(consumoTotalPeriodo, specifier: "%.2f") kWh")
            Text("Costo: $\(costoTotalPeriodo, specifier: "%.2f") MXN")
            
            Spacer()
            
            ZStack {
                Image("progressive")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Rectangle()
                    .fill(Color(hex: "#FFA800").opacity(0.5))
                    .frame(height: UIScreen.main.bounds.height * porcentajeCompletado)
                    .mask(
                        Image("progressive")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    )
                    .animation(.easeInOut, value: porcentajeCompletado)
            }
            .onTapGesture {
                showElectrodomesticosList = true
            }
            
            Spacer()
        }
        .onAppear {
            Task {
                await electrodomesticoViewModel.fetchElectrodomesticos()
                await reciboViewModel.fetchRecibos()
                calcularConsumo()
            }
        }
        .onReceive(tabSelection.$selectedTab) { newValue in
            print("Hola")
            if newValue == "MiHogar" {
                Task {
                    await electrodomesticoViewModel.fetchElectrodomesticos()
                    await reciboViewModel.fetchRecibos()
                    calcularConsumo()
                }
                print("Hola2")

            }
        }
        .sheet(isPresented: $showElectrodomesticosList) {
            ElectrodomesticosListView(
                consumoTotalPeriodo: consumoTotalPeriodo
            )
            .environmentObject(electrodomesticoViewModel)
            .environmentObject(usageViewModel) // Ensure this is also injected
        }
    }
    
    func calcularConsumo() {
        guard let ultimoRecibo = reciboViewModel.recibos.sorted(by: { $0.FinPeriodo > $1.FinPeriodo }).first else {
            return
        }
        
        consumoTotalPeriodo = Double(abs(ultimoRecibo.LecturaActual - ultimoRecibo.LecturaAnterior))
        
        //consumoTotalPeriodo = Double(abs(ultimoRecibo.LecturaActual))

        costoTotalPeriodo = ultimoRecibo.Subtotal
        
        var consumoElectrodomesticos: Double = 0.0
        
        for electrodomestico in electrodomesticoViewModel.electrodomesticos {
            if let usage = usageViewModel.getUsage(forElectrodomesticoId: electrodomestico.electrodomesticoId ?? 0) {
                consumoElectrodomesticos += usage.consumoKWh
            }
        }
        
        if consumoTotalPeriodo > 0 {
            porcentajeConsumoRegistrado = (consumoElectrodomesticos / consumoTotalPeriodo) * 100
            porcentajeCompletado = min(porcentajeConsumoRegistrado / 100, 1.0)
        } else {
            porcentajeConsumoRegistrado = 0.0
            porcentajeCompletado = 0.0
        }
    }
}
