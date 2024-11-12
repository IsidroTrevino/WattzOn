//
//  AddElectrodomesticView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddElectrodomesticoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var nombre: String = ""
    @State private var marca: String = ""
    @State private var tipo: String = ""
    @State private var modelo: String = ""
    @State private var potenciaWatts: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

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
            .navigationTitle("Agregar Electrodoméstico")
            .navigationBarItems(leading: Button("Cancelar") {
                dismiss()
            }, trailing: Button("Guardar") {
                saveElectrodomestico()
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }

    private func saveElectrodomestico() {
        // Validar la entrada
        guard let potencia = Double(potenciaWatts), !nombre.isEmpty else {
            // Mostrar mensaje de error si es necesario
            return
        }

        var imagePath: String? = nil

        if let image = selectedImage {
            if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = UUID().uuidString + ".jpg"
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documents.appendingPathComponent(filename)
                do {
                    try data.write(to: fileURL)
                    imagePath = fileURL.path
                } catch {
                    print("Error al guardar la imagen: \(error)")
                }
            }
        }

        let nuevoElectrodomestico = Electrodomestico(
            electrodomesticoId: 0,
            nombre: nombre,
            tipo: tipo,
            consumowatts: Int(potencia),
            descripcion: "Descripción predeterminada",
            urlimagen: imagePath ?? "",
            marca: marca,
            modelo: modelo
        )


        modelContext.insert(nuevoElectrodomestico)
        dismiss()
    }
}

#Preview {
    AddElectrodomesticoView()
}
