//
//  EditElectrodomesticoView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

// EditElectrodomesticoView.swift

import SwiftUI
import PhotosUI

struct EditElectrodomesticoView: View {
    @EnvironmentObject var router: Router
    
    @StateObject var viewModel = ElectrodomesticoViewModel()
    
    var electrodomestico: Electrodomestico
    
    @State var nombre: String
    @State var marca: String
    @State var tipo: String
    @State var modelo: String
    @State var potenciaWatts: String
    @State var descripcion: String
    @State var selectedImage: UIImage?
    @State var imagePath: String?
    
    @State var showImagePicker = false
    @State var showAlert = false
    @State var alertMessage = ""
    
    init(electrodomestico: Electrodomestico) {
        self.electrodomestico = electrodomestico
        _nombre = State(initialValue: electrodomestico.nombre)
        _marca = State(initialValue: electrodomestico.marca)
        _tipo = State(initialValue: electrodomestico.tipo)
        _modelo = State(initialValue: electrodomestico.modelo)
        _potenciaWatts = State(initialValue: String(electrodomestico.consumowatts))
        _descripcion = State(initialValue: electrodomestico.descripcion ?? "")
        _imagePath = State(initialValue: electrodomestico.urlimagen)
        if let imagePath = electrodomestico.urlimagen,
           let uiImage = UIImage(contentsOfFile: imagePath) {
            _selectedImage = State(initialValue: uiImage)
        } else {
            _selectedImage = State(initialValue: nil)
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
            Text("Editar Electrodoméstico")
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
        .navigationTitle("Editar Electrodoméstico")
        .navigationBarItems(leading: Button("Cancelar") {
            router.goBack()
        }, trailing: Button("Guardar") {
            saveChanges()
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
    }
}
