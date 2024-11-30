//
//  DomesticViewAux.swift
//  WattzOn
//
//  Created by Fernando Espidio on 27/11/24.
//

import Foundation
import UIKit
import CoreVideo
import SwiftData
import AVFoundation
import CoreML

extension DomesticoView {
    func deleteElectrodomestico(at offsets: IndexSet) {
        for index in offsets {
            let electrodomestico = viewModel.electrodomesticos[index]

            // Eliminar el archivo de imagen si existe
            if let imagePath = electrodomestico.urlimagen {
                do {
                    try FileManager.default.removeItem(atPath: imagePath)
                } catch {
                    print("Error al eliminar la imagen: \(error)")
                }
            }

            // Eliminar del servidor
            Task {
                do {
                    if let electrodomesticoId = electrodomestico.electrodomesticoId {
                        try await viewModel.deleteElectrodomestico(electrodomesticoId)
                        DispatchQueue.main.async {
                            viewModel.electrodomesticos.remove(at: index)
                        }
                    }
                } catch {
                    print("Error al eliminar electrodoméstico:", error)
                    DispatchQueue.main.async {
                        viewModel.errorMessage = "Error al eliminar electrodoméstico."
                        viewModel.showErrorAlert = true
                    }
                }
            }
        }
    }

    // MARK: - Manejo de permisos y disponibilidad de la cámara

    func handleCameraAccess() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.presentCamera()
                    } else {
                        self.errorMessage = "El acceso a la cámara ha sido denegado."
                        self.showErrorAlert = true
                    }
                }
            }
        case .authorized:
            presentCamera()
        case .restricted, .denied:
            errorMessage = "El acceso a la cámara está restringido o denegado."
            showErrorAlert = true
        @unknown default:
            errorMessage = "Error desconocido al acceder a la cámara."
            showErrorAlert = true
        }
    }

    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerSourceType = .camera
            showImagePicker = true
        } else {
            errorMessage = "La cámara no está disponible en este dispositivo."
            showErrorAlert = true
        }
    }

    // MARK: - Procesamiento de imagen y ML

    func processImage(_ image: UIImage) {
        print("jajajaj")
        isProcessingImage = true
        print("777")

        // Convertir UIImage a CVPixelBuffer
        guard let pixelBuffer = image.toCVPixelBuffer() else {
            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.errorMessage = "No se pudo procesar la imagen."
                self.showErrorAlert = true
            }
            return
        }
        print("666666")

        // Cargar el modelo de ML
        do {
            let config = MLModelConfiguration()
            let model = try ModelDiego(configuration: config)
            print("55555")
            // Crear la entrada del modelo utilizando el CVPixelBuffer
            let input = ModelDiegoInput(image: pixelBuffer)

            // Realizar la predicción
            let output = try model.prediction(input: input)

            // Obtener la clasificación y probabilidades
            let classification = output.target
            let probabilities = output.targetProbability
            
            print("4444")
        
            // Validar la confianza de la clasificación
            guard let confidence = probabilities[classification] else {
                DispatchQueue.main.async {
                    self.isProcessingImage = false
                    self.errorMessage = "Error al obtener la confianza de la clasificación."
                    self.showErrorAlert = true
                }
                return
            }

            let confidencePercentage = confidence * 100

            if confidencePercentage < 20 {
                // La confianza es menor al 50%, mostrar opción de intentar de nuevo o llenar manualmente
                DispatchQueue.main.async {
                    self.isProcessingImage = false
                    self.showNoMatchAlert = true
                }
                return
            }
            
            print("3")
            
            // Dividir la clasificación por guiones bajos "_"
            let components = classification.split(separator: "_")

            // Verificar que haya al menos dos componentes (tipo y watts)
            guard let tipo = components.first else {
                DispatchQueue.main.async {
                    self.isProcessingImage = false
                    self.errorMessage = "Formato de clasificación inesperado."
                    self.showErrorAlert = true
                }
                return
            }
            
            print("22222")
            
            // Reconstruir el nombre eliminando el primer componente (tipo)
            let nombre = components.dropLast().joined(separator: " ").replacingOccurrences(of: "_", with: " ")

            // Extraer la potencia (último componente después del último guion bajo)
            guard let potenciaWattsString = components.last,
                  let potenciaWatts = Double(potenciaWattsString) else {
                DispatchQueue.main.async {
                    self.isProcessingImage = false
                    self.errorMessage = "Error al interpretar la potencia en watts."
                    self.showErrorAlert = true
                }
                return
            }

            // Guardar la imagen y obtener su ruta
            guard let imagePath = saveImageToDocuments(image: image) else {
                DispatchQueue.main.async {
                    self.isProcessingImage = false
                    self.errorMessage = "Error al guardar la imagen."
                    self.showErrorAlert = true
                }
                return
            }

            // Obtener el usuario actual
            guard let usuario = getCurrentUsuario() else {
                print("Usuario no encontrado")
                return
            }
            let usuarioId = usuario.usuarioId

            // Crear el objeto Electrodomestico
            let nuevoElectrodomestico = Electrodomestico(
                electrodomesticoId: 0,
                usuarioId: usuarioId,
                nombre: nombre,
                tipo: String(tipo), // Convertir tipo de Substring a String
                consumowatts: potenciaWatts,
                descripcion: "",
                urlimagen: imagePath,
                marca: "",
                modelo: ""
            )

            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.extractedElectrodomestico = nuevoElectrodomestico
                print("Electrodomestico extraído: \(nuevoElectrodomestico.nombre)")
            }

        } catch {
            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.errorMessage = "Error al procesar la imagen con el modelo de ML."
                self.showErrorAlert = true
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

// Extensión para convertir UIImage a CVPixelBuffer
extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let image = self.cgImage!
        let frameSize = CGSize(width: image.width, height: image.height)

        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(frameSize.width),
            Int(frameSize.height),
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(buffer)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: Int(frameSize.width),
            height: Int(frameSize.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
            return nil
        }

        context.draw(image, in: CGRect(origin: .zero, size: frameSize))

        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))

        return buffer
    }
}
