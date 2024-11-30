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

    @State private var idCategoriaConcepto: Int?
    @State private var totalPeriodo: String = ""
    @State private var precio: String = ""
    @State private var selectedCategory: Int?

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
            Text("Agregar Concepto")
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
            if let _ = idCategoriaConcepto {
                Menu {
                    ForEach(availableCategories(), id: \.self) { category in
                        Button(action: {
                            idCategoriaConcepto = category
                            selectedCategory = category
                        }) {
                            Text(categoryName(for: category))
                                .foregroundColor(colorForCategory(category))
                        }
                    }
                } label: {
                    HStack {
                        Text("Categoría")
                            .foregroundColor(Color.black)
                        Spacer()
                        if let selectedCategory = selectedCategory {
                            Text(categoryName(for: selectedCategory))
                                .foregroundColor(colorForCategory(selectedCategory))
                        } else {
                            Text("Seleccionar")
                                .foregroundColor(.gray)
                        }
                    }
                }
            } else {
                Text("No hay categorías disponibles")
                    .foregroundColor(.gray)
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
        .onAppear {
            let available = availableCategories()
            if let firstAvailable = available.first {
                idCategoriaConcepto = firstAvailable
                selectedCategory = firstAvailable
            } else {
                // No hay categorías disponibles
                idCategoriaConcepto = nil
            }
        }
    }
    
    private func saveConcepto() {
        guard let idCategoriaConcepto = idCategoriaConcepto else {
            // No hay categoría seleccionada, no se puede guardar
            return
        }
        
        guard let totalPeriodoInt = Int(totalPeriodo),
              let precioDouble = Double(precio) else {
            // Mostrar mensaje de error si es necesario
            return
        }
        
        let nuevoConcepto = Concepto(
            idConcepto: nil,
            idRecibo: nil,
            idCategoriaConcepto: idCategoriaConcepto,
            TotalPeriodo: totalPeriodoInt,
            Precio: precioDouble
        )
        
        conceptosData.conceptos.append(nuevoConcepto)
        presentationMode.wrappedValue.dismiss()
    }
    
    // Función para obtener las categorías disponibles
    private func availableCategories() -> [Int] {
        let existingCategories = conceptosData.conceptos.map { $0.idCategoriaConcepto }
        let allCategories = [1, 2, 3] // 1: Básico, 2: Intermedio, 3: Excedente
        let available = allCategories.filter { !existingCategories.contains($0) }
        return available
    }
    
    // Función para obtener el nombre de la categoría
    private func categoryName(for id: Int) -> String {
        switch id {
        case 1:
            return "Básico"
        case 2:
            return "Intermedio"
        case 3:
            return "Excedente"
        default:
            return "Desconocido"
        }
    }
    
    // Función para obtener el color de la categoría
    private func colorForCategory(_ id: Int) -> Color {
        switch id {
        case 1:
            return Color.green
        case 2:
            return Color.orange
        case 3:
            return Color.red
        default:
            return Color.black
        }
    }
}
