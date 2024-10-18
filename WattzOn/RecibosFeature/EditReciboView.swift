//
//  EditReciboView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import SwiftUI
import SwiftData

struct EditReciboView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var recibo: Recibo
    
    @State private var fechaRegistro: Date
    @State private var lecturaActual: String
    @State private var lecturaAnterior: String
    @State private var totalesText: String
    @State private var preciosText: String
    @State private var totalFinalesText: String
    
    init(recibo: Recibo) {
        self.recibo = recibo
        _fechaRegistro = State(initialValue: recibo.fechaRegistro)
        _lecturaActual = State(initialValue: String(recibo.lecturaActual))
        _lecturaAnterior = State(initialValue: String(recibo.lecturaAnterior))
        _totalesText = State(initialValue: recibo.totales.map { String($0) }.joined(separator: ", "))
        _preciosText = State(initialValue: recibo.precios.map { String($0) }.joined(separator: ", "))
        _totalFinalesText = State(initialValue: recibo.totalFinales.map { String($0) }.joined(separator: ", "))
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
            .navigationTitle("Editar Recibo")
            .navigationBarItems(leading: Button("Cancelar") {
                dismiss()
            }, trailing: Button("Guardar") {
                saveChanges()
            })
        }
    }
    
    private func saveChanges() {
        // Validar la entrada
        guard let lecturaActualInt = Int(lecturaActual),
              let lecturaAnteriorInt = Int(lecturaAnterior) else {
            // Mostrar mensaje de error si es necesario
            return
        }
        
        let totales = totalesText.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        let precios = preciosText.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        let totalFinales = totalFinalesText.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        
        // Actualizar el recibo
        recibo.fechaRegistro = fechaRegistro
        recibo.lecturaActual = lecturaActualInt
        recibo.lecturaAnterior = lecturaAnteriorInt
        recibo.totales = totales
        recibo.precios = precios
        recibo.totalFinales = totalFinales
        
        dismiss()
    }
}

#Preview {
    EditReciboView(recibo: Recibo(
        fechaRegistro: Date(),
        lecturaActual: 1200,
        lecturaAnterior: 1100,
        totales: [100],
        precios: [1.5],
        totalFinales: [150.0]
    ))
    .modelContainer(for: Recibo.self)
}
