//
//  Auxiliar Functions.swift
//  WattzOn
//
//  Created by Fernando Espidio on 27/11/24.
//

import Foundation
import PhotosUI

extension AddElectrodomesticoView {
    func selectNewImage() {
        showImagePicker = true
    }

    func saveElectrodomestico() {
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
                let createdElectrodomestico = try await viewModel.createElectrodomestico(nuevoElectrodomestico)
                DispatchQueue.main.async {
                    // Guardar el ID del nuevo electrodoméstico
                    self.nuevoElectrodomesticoId = createdElectrodomestico.electrodomesticoId
                    // Mostrar la vista para ingresar las horas de uso
                    self.showUsageView = true

                    //router.goBack()
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


