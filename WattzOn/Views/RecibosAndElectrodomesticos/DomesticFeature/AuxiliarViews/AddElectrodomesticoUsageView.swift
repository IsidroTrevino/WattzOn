//
//  AddElectrodomesticoUsageView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

// AddElectrodomesticoUsageView.swift

import SwiftUI

struct AddElectrodomesticoUsageView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var usageViewModel: ElectrodomesticoUsageViewModel

    let electrodomesticoId: Int
    let potenciaWatts: Double

    @State var tiempoUsoDiario: String = ""
    @State var diasUsoSemanal: String = ""
    @State var consumoKWh: Double = 0.0
    @State var costo: Double = 0.0
    @State var showResults = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    // Definición de Tarifa
    struct Tarifa {
        let nivel: String
        let limiteSuperior: Double? // Nil para el último nivel (Excedente)
        let tarifa: Double
    }

    var body: some View {
        HStack {
            Text("Agregar Electrodoméstico")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                calcularConsumoYCosto()
            }) {
                Text("Guardar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "#FFA800"))
                    .cornerRadius(25)
            }
        }
        .padding(.horizontal)
        .padding(.top)
        NavigationView {
            Form {
                Section(header: Text("Uso del Electrodoméstico")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("¿Cuántas horas usas este electrodoméstico por día? Considera que si no pasa de la hora, escribe 1")
                            .font(.headline)
                        TextField("Horas de uso diario", text: $tiempoUsoDiario)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("¿Cuántos días a la semana?")
                            .font(.headline)
                        TextField("Días de uso semanal", text: $diasUsoSemanal)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                if showResults {
                    Section(header: Text("Consumo y Costo")) {
                        Text("Consumo: \(consumoKWh, specifier: "%.2f") kWh")
                        Text("Costo: $\(costo, specifier: "%.2f") MXN")
                    }
                }
            }
            .navigationBarHidden(true) // Oculta la barra de navegación
            //.navigationBarBackButtonHidden(true)
            .navigationTitle("Uso del Electrodoméstico")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    // Volver dos veces atrás
                    router.goBack()
                    router.goBack()
                },
                trailing: Button("Calcular y Guardar") {
                    calcularConsumoYCosto()
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .background(
                // Navegación condicional hacia la vista de resultados
                NavigationLink(
                    destination: ElectrodomesticoUsageResultView(consumoKWh: consumoKWh, costo: costo),
                    isActive: $showResults,
                    label: {
                        EmptyView()
                    }
                )
            )
        }
    }

    func calcularConsumoYCosto() {
        guard let horasDiarias = Double(tiempoUsoDiario),
              let diasSemana = Int(diasUsoSemanal),
              horasDiarias > 0,
              diasSemana > 0 else {
            alertMessage = "Por favor, ingresa valores válidos para el tiempo de uso y los días de la semana."
            showAlert = true
            return
        }

        // Calcular consumo en kWh considerando 8 semanas (2 meses)
        let potenciaKW = potenciaWatts / 1000 // Convertir a kW
        let semanas = 8
        consumoKWh = potenciaKW * horasDiarias * Double(diasSemana) * Double(semanas)

        // Calcular costo usando las tarifas
        costo = calcularCosto(consumoKWh: consumoKWh)

        // Guardar los datos
        let usage = ElectrodomesticoUsage(
            id: electrodomesticoId,
            horasUsoDiario: horasDiarias,
            diasUsoPeriodo: diasSemana,
            consumoKWh: consumoKWh,
            costo: costo
        )
        usageViewModel.addUsage(usage)
        print("Se agregó")

        // Mostrar la vista de resultados
        showResults = true
    }

    private func calcularCosto(consumoKWh: Double) -> Double {
        // Definir las tarifas
        let tarifas = [
            Tarifa(nivel: "Básico", limiteSuperior: 150.0, tarifa: 0.933),
            Tarifa(nivel: "Intermedio", limiteSuperior: 280.0, tarifa: 0.933),
            Tarifa(nivel: "Excedente", limiteSuperior: nil, tarifa: 0.933)
        ]

        // Suponemos consumo actual = 0 para el cálculo individual
        let costoTotal = calcularCostoAdicional(consumoActual: 0.0, consumoAdicional: consumoKWh, tarifas: tarifas)

        return costoTotal
    }

    private func calcularCostoAdicional(consumoActual: Double, consumoAdicional: Double, tarifas: [Tarifa]) -> Double {
        var consumoRestante = consumoAdicional
        var costoTotal: Double = 0.0
        var consumoAcumulado = consumoActual

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
