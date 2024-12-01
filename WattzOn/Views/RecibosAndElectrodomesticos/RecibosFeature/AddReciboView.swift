//
//  AddReciboView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import SwiftUI
import SwiftData

class ConceptosData: ObservableObject {
    @Published var conceptos: [Concepto] = []
    
    init(conceptos: [Concepto] = []) {
        self.conceptos = conceptos
    }
}

struct AddReciboView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ReciboViewModel()
    @StateObject var conceptosData: ConceptosData

    @State private var inicioPeriodo: Date
    @State private var finPeriodo: Date
    @State private var lecturaActual: String
    @State private var lecturaAnterior: String
    @State private var subtotal: String

    @State private var isAddingConcepto = false
    
    @Query var usuario: [UsuarioResponse]

    init(initialData: ExtractedReceiptData? = nil) {
        if let data = initialData {
            _inicioPeriodo = State(initialValue: Date())
            _finPeriodo = State(initialValue: Date())
            _lecturaActual = State(initialValue: String(data.lecturaActual))
            _lecturaAnterior = State(initialValue: String(data.lecturaAnterior))
            _subtotal = State(initialValue: String(data.subtotal))
            _conceptosData = StateObject(wrappedValue: ConceptosData(conceptos: data.conceptos))
        } else {
            _inicioPeriodo = State(initialValue: Date())
            _finPeriodo = State(initialValue: Date())
            _lecturaActual = State(initialValue: "")
            _lecturaAnterior = State(initialValue: "")
            _subtotal = State(initialValue: "")
            _conceptosData = StateObject(wrappedValue: ConceptosData())
        }
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
            Text("Agregar Recibo")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                saveRecibo()
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
                        Text("Precio: \(concepto.Precio, specifier: "%.2f")")
                    }
                }
                .onDelete { indices in
                    conceptosData.conceptos.remove(atOffsets: indices)
                }
                // Mostrar el botón solo si hay menos de 3 conceptos
                if conceptosData.conceptos.count < 3 {
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
        }
        .navigationBarHidden(true)
        .navigationTitle("Agregar Recibo")
        .navigationBarItems(leading: Button("Cancelar") {
            router.goBack()
        }, trailing: Button("Guardar") {
            saveRecibo()
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

    private func saveRecibo() {
        // Validar la entrada
        guard let lecturaActualInt = Int(lecturaActual),
              let lecturaAnteriorInt = Int(lecturaAnterior),
              let subtotalDouble = Double(subtotal) else {
            // Mostrar mensaje de error si es necesario
            viewModel.errorMessage = "Por favor, ingresa valores válidos."
            viewModel.showErrorAlert = true
            return
        }

        let usuarioId = usuario.first!.usuario.usuarioId
        let token = usuario.first!.token

        let nuevoRecibo = Recibo(
            idRecibo: 0,
            usuarioId: usuarioId,
            LecturaActual: lecturaActualInt,
            LecturaAnterior: lecturaAnteriorInt,
            InicioPeriodo: inicioPeriodo,
            FinPeriodo: finPeriodo,
            Subtotal: subtotalDouble,
            conceptos: conceptosData.conceptos
        )
        
        /*
        print("Debug - Valores y Tipos:")
        print("usuarioId: \(usuarioId), Tipo: \(type(of: usuarioId))")
        print("LecturaActual: \(lecturaActualInt), Tipo: \(type(of: lecturaActualInt))")
        print("LecturaAnterior: \(lecturaAnteriorInt), Tipo: \(type(of: lecturaAnteriorInt))")
        print("InicioPeriodo: \(inicioPeriodo), Tipo: \(type(of: inicioPeriodo))")
        print("FinPeriodo: \(finPeriodo), Tipo: \(type(of: finPeriodo))")
        print("Subtotal: \(subtotalDouble), Tipo: \(type(of: subtotalDouble))")
        print("Conceptos: \(conceptosData.conceptos), Tipo: \(type(of: conceptosData.conceptos))")
        */
        
        Task {
            do {
                _ = try await viewModel.createRecibo(nuevoRecibo, token: token)
                router.goBack()

                DispatchQueue.main.async {
                    router.goBack()
                }
            } catch {
                print("Error al agregar recibo:", error)
                DispatchQueue.main.async {
                    router.goBack()
                    self.viewModel.errorMessage = "Error al agregar recibo."
                    //self.viewModel.showErrorAlert = true
                }
            }
        }
    }
}
