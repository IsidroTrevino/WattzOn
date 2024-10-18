//
//  OCRProcessor.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

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

struct ExtractedReceiptData {
    var fechaRegistro: Date
    var lecturaActual: Int
    var lecturaAnterior: Int
    var totales: [Int]
    var precios: [Double]
    var totalFinales: [Double]
}
