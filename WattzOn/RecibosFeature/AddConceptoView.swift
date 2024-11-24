//
//  AddConceptoView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

import SwiftUI

struct AddConceptoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var conceptosData: ConceptosData

    @State private var idCategoriaConcepto: Int = 1
    @State private var totalPeriodo: String = ""
    @State private var precio: String = ""

    var body: some View {
        Form {
            Picker("Categoría", selection: $idCategoriaConcepto) {
                Text("Básico").tag(1)
                Text("Intermedio").tag(2)
                Text("Excedente").tag(3)
            }
            TextField("Total Periodo", text: $totalPeriodo)
                .keyboardType(.numberPad)
            TextField("Precio", text: $precio)
                .keyboardType(.decimalPad)
        }
        .navigationTitle("Agregar Concepto")
        .navigationBarItems(leading: Button("Cancelar") {
            presentationMode.wrappedValue.dismiss()
        }, trailing: Button("Guardar") {
            saveConcepto()
        })
    }

    private func saveConcepto() {
        guard let totalPeriodoInt = Int(totalPeriodo),
              let precioDouble = Double(precio) else {
            // Mostrar mensaje de error si es necesario
            return
        }

        let nuevoConcepto = Concepto(
            idConcepto: nil, // Nuevo concepto, idConcepto será asignado por el servidor
            idRecibo: nil, // idRecibo se asignará después de crear el recibo
            idCategoriaConcepto: idCategoriaConcepto,
            TotalPeriodo: totalPeriodoInt,
            Precio: precioDouble
        )
        
        print("CONCEPTO:")
        print(nuevoConcepto.idCategoriaConcepto)
        print(nuevoConcepto.TotalPeriodo)
        print(nuevoConcepto.Precio)


        
        conceptosData.conceptos.append(nuevoConcepto)
        presentationMode.wrappedValue.dismiss()
    }
}
