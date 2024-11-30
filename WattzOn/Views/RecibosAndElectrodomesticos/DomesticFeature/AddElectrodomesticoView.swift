//
//  AddElectrodomesticView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

// AddElectrodomesticoView.swift

import SwiftUI
import PhotosUI

struct AddElectrodomesticoView: View {
    @EnvironmentObject var router: Router
    
    @StateObject var viewModel = ElectrodomesticoViewModel()
    @StateObject var usageViewModel = ElectrodomesticoUsageViewModel()
    
    @State var nombre: String
    @State var marca: String
    @State var tipo: String
    @State var modelo: String
    @State var potenciaWatts: String
    @State var descripcion: String
    @State var selectedImage: UIImage?
    @State var imagePath: String?

    @State var nuevoElectrodomesticoId: Int? // Para almacenar el ID del nuevo electrodoméstico
    @State var showImagePicker = false
    @State var showUsageView = false // Nuevo estado
    @State var showAlert = false
    @State var alertMessage = ""
    
    init(electrodomestico: Electrodomestico? = nil) {
        if let data = electrodomestico {
            _nombre = State(initialValue: data.nombre)
            _marca = State(initialValue: data.marca)
            _tipo = State(initialValue: data.tipo)
            _modelo = State(initialValue: data.modelo)
            _potenciaWatts = State(initialValue: String(data.consumowatts))
            _descripcion = State(initialValue: data.descripcion ?? "")
            _imagePath = State(initialValue: data.urlimagen)
            if let imagePath = data.urlimagen,
               let uiImage = UIImage(contentsOfFile: imagePath) {
                _selectedImage = State(initialValue: uiImage)
            } else {
                _selectedImage = State(initialValue: nil)
            }
        } else {
            _nombre = State(initialValue: "")
            _marca = State(initialValue: "")
            _tipo = State(initialValue: "")
            _modelo = State(initialValue: "")
            _potenciaWatts = State(initialValue: "")
            _descripcion = State(initialValue: "")
            _selectedImage = State(initialValue: nil)
            _imagePath = State(initialValue: nil)
        }
    }

    var body: some View {
        HStack {
            Button(action: {
                router.goBack()
            }) {
                Image(systemName: "arrow.left.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "#FFA800"))
            }
            Spacer()
            Text("Agregar Electrodoméstico")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                saveElectrodomestico()
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
            Section(header: Text("Información del Electrodoméstico")) {
                TextField("Nombre", text: $nombre)
                TextField("Marca", text: $marca)
                TextField("Tipo", text: $tipo)
                TextField("Modelo", text: $modelo)
                HStack {
                    TextField("Potencia (Watts)", text: $potenciaWatts)
                        .keyboardType(.decimalPad)
                    Button(action: {
                        router.navigate(to: .electrodomesticoReadingsInfo)
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                }
                TextField("Descripción", text: $descripcion)
            }

            Section(header: Text("Foto")) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Button("Cambiar Foto") {
                        selectNewImage()
                    }
                    .foregroundColor(Color(hex: "#FFA800"))
                } else {
                    Button(action: {
                        selectNewImage()
                    }) {
                        Text("Seleccionar Foto")
                            .foregroundColor(Color(hex: "#FFA800"))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationTitle("Agregar Electrodoméstico")
        .navigationBarItems(leading: Button("Cancelar") {
            router.goBack()
        }, trailing: Button("Guardar") {
            saveElectrodomestico()
        })
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    if let image = selectedImage {
                        imagePath = saveImageToDocuments(image: image)
                    }
                }
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        .background(
            NavigationLink(
                destination: Group {
                    if let electrodomesticoId = nuevoElectrodomesticoId,
                       let potencia = Double(potenciaWatts) {
                        AddElectrodomesticoUsageView(
                            electrodomesticoId: electrodomesticoId,
                            potenciaWatts: potencia
                        )
                        .environmentObject(usageViewModel)
                    } else {
                        EmptyView() // Asegúrate de que siempre retorna un View válido
                    }
                },
                isActive: Binding(
                    get: { showUsageView },
                    set: { showUsageView = $0 }
                ),
                label: {
                    EmptyView() // El label debe ser un View válido aunque no se muestre
                }
            )
        )
    }
    
}


