//
//  HomeViewModel.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//

import Foundation
import Combine
import Vision
import UIKit

struct ConsumoEnergetico {
    var ahorro: Double
    var consumo: Double
}

class HomeViewModel: ObservableObject {
    @Published var consumoEnergetico = ConsumoEnergetico(ahorro: 0.0, consumo: 0.0)
    @Published var periodos: [String] = []
    @Published var kwh: [Double] = []
    @Published var importe: [Double] = []
    
    @Published var isProcessing: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var receiptUploaded: Bool = false // Nuevo: Indica si se ha subido un recibo
    
    func recognizeTextFromImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            DispatchQueue.main.async {
                self.errorMessage = "Imagen no válida."
                self.showErrorAlert = true
            }
            return
        }
        
        isProcessing = true
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let self = self else { return }
            self.isProcessing = false
            guard error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al analizar la imagen: \(error!.localizedDescription)"
                    self.showErrorAlert = true
                }
                return
            }
            
            if let results = request.results as? [VNRecognizedTextObservation] {
                let extractedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                DispatchQueue.main.async {
                    if extractedText.isEmpty {
                        self.errorMessage = "No se encontró texto en la imagen."
                        self.showErrorAlert = true
                    } else {
                        self.processText(extractedText)
                    }
                }
            }
        }
        
        request.recognitionLevel = .accurate
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.errorMessage = "Error al realizar la solicitud: \(error.localizedDescription)"
                    self.showErrorAlert = true
                }
            }
        }
    }
    
    private func processText(_ text: String) {
        var tempPeriodos: [String] = []
        var tempKwh: [Double] = []
        var tempImporte: [Double] = []

        let lines = text.components(separatedBy: "\n")

        var readingKwh = false
        var readingImporte = false

        // Formateadores de fecha para extraer meses
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_MX") // O "es_ES", según corresponda
        dateFormatter.dateFormat = "dd MMM yy" // Ajustado al formato de tu recibo

        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "es_MX")
        monthFormatter.dateFormat = "MMM" // Para obtener abreviaturas de meses, por ejemplo, "Ene", "Feb"

        for line in lines {
            if line.contains("Período") || line.trimmingCharacters(in: .whitespaces).isEmpty {
                continue
            }

            // Procesa Periodos
            if line.contains("del") && line.contains("al") {
                // Eliminar las palabras "del" y "al" y los espacios adicionales
                let lineSinDelAl = line.replacingOccurrences(of: "del ", with: "").replacingOccurrences(of: " al ", with: " ")
                let components = lineSinDelAl.components(separatedBy: " ")

                if components.count >= 6 {
                    // Extraer las cadenas de fecha
                    let fechaInicioString = "\(components[0]) \(components[1]) \(components[2])"
                    let fechaFinString = "\(components[3]) \(components[4]) \(components[5])"

                    // Parsear las fechas
                    if let fechaInicio = dateFormatter.date(from: fechaInicioString),
                       let fechaFin = dateFormatter.date(from: fechaFinString) {
                        // Obtener los nombres de los meses
                        let mesInicio = monthFormatter.string(from: fechaInicio)
                        let mesFin = monthFormatter.string(from: fechaFin)

                        // Añadir el periodo en formato "Ene-Feb"
                        tempPeriodos.append("\(mesInicio)-\(mesFin)")
                    } else {
                        print("No se pudo parsear las fechas: \(fechaInicioString) y \(fechaFinString)")
                    }
                } else {
                    print("No hay suficientes componentes para extraer las fechas en la línea: \(line)")
                }
            }

            // Inicia lectura de kWh
            else if line.contains("kWh") {
                readingKwh = true
                readingImporte = false
                continue
            }

            // Inicia lectura de Importe
            else if line.contains("Importe") {
                readingKwh = false
                readingImporte = true
                continue
            }

            // Termina lectura de Importe al encontrar Pagos
            else if line.contains("Pagos") {
                readingImporte = false
                break
            }

            // Añadir valores a kWh e Importe
            if readingKwh {
                let kwhValue = line.trimmingCharacters(in: .whitespaces)
                if let kwhDouble = Double(kwhValue.replacingOccurrences(of: ",", with: ".")) {
                    tempKwh.append(kwhDouble)
                }
            } else if readingImporte, line.starts(with: "$") {
                let importeValue = line.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ".")
                if let importeDouble = Double(importeValue) {
                    tempImporte.append(importeDouble)
                }
            }
        }

        // Actualizar las propiedades publicadas
        DispatchQueue.main.async {
            self.periodos = tempPeriodos
            self.kwh = tempKwh
            self.importe = tempImporte

            // Calcular el consumo total y ahorro (ajusta según tu lógica)
            self.consumoEnergetico.consumo = self.kwh.reduce(0, +)
            self.consumoEnergetico.ahorro = self.importe.reduce(0, +) // Ajusta según cómo defines ahorro

            self.receiptUploaded = true // Indicar que el recibo ha sido procesado
        }
    }

}
