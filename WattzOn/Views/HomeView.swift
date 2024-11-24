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
    
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Inicio")
                    .font(.title)
                    .bold()
                    .padding(.horizontal, 20)
                Spacer()
            }
            
            // Ahorro y Consumo
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
            
            // Mostrar el botón solo si no se ha subido un recibo
            if !viewModel.receiptUploaded {
                // Botón para subir recibo
                Button(action: {
                    showImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .font(.title2)
                        Text("Empieza a medir tu consumo")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                .alert(isPresented: $viewModel.showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                }
            }
            
            // Indicador de Carga
            if viewModel.isProcessing {
                ProgressView("Procesando recibo...")
                    .padding()
            }
            
            // Título de Consumo Energético
            HStack {
                Text("Tu consumo Energético")
                    .font(.headline)
                    .padding(.horizontal, 20)
                Spacer()
            }
            
            // Gráfico de Consumo
            if viewModel.periodos.isEmpty && viewModel.kwh.isEmpty {
                Text("No hay datos de consumo disponibles.")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.15))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                    )
                    .padding(.horizontal, 20)
            } else {
                ChartView(consumptionData: viewModel.periodos.enumerated().map { index, periodo in
                    ConsumptionData(day: periodo, consumption: viewModel.kwh[index])
                })
                .frame(height: 180)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.15))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                )
                .padding(.horizontal, 20)
            }
            
            // Vista de Bombilla
            LightbulbView(consumption: viewModel.consumoEnergetico.consumo / 1000)
                .frame(width: 100, height: 200)
                .padding(.top, 20)
            
            Spacer()
        }
        .padding(.top, 10)
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                viewModel.recognizeTextFromImage(image)
            }
        }
    }
}
