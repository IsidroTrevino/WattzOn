//
//  OCRProcessor.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

// OCRProcessor.swift

import Foundation
import UIKit
import Vision

class OCRProcessor {
    func recognizeText(from image: UIImage, completion: @escaping (Result<ExtractedReceiptData, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(OCRProcessorError.invalidImage))
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(OCRProcessorError.noTextFound))
                return
            }

            var recognizedText = ""
            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    recognizedText += topCandidate.string + " "
                }
            }

            let extractedData = self.processRecognizedText(text: recognizedText)
            completion(.success(extractedData))
        }

        request.recognitionLanguages = ["es-ES"]
        request.recognitionLevel = .accurate

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func processRecognizedText(text: String) -> ExtractedReceiptData {
        let words = text.split(separator: " ").map { String($0) }
        var integers: [Int] = []
        var doubles: [Double] = []

        // Extract integers and doubles
        for word in words {
            if let intValue = Int(word) {
                integers.append(intValue)
            } else if let doubleValue = Double(word) {
                doubles.append(doubleValue)
            } else {
                // Try to parse numbers with comma as decimal separator
                let normalizedWord = word.replacingOccurrences(of: ",", with: ".")
                if let doubleValue = Double(normalizedWord) {
                    doubles.append(doubleValue)
                }
            }
        }

        var lecturaActual = 0
        var lecturaAnterior = 0
        var totales: [Int] = []
        var precios: [Double] = []
        var subtotal: Double = 0.0
        var conceptos: [Concepto] = []

        // Assign values based on the order provided
        if integers.count >= 2 {
            lecturaActual = integers[0]
            lecturaAnterior = integers[1]
            if integers.count > 2 {
                totales = Array(integers[2...])
            }
        }

        if doubles.count >= totales.count {
            precios = Array(doubles[0..<totales.count])
            if doubles.count > totales.count {
                subtotal = doubles.last ?? 0.0
            }
        }

        // Create conceptos
        for i in 0..<min(totales.count, precios.count) {
            let concepto = Concepto(
                idCategoriaConcepto: i + 1, // Assuming 1: Básico, 2: Intermedio, 3: Excedente
                TotalPeriodo: totales[i],
                Precio: precios[i]
            )
            conceptos.append(concepto)
        }
        

        print("Palabras procesadas: \(words)")
        print("Números enteros detectados: \(integers)")
        print("Números decimales detectados: \(doubles)")
        
        return ExtractedReceiptData(
            lecturaActual: lecturaActual,
            lecturaAnterior: lecturaAnterior,
            subtotal: subtotal,
            conceptos: conceptos
        )
    }
}

enum OCRProcessorError: Error {
    case invalidImage
    case noTextFound
}


/*
import Foundation
import UIKit
import Vision

class OCRProcessor {
    func recognizeText(from image: UIImage, completion: @escaping (Result<ExtractedReceiptData, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(OCRProcessorError.invalidImage))
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.failure(OCRProcessorError.noTextFound))
                return
            }

            var recognizedText = ""
            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    recognizedText += topCandidate.string + " "
                }
            }

            let extractedData = self.processRecognizedText(text: recognizedText)
            completion(.success(extractedData))
        }

        request.recognitionLanguages = ["es-ES"]
        request.recognitionLevel = .accurate

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func processRecognizedText(text: String) -> ExtractedReceiptData {
        let words = text.split(separator: " ").map { String($0) }
        var integers: [Int] = []
        var floats: [Double] = []

        // Extract integers and floats
        for word in words {
            if let intValue = Int(word) {
                integers.append(intValue)
            } else if let floatValue = Double(word) {
                floats.append(floatValue)
            }
        }

        var lecturaActual = 0
        var lecturaAnterior = 0
        var totales: [Int] = []
        var precios: [Double] = []
        var totalFinales: [Double] = []

        // Assign values based on the order provided
        if integers.count >= 2 {
            lecturaActual = integers[0]
            lecturaAnterior = integers[1]
            if integers.count > 2 {
                totales = Array(integers[2...])
            }
        }

        if floats.count >= totales.count {
            precios = Array(floats[0..<totales.count])
            totalFinales = Array(floats[totales.count..<floats.count])
        }

        return ExtractedReceiptData(
            fechaRegistro: Date(),
            lecturaActual: lecturaActual,
            lecturaAnterior: lecturaAnterior,
            totales: totales,
            precios: precios,
            totalFinales: totalFinales
        )
    }
}

enum OCRProcessorError: Error {
    case invalidImage
    case noTextFound
}
*/
