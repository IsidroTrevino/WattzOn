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
    @StateObject private var viewModel = ElectrodomesticoViewModel()

    var electrodomestico: Electrodomestico

    @State private var nombre: String
    @State private var marca: String
    @State private var tipo: String
    @State private var modelo: String
    @State private var potenciaWatts: String
    @State private var descripcion: String
    @State private var selectedImage: UIImage?
    @State private var imagePath: String?

    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

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

    private func selectNewImage() {
        showImagePicker = true
    }

    private func saveChanges() {
        // Validar la entrada
        guard let potencia = Double(potenciaWatts), !nombre.isEmpty else {
            // Mostrar mensaje de error si la validación falla
            alertMessage = "Asegúrate de ingresar un nombre y un valor válido para la potencia."
            showAlert = true
            return
        }

        // Actualizar el electrodoméstico local
        var updatedElectrodomestico = electrodomestico
        updatedElectrodomestico.nombre = nombre
        updatedElectrodomestico.marca = marca
        updatedElectrodomestico.tipo = tipo
        updatedElectrodomestico.modelo = modelo
        updatedElectrodomestico.consumowatts = potencia
        updatedElectrodomestico.descripcion = descripcion
        updatedElectrodomestico.urlimagen = imagePath

        Task {
            do {
                try await viewModel.updateElectrodomestico(updatedElectrodomestico)
                DispatchQueue.main.async {
                    router.goBack()
                }
            } catch {
                print("Error al actualizar el electrodoméstico:", error)
                DispatchQueue.main.async {
                    self.viewModel.errorMessage = "Error al actualizar el electrodoméstico."
                    self.viewModel.showErrorAlert = true
                }
            }
        }
    }

    func saveImageToDocuments(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let url = getDocumentsDirectory().appendingPathComponent(filename)

        do {
            try data.write(to: url)
            return url.path
        } catch {
            print("Error al guardar la imagen: \(error)")
            return nil
        }
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
