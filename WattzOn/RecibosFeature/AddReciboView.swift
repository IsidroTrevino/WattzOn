//
//  AddReciboView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import SwiftUI
import SwiftData

struct AddReciboView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var fechaRegistro: Date
    @State private var lecturaActual: String
    @State private var lecturaAnterior: String
    @State private var totalesText: String
    @State private var preciosText: String
    @State private var totalFinalesText: String

    init(initialData: ExtractedReceiptData? = nil) {
        if let data = initialData {
            _fechaRegistro = State(initialValue: data.fechaRegistro)
            _lecturaActual = State(initialValue: String(data.lecturaActual))
            _lecturaAnterior = State(initialValue: String(data.lecturaAnterior))
            _totalesText = State(initialValue: data.totales.map { String($0) }.joined(separator: ", "))
            _preciosText = State(initialValue: data.precios.map { String($0) }.joined(separator: ", "))
            _totalFinalesText = State(initialValue: data.totalFinales.map { String($0) }.joined(separator: ", "))
        } else {
            _fechaRegistro = State(initialValue: Date())
            _lecturaActual = State(initialValue: "")
            _lecturaAnterior = State(initialValue: "")
            _totalesText = State(initialValue: "")
            _preciosText = State(initialValue: "")
            _totalFinalesText = State(initialValue: "")
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Recibo")) {
                    DatePicker("Fecha del Recibo", selection: $fechaRegistro, displayedComponents: .date)
                    
                    TextField("Lectura Actual", text: $lecturaActual)
                        .keyboardType(.numberPad)
                    TextField("Lectura Anterior", text: $lecturaAnterior)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Detalles")) {
                    TextField("Totales (separados por comas)", text: $totalesText)
                        .keyboardType(.numberPad)
                    TextField("Precios (separados por comas)", text: $preciosText)
                        .keyboardType(.decimalPad)
                    TextField("Total Finales (separados por comas)", text: $totalFinalesText)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Agregar Recibo")
            .navigationBarItems(leading: Button("Cancelar") {
                dismiss()
            }, trailing: Button("Guardar") {
                saveRecibo()
            })
        }
    }
    
    private func saveRecibo() {
        // Validar la entrada
        guard let lecturaActualInt = Int(lecturaActual),
              let lecturaAnteriorInt = Int(lecturaAnterior) else {
            // Mostrar mensaje de error si es necesario
            return
        }
        
        let totales = totalesText.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        let precios = preciosText.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        let totalFinales = totalFinalesText.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        
        let nuevoRecibo = Recibo(
            fechaRegistro: fechaRegistro,
            lecturaActual: lecturaActualInt,
            lecturaAnterior: lecturaAnteriorInt,
            totales: totales,
            precios: precios,
            totalFinales: totalFinales
        )
        
        modelContext.insert(nuevoRecibo)
        dismiss()
    }
}

#Preview {
    AddReciboView()
        .modelContainer(for: Recibo.self)
}
