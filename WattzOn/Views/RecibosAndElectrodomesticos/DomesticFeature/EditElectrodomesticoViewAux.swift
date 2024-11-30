//
//  EditDomesticoAux.swift
//  WattzOn
//
//  Created by Fernando Espidio on 27/11/24.
//

import Foundation
import PhotosUI

extension EditElectrodomesticoView {
    func selectNewImage() {
        showImagePicker = true
    }

    func saveChanges() {
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
