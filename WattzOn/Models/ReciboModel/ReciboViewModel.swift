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

class ReciboViewModel: ObservableObject {
    @Published var recibos: [Recibo] = []
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false

    var modelContext: ModelContext?

    func getCurrentUsuario() -> Usuario? {
        guard let context = modelContext else {
            print("ModelContext no está disponible")
            return nil
        }
        let fetchRequest = FetchDescriptor<Usuario>(predicate: nil)
        do {
            let usuarios = try context.fetch(fetchRequest)
            return usuarios.first
        } catch {
            print("Error al obtener el usuario:", error)
            return nil
        }
    }

    // Función para obtener los recibos desde la API
    func fetchRecibos() async {
        guard let currentUser = getCurrentUsuario() else {
            print("Usuario no encontrado")
            return
        }
        let usuarioId = currentUser.usuarioId
        let token = currentUser.token

        do {
            let recibos = try await fetchRecibosFromAPI(usuarioId: usuarioId, token: token)
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
        let urlString = "https://wattzonapi.onrender.com/api/wattzon/recibo/usuario/\(usuarioId)"
        print("Fetching from URL: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }

            let recibos = try decoder.decode([Recibo].self, from: data)
            return recibos
        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }

    // Función para crear un recibo a través de la API
    func createRecibo(_ recibo: Recibo) async throws -> Recibo {
        guard let usuario = getCurrentUsuario() else {
            print("Usuario no encontrado")
            throw NSError(domain: "Usuario no encontrado", code: 0)
        }
        let token = usuario.token

        guard let url = URL(string: "https://wattzonapi.onrender.com/api/wattzon/recibo/add") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(recibo)
            urlRequest.httpBody = jsonData
            
            // **Imprime el JSON para depuración**
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("JSON enviado al servidor:")
                print(jsonString)
            }
    
        } catch {
            print("Error al codificar el recibo:", error)
            throw error
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }

            let createdRecibo = try decoder.decode(Recibo.self, from: data)
            return createdRecibo
        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }

    // Función para actualizar un recibo a través de la API
    func updateRecibo(_ recibo: Recibo) async throws {
        guard let usuario = getCurrentUsuario() else {
            print("Usuario no encontrado")
            throw NSError(domain: "Usuario no encontrado", code: 0)
        }
        let token = usuario.token

        guard let idRecibo = recibo.idRecibo else {
            print("ID del recibo no disponible")
            throw NSError(domain: "ID del recibo no disponible", code: 0)
        }

        guard let url = URL(string: "https://wattzonapi.onrender.com/api/wattzon/recibo/\(idRecibo)") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

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

    // Función para eliminar un recibo a través de la API
    func deleteRecibo(_ idRecibo: Int) async throws {
        guard let usuario = getCurrentUsuario() else {
            print("Usuario no encontrado")
            throw NSError(domain: "Usuario no encontrado", code: 0)
        }
        let token = usuario.token

        guard let url = URL(string: "https://wattzonapi.onrender.com/api/wattzon/recibo/\(idRecibo)") else {
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
