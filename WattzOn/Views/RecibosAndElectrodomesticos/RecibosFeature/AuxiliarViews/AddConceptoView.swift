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
    @EnvironmentObject var router: Router

    @State private var idCategoriaConcepto: Int = 1
    @State private var totalPeriodo: String = ""
    @State private var precio: String = ""
    
    var body: some View {
        // Barra de navegación personalizada
        HStack {
            Button(action: {
                router.goBack()
            }) {
                Image(systemName: "arrow.left.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "#FFA800"))
            }
            Spacer()
            Text("Agregar Recibo")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                saveConcepto()
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
        .navigationBarHidden(true)
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
