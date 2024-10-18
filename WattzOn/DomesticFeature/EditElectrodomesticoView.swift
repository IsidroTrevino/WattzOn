//
//  EditElectrodomesticoView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct EditElectrodomesticoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var electrodomestico: Electrodomestico

    @State private var nombre: String
    @State private var marca: String
    @State private var tipo: String
    @State private var modelo: String
    @State private var potenciaWatts: String
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    init(electrodomestico: Electrodomestico) {
        self.electrodomestico = electrodomestico
        _nombre = State(initialValue: electrodomestico.nombre)
        _marca = State(initialValue: electrodomestico.marca)
        _tipo = State(initialValue: electrodomestico.tipo)
        _modelo = State(initialValue: electrodomestico.modelo)
        _potenciaWatts = State(initialValue: String(electrodomestico.potenciaWatts))

        if let imagePath = electrodomestico.imagePath,
           let uiImage = UIImage(contentsOfFile: imagePath) {
            _selectedImage = State(initialValue: uiImage)
        } else {
            _selectedImage = State(initialValue: nil)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Electrodoméstico")) {
                    TextField("Nombre", text: $nombre)
                    TextField("Marca", text: $marca)
                    TextField("Tipo", text: $tipo)
                    TextField("Modelo", text: $modelo)
                    TextField("Potencia (Watts)", text: $potenciaWatts)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Foto")) {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Seleccionar Foto")
                        }
                    }
                }
            }
            .navigationTitle("Editar Electrodoméstico")
            .navigationBarItems(leading: Button("Cancelar") {
                dismiss()
            }, trailing: Button("Guardar") {
                saveChanges()
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func saveChanges() {
        // Validar la entrada
        guard let potencia = Double(potenciaWatts), !nombre.isEmpty else {
            // Mostrar mensaje de error si la validación falla
            alertMessage = "Asegúrate de ingresar un nombre y un valor válido para la potencia."
            showAlert = true
            return
        }

        var imagePath: String? = electrodomestico.imagePath

        // Guardar nueva imagen seleccionada, si aplica
        if let image = selectedImage {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = UUID().uuidString + ".jpg"
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documents.appendingPathComponent(filename)
                do {
                    try data.write(to: fileURL)
                    imagePath = fileURL.path

                    // Eliminar la imagen anterior si existe
                    if let oldImagePath = electrodomestico.imagePath {
                        try FileManager.default.removeItem(atPath: oldImagePath)
                    }
                } catch {
                    print("Error al guardar la imagen: \(error)")
                }
            }
        }

        // Eliminar la imagen si se ha quitado la selección
        if selectedImage == nil && electrodomestico.imagePath != nil {
            do {
                try FileManager.default.removeItem(atPath: electrodomestico.imagePath!)
                imagePath = nil
            } catch {
                print("Error al eliminar la imagen: \(error)")
            }
        }

        // Actualizar el electrodoméstico
        electrodomestico.nombre = nombre
        electrodomestico.marca = marca
        electrodomestico.tipo = tipo
        electrodomestico.modelo = modelo
        electrodomestico.potenciaWatts = potencia
        electrodomestico.imagePath = imagePath

        // Guardar cambios en el contexto de datos
        do {
            try modelContext.save()
        } catch {
            print("Error al guardar los cambios: \(error)")
        }

        dismiss()
    }
}

#Preview {
    EditElectrodomesticoView(electrodomestico: Electrodomestico(id: .init(), nombre: "", marca: "", tipo: "", modelo: "", potenciaWatts: 0, imagePath: nil))
}


#Preview {
    EditElectrodomesticoView(electrodomestico: Electrodomestico(id: .init(), nombre: "", marca: "", tipo: "", modelo: "", potenciaWatts: 0, imagePath: nil))
}
