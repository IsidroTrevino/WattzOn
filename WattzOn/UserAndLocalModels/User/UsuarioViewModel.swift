import Foundation
import SwiftData

let ipAddress = "wattzonapi.onrender.com"

@MainActor
class UsuarioLogIn: ObservableObject {
    @Published var usuarioResponse: UsuarioResponse?

    func login(email: String, password: String) async throws -> UsuarioResponse {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/usuario/login") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody = [
            "email": email,
            "password": password
        ]

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
                guard httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }

            // Decodificar la respuesta del servidor
            let loginResponse = try JSONDecoder().decode(UsuarioResponse.self, from: data)
            print("Usuario ID: \(loginResponse.usuario.usuarioId), Token: \(loginResponse.token)")

            self.usuarioResponse = loginResponse
            return loginResponse

        } catch {
            print("Error al obtener datos del usuario: \(error)")
            throw error
        }
    }
}

@MainActor
class UsuarioRegister: ObservableObject {
    func register(nombre: String, apellido: String, email: String, password: String, ciudad: String?, estado: String?) async throws -> UsuarioResponse {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/usuario/register") else {
            print("URL inválida")
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "nombre": nombre,
            "apellido": apellido,
            "email": email,
            "password": password,
            "ciudad": ciudad ?? "",
            "estado": estado ?? ""
        ]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
                guard httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            
            // Decodificar la respuesta del servidor
            let registerResponse = try JSONDecoder().decode(UsuarioResponse.self, from: data)
            print("Usuario ID: \(registerResponse.usuario.usuarioId), Token: \(registerResponse.token)")
            
            return registerResponse
        } catch {
            print("Error al registrar usuario: \(error)")
            throw error
        }
    }
}

@MainActor
class UsuarioUpdate: ObservableObject {
    @Published var usuarioResponse: Usuario?

    func updateUser(usuarioId: Int, token: String, nombre: String, apellido: String, email: String, ciudad: String?, estado: String?) async throws -> Usuario {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/usuario/\(usuarioId)") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let requestBody: [String: Any] = [
            "nombre": nombre,
            "apellido": apellido,
            "email": email,
            "ciudad": ciudad ?? "",
            "estado": estado ?? ""
        ]

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
                guard httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }

            // Imprimir la respuesta del servidor para depuración
            if let responseString = String(data: data, encoding: .utf8) {
                print("Respuesta del servidor: \(responseString)")
            }

            let updateResponse = try JSONDecoder().decode(Usuario.self, from: data)
            print("Usuario Actualizado: \(updateResponse.usuarioId)")

            self.usuarioResponse = updateResponse
            return updateResponse
        } catch {
            print("Error al actualizar el usuario: \(error)")
            throw error
        }
    }
}
