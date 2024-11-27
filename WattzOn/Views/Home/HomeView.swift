//
//  HomeView.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//

import Foundation
import Combine
import Vision
import UIKit
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var electrodomesticoViewModel: ElectrodomesticoViewModel
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showMissionAlert = false
    @State private var missionCompleted = false
    @State private var Sho = false


    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Inicio")
                    .font(.title)
                    .bold()
                    .padding(.horizontal, 20)
                Spacer()
                // Refresh Button
                Button(action: {
                    Task {
                        Sho = true
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                }
                .padding(.trailing, 20)
            }
            /*
            // Scan Receipt Button
            if !homeViewModel.receiptUploaded {
                if homeViewModel.isProcessing {
                    ProgressView("Procesando...")
                        .padding()
                } else {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .font(.title2)
                            Text("Escanear Recibo")
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
                }
            }
             */
            // Savings and Consumption
            VStack(spacing: 10) {
                Text("Has Ahorrado")
                    .font(.headline)
                    .foregroundColor(.gray)

                Text("\(homeViewModel.consumoEnergetico.ahorro, specifier: "%.2f") MXN")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.orange)
                
                Text("8,289 kWh")
                    .font(.title2)
                    .foregroundColor(.orange)
                /*
                Text("\(homeViewModel.consumoEnergetico.consumo, specifier: "%.0f") kWh")
                    .font(.title2)
                    .foregroundColor(.orange)
                 */
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.15))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
            )
            .padding(.horizontal, 20)

            // Energy Consumption Title
            HStack {
                Text("Tu consumo Energético")
                    .font(.headline)
                    .padding(.horizontal, 20)
                Spacer()
            }

            // Consumption Chart
            if homeViewModel.periodos.isEmpty && homeViewModel.kwh.isEmpty {
                Image("grafica")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                /*
                Text("No hay datos de consumo disponibles.")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.15))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                    )
                    .padding(.horizontal, 20)
                 */
            } else {
                /*
                ChartView(consumptionData: homeViewModel.periodos.enumerated().map { index, periodo in
                    ConsumptionData(day: periodo, consumption: homeViewModel.kwh[index])
                })
                .frame(height: 180)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.15))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                )
                .padding(.horizontal, 20)
                 */
                Image("grafica")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            // Show Mission Card if more than one appliance
            if Sho {
                // Mission Card
                VStack {
                    HStack {
                        Text("¡Misión!")
                            .font(.headline)
                        Spacer()
                        if missionCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.title)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    Text("Apaga el aire acondicionado 2 horas para ahorrar $5.45 MXN")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)

                    if !missionCompleted {
                        Button(action: {
                            showMissionAlert = true
                        }) {
                            Text("Completar Misión")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.15))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                )
                .padding(.horizontal, 20)

                // Message when no more suggestions
                if missionCompleted {
                    Text("No hay más sugerencias que mostrar")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
            }

            Spacer()
        }
        .padding(.top, 10)
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                homeViewModel.recognizeTextFromImage(image) { success in
                    // Handle success or failure
                }
            }
        }
        .onAppear {
            Task {
                await electrodomesticoViewModel.fetchElectrodomesticos()
            }
        }
        .alert(isPresented: $showMissionAlert) {
            Alert(
                title: Text("Completar Misión"),
                message: Text("¿Estás seguro de que apagarás el aire acondicionado para ahorrar energía?"),
                primaryButton: .default(Text("Sí"), action: {
                    missionCompleted = true
                    homeViewModel.incrementSavings(by: 5.45) // Increment savings
                }),
                secondaryButton: .cancel(Text("No"))
            )
        }
    }
}
