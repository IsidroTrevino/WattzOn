//
//  HousePorcentage.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

// CasaProgresivaView.swift

import SwiftUI
import SwiftData

struct CasaProgresivaView: View {
    @StateObject private var electrodomesticoViewModel = ElectrodomesticoViewModel()
    @StateObject private var reciboViewModel = ReciboViewModel()
    @EnvironmentObject var usageViewModel: ElectrodomesticoUsageViewModel
    @EnvironmentObject var tabSelection: TabSelection
    @Environment(\.modelContext) private var context
    
    @State private var consumoTotalPeriodo: Double = 0.0
    @State private var costoTotalPeriodo: Double = 0.0
    @State private var porcentajeConsumoRegistrado: Double = 0.0
    @State private var showElectrodomesticosList = false
    @State private var porcentajeCompletado: Double = 0.0
    @Query var usuario: [UsuarioResponse]
    
    var body: some View {
        VStack {
            HStack {
                Text("Consumo del Último Periodo")
                    .font(.title)
                    .padding()
                Spacer()
            }
            
            Text("Consumo: \(consumoTotalPeriodo, specifier: "%.2f") kWh")
            Text("Costo: $\(costoTotalPeriodo, specifier: "%.2f") MXN")
            
            Spacer()
            
            GeometryReader { geometry in
                ZStack {
                    Image("progressive") // Imagen de fondo (negra)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Image("progressivefill") // Imagen que se llenará
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .mask(
                            Rectangle()
                                .frame(width: geometry.size.width, height: geometry.size.height * porcentajeCompletado)
                                .offset(y: geometry.size.height * (1 - porcentajeCompletado))
                        )
                        .animation(.easeInOut, value: porcentajeCompletado)
                }
                .onTapGesture {
                    showElectrodomesticosList = true
                }
            }
            .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            // Barra de progreso personalizada
            VStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 10)
                    
                    Rectangle()
                        .fill(Color(hex: "#FFA800"))
                        .frame(width: UIScreen.main.bounds.width * (porcentajeConsumoRegistrado / 100), height: 10)
                        .animation(.easeInOut, value: porcentajeConsumoRegistrado)
                }
                .padding(.horizontal)
                
                Text("Registro de consumo: \(porcentajeConsumoRegistrado, specifier: "%.2f")%")
                    .padding(.top, 5)
            }
            .padding(.bottom)
        }
        .onAppear {
            Task {
                await electrodomesticoViewModel.fetchElectrodomesticos(usuarioId: usuario.first?.usuario.usuarioId ?? 0, token: usuario.first?.token ?? "")
                await reciboViewModel.fetchRecibos(usuarioId: usuario.first!.usuario.usuarioId, token: usuario.first!.token)
                calcularConsumo()
            }
        }
        .onReceive(tabSelection.$selectedTab) { newValue in
            if newValue == "MiHogar" {
                Task {
                    await electrodomesticoViewModel.fetchElectrodomesticos(usuarioId: usuario.first!.usuario.usuarioId, token: usuario.first!.token)
                    await reciboViewModel.fetchRecibos(usuarioId: usuario.first!.usuario.usuarioId, token: usuario.first!.token)
                    calcularConsumo()
                }
            }
        }
        .sheet(isPresented: $showElectrodomesticosList) {
            ElectrodomesticosListView(
                consumoTotalPeriodo: consumoTotalPeriodo
            )
            .environmentObject(electrodomesticoViewModel)
            .environmentObject(usageViewModel)
        }
    }
    
    func calcularConsumo() {
        guard let ultimoRecibo = reciboViewModel.recibos.sorted(by: { $0.FinPeriodo > $1.FinPeriodo }).first else {
            return
        }
        
        consumoTotalPeriodo = Double(abs(ultimoRecibo.LecturaActual - ultimoRecibo.LecturaAnterior))
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
