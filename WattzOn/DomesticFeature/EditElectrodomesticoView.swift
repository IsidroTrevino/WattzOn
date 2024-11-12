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
    @State private var consumowatts: String
    @State private var descripcion: String
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
        _consumowatts = State(initialValue: String(electrodomestico.consumowatts))
        _descripcion = State(initialValue: electrodomestico.descripcion)

        if let imagePath = electrodomestico.urlimagen,
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
                    TextField("Potencia (Watts)", text: $consumowatts)
                        .keyboardType(.decimalPad)
                    TextField("Descripción", text: $descripcion)
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
        // Validate the input
        guard let potencia = Int(consumowatts), !nombre.isEmpty else {
            alertMessage = "Asegúrate de ingresar un nombre y un valor válido para la potencia."
            showAlert = true
            return
        }

        var imagePath: String? = electrodomestico.urlimagen

        // Save selected image, if applicable
        if let image = selectedImage {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = UUID().uuidString + ".jpg"
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documents.appendingPathComponent(filename)
                do {
                    try data.write(to: fileURL)
                    imagePath = fileURL.path

                    // Delete the previous image if it exists
                    if let oldImagePath = electrodomestico.urlimagen {
                        try FileManager.default.removeItem(atPath: oldImagePath)
                    }
                } catch {
                    print("Error al guardar la imagen: \(error)")
                }
            }
        }

        // Remove image if unselected
        if selectedImage == nil && electrodomestico.urlimagen != nil {
            do {
                try FileManager.default.removeItem(atPath: electrodomestico.urlimagen!)
                imagePath = nil
            } catch {
                print("Error al eliminar la imagen: \(error)")
            }
        }

        // Update the appliance details
        electrodomestico.nombre = nombre
        electrodomestico.marca = marca
        electrodomestico.tipo = tipo
        electrodomestico.modelo = modelo
        electrodomestico.consumowatts = potencia
        electrodomestico.descripcion = descripcion
        electrodomestico.urlimagen = imagePath

        // Save changes to the context
        do {
            try modelContext.save()
        } catch {
            print("Error al guardar los cambios: \(error)")
        }

        dismiss()
    }
}

#Preview {
    EditElectrodomesticoView(electrodomestico: Electrodomestico(
        electrodomesticoId: 1,
        nombre: "Refrigerador",
        tipo: "Electrodoméstico",
        consumowatts: 150,
        descripcion: "Descripción del electrodoméstico",
        urlimagen: "cfe",
        marca: "Marca",
        modelo: "Modelo X"
    ))
}
