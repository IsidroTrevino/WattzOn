//
//  ReciboVM.swift
//  WattzOn
//
//  Created by Fernando Espidio on 01/11/24.
//

// ReciboViewModel.swift

import Foundation
import SwiftUI
import SwiftData

let secureConnection = "https"

class ReciboViewModel: ObservableObject {
    @Published var recibos: [Recibo] = []
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false

    var modelContext: ModelContext?

    private let customDecoder: JSONDecoder

    init() {
        self.customDecoder = JSONDecoder()
        self.customDecoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            // Intentar decodificar con ISO-8601 con segundos fraccionarios
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = isoFormatter.date(from: dateString) {
                return date
            }

            // Intentar con un formateador personalizado
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
    }
    
    // Función para obtener los recibos desde la API
    func fetchRecibos(usuarioId: Int, token: String) async {

        do {
            let recibos = try await fetchRecibosFromAPI(usuarioId: usuarioId, token: token)
            print("Recibos obtenidos: \(recibos.count)")
            
            DispatchQueue.main.async {
                self.recibos = recibos
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error al obtener los recibos: \(error)"
                self.showErrorAlert = true
            }
        }
    }

    func fetchRecibosFromAPI(usuarioId: Int, token: String) async throws -> [Recibo] {
        let urlString = "\(secureConnection)://\(ipAddress)/api/wattzon/recibo/usuario/\(usuarioId)"
        print("Fetching from URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        
        // Custom Date Decoding Strategy
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            // Attempt ISO-8601 decoding with fractional seconds
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = isoFormatter.date(from: dateString) {
                return date
            }

            // Attempt fallback decoding with a custom DateFormatter
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }

            let recibos = try customDecoder.decode([Recibo].self, from: data) // Usa customDecoder
            return recibos
        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }

    // Función para crear un recibo a través de la API
    func createRecibo(_ recibo: Recibo, token: String) async throws -> Recibo {
        guard let url = URL(string: "\(secureConnection)://\(ipAddress)/api/wattzon/recibo/add") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        
        // Custom Date Encoding Strategy
        encoder.dateEncodingStrategy = .custom({ date, encoder in
            var container = encoder.singleValueContainer()
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let dateString = isoFormatter.string(from: date)
            try container.encode(dateString)
        })

        do {
            let jsonData = try encoder.encode(recibo)
            urlRequest.httpBody = jsonData
            
            // Debug: Imprime el JSON enviado
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON enviado al servidor:")
                print(jsonString)
            }
        } catch {
            print("Error al codificar el recibo:", error)
            throw error
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }
            
            /*
            // Print the raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON recibido del servidor:")
                print(jsonString)
            }
             */

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }

            let createdRecibo = try customDecoder.decode(Recibo.self, from: data) // Usa customDecoder
            
            // print("Conceptos del recibo seleccionado: \(createdRecibo.conceptos.map { $0.description }.joined(separator: "\n"))")

            return createdRecibo
        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }

    // MARK: - Función para actualizar un recibo a través de la API
    func updateRecibo(_ recibo: Recibo, token: String) async throws {

        guard let idRecibo = recibo.idRecibo else {
            print("ID del recibo no disponible")
            throw NSError(domain: "ID del recibo no disponible", code: 0, userInfo: nil)
        }

        guard let url = URL(string: "\(secureConnection)://\(ipAddress)/api/wattzon/recibo/\(idRecibo)") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = isoFormatter.string(from: date)
            try container.encode(dateString)
        }

        do {
            let jsonData = try encoder.encode(recibo)
            urlRequest.httpBody = jsonData
        } catch {
            print("Error al codificar el recibo:", error)
            throw error
        }

        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }
        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }

    // MARK: - Función para eliminar un recibo a través de la API
    func deleteRecibo(_ idRecibo: Int, token: String) async throws {
        guard let url = URL(string: "\(secureConnection)://\(ipAddress)/api/wattzon/recibo/\(idRecibo)") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }
        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }
    
}
