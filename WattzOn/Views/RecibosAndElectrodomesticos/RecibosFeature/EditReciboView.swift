//
//  EditReciboView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import SwiftUI

struct EditReciboView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ReciboViewModel()
    @StateObject private var conceptosData = ConceptosData()

    var recibo: Recibo

    @State private var inicioPeriodo: Date
    @State private var finPeriodo: Date
    @State private var lecturaActual: String
    @State private var lecturaAnterior: String
    @State private var subtotal: String

    @State private var isAddingConcepto = false

    init(recibo: Recibo) {
        self.recibo = recibo
        _inicioPeriodo = State(initialValue: recibo.InicioPeriodo)
        _finPeriodo = State(initialValue: recibo.FinPeriodo)
        _lecturaActual = State(initialValue: String(recibo.LecturaActual))
        _lecturaAnterior = State(initialValue: String(recibo.LecturaAnterior))
        _subtotal = State(initialValue: String(recibo.Subtotal))
        _conceptosData = StateObject(wrappedValue: ConceptosData())
        conceptosData.conceptos = recibo.conceptos
    }

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
            Text("Editar Recibo")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                saveChanges()
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
            Section(header: Text("Información del Recibo")) {
                HStack {
                    DatePicker("Inicio del Periodo", selection: $inicioPeriodo, displayedComponents: .date)
                    Spacer()
                    Button(action: {
                        router.navigate(to: .reciboReadingsInfo(field: .inicioPeriodo))
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                HStack {
                    DatePicker("Fin del Periodo", selection: $finPeriodo, displayedComponents: .date)
                    Spacer()
                    Button(action: {
                        router.navigate(to: .reciboReadingsInfo(field: .finPeriodo))
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                HStack {
                    TextField("Lectura Anterior", text: $lecturaAnterior)
                        .keyboardType(.numberPad)
                    Spacer()
                    Button(action: {
                        router.navigate(to: .reciboReadingsInfo(field: .lecturaAnterior))
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                HStack {
                    TextField("Lectura Actual", text: $lecturaActual)
                        .keyboardType(.numberPad)
                    Spacer()
                    Button(action: {
                        router.navigate(to: .reciboReadingsInfo(field: .lecturaActual))
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                HStack {
                    TextField("Subtotal", text: $subtotal)
                        .keyboardType(.decimalPad)
                    Spacer()
                    Button(action: {
                        router.navigate(to: .reciboReadingsInfo(field: .subtotal))
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            Section(header: Text("Conceptos")) {
                ForEach(conceptosData.conceptos.indices, id: \.self) { index in
                    let concepto = conceptosData.conceptos[index]
                    HStack {
                        Text("Categoría: \(conceptoCategoriaName(concepto))")
                        Spacer()
                        Text("Total: \(concepto.TotalPeriodo)")
                        Text("Precio: \(concepto.Precio)")
                    }
                }
                .onDelete { indices in
                    conceptosData.conceptos.remove(atOffsets: indices)
                }
                Button(action: {
                    isAddingConcepto = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "#FFA800"))

                        Text("Agregar Concepto")
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationTitle("Editar Recibo")
        .navigationBarItems(leading: Button("Cancelar") {
            router.goBack()
        }, trailing: Button("Guardar") {
            saveChanges()
        })
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if viewModel.modelContext == nil {
                viewModel.modelContext = modelContext
            }
        }
        .background(
            NavigationLink(
                destination: AddConceptoView()
                    .environmentObject(conceptosData),
                isActive: $isAddingConcepto,
                label: { EmptyView() }
            )
            .hidden()
        )
    }

    private func conceptoCategoriaName(_ concepto: Concepto) -> String {
        switch concepto.idCategoriaConcepto {
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

    private func saveChanges() {
        // Validar la entrada
        guard let lecturaActualInt = Int(lecturaActual),
              let lecturaAnteriorInt = Int(lecturaAnterior),
              let subtotalDouble = Double(subtotal) else {
            // Mostrar mensaje de error si es necesario
            viewModel.errorMessage = "Por favor, ingresa valores válidos."
            viewModel.showErrorAlert = true
            return
        }

        // Actualizar el recibo
        var updatedRecibo = recibo
        updatedRecibo.InicioPeriodo = inicioPeriodo
        updatedRecibo.FinPeriodo = finPeriodo
        updatedRecibo.LecturaActual = lecturaActualInt
        updatedRecibo.LecturaAnterior = lecturaAnteriorInt
        updatedRecibo.Subtotal = subtotalDouble
        updatedRecibo.conceptos = conceptosData.conceptos

        Task {
            do {
                try await viewModel.updateRecibo(updatedRecibo)
                
                DispatchQueue.main.async {
                    router.goBack()
                }
            } catch {
                print("Error al actualizar el recibo:", error)
                DispatchQueue.main.async {
                    self.viewModel.errorMessage = "Error al actualizar el recibo."
                    self.viewModel.showErrorAlert = true
                }
            }
        }
    }
}
