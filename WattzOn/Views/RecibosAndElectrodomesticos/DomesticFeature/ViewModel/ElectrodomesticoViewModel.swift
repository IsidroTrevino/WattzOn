//
//  ElectrodomesticoViewModel.swift
//  WattzOn
//
//  Created by Isidro Treviño on 07/11/24.
//

// ElectrodomesticoViewModel.swift

import Foundation
import SwiftUI
import SwiftData

class ElectrodomesticoViewModel: ObservableObject {
    @Published var electrodomesticos: [Electrodomestico] = []
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    @Query var usuario: [UsuarioResponse]
    
    // Función para traer los electrdomésticos desde la API
    func fetchElectrodomesticosFromAPI(usuarioId: Int, token: String) async throws -> [Electrodomestico] {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/electrodomestico/usuario/\(usuarioId)") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
                guard httpResponse.statusCode == 200 else {
                    print("Error: Respuesta del servidor no fue 200 OK")
                    throw URLError(.badServerResponse)
                }
            }

            let decoder = JSONDecoder()
            let electrodomesticos = try decoder.decode([Electrodomestico].self, from: data)
            return electrodomesticos

        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }

    // Función para crear un electrodoméstico a través de la API
    func createElectrodomestico(_ electrodomestico: Electrodomestico, token: String) async throws -> Electrodomestico {
        
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/electrodomestico") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        // Configura la solicitud

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Preparar el cuerpo de la solicitud
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(electrodomestico)
            urlRequest.httpBody = jsonData
        } catch {
            print("Error al codificar el electrodoméstico:", error)
            throw error
        }

        // Empieza la solicitud
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }

            // Decodificar la respuesta para obtener el electrodoméstico creado
            let decoder = JSONDecoder()
            let createdElectrodomestico = try decoder.decode(Electrodomestico.self, from: data)
            return createdElectrodomestico
        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }

    // Función para actualizar un electrodoméstico a través de la API
    func updateElectrodomestico(_ electrodomestico: Electrodomestico, token: String) async throws {
        
        guard let electrodomesticoId = electrodomestico.electrodomesticoId else {
            print("ID del electrodoméstico no disponible")
            throw NSError(domain: "ID del electrodoméstico no disponible", code: 0)
        }

        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/electrodomestico/\(electrodomesticoId)") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Preparar el cuerpo de la solicitud
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(electrodomestico)
            urlRequest.httpBody = jsonData
        } catch {
            print("Error al codificar el electrodoméstico:", error)
            throw error
        }

        // Hacer la solicitud
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
    
    // Función para obtener los electrodomésticos desde la API
    func fetchElectrodomesticos(usuarioId: Int, token: String) async {
        do {
            let fetchedElectrodomesticos = try await fetchElectrodomesticosFromAPI(usuarioId: usuarioId, token: token)
            DispatchQueue.main.async {
                self.electrodomesticos = fetchedElectrodomesticos
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error al obtener electrodomésticos"
                self.showErrorAlert = true
            }
            print("Error:", error)
        }
    }
    
    // Función para eliminar un electrodoméstico a través de la API
    func deleteElectrodomestico(_ electrodomesticoId: Int, token: String) async throws {
        
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/electrodomestico/\(electrodomesticoId)") else {
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
