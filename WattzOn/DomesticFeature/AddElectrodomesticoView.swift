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
    @StateObject private var viewModel = ElectrodomesticoViewModel()

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
    }

    private func selectNewImage() {
        showImagePicker = true
    }

    private func saveElectrodomestico() {
        // Validar la entrada
        guard let potencia = Double(potenciaWatts), !nombre.isEmpty else {
            alertMessage = "Asegúrate de ingresar un nombre y un valor válido para la potencia."
            showAlert = true
            return
        }

        // Obtener el usuario actual
        guard let usuario = getCurrentUsuario() else {
            print("Usuario no encontrado")
            return
        }
        let usuarioId = usuario.usuarioId

        // Crear el nuevo electrodoméstico
        let nuevoElectrodomestico = Electrodomestico(
            electrodomesticoId: 0,
            usuarioId: usuarioId,
            nombre: nombre,
            tipo: tipo,
            consumowatts: potencia,
            descripcion: descripcion,
            urlimagen: imagePath,
            marca: marca,
            modelo: modelo
        )

        Task {
            do {
                _ = try await viewModel.createElectrodomestico(nuevoElectrodomestico)
                DispatchQueue.main.async {
                    router.goBack()
                }
            } catch {
                print("Error al agregar electrodoméstico:", error)
                DispatchQueue.main.async {
                    self.viewModel.errorMessage = "Error al agregar electrodoméstico."
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
