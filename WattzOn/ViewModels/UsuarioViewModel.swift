import Foundation
import SwiftData

let ipAddress = "wattzonapi.onrender.com"
// let ipAddress = "192.168.100.22"

@MainActor
class UsuarioLogIn: ObservableObject {
    @Published var usuario: Usuario?

    func login(email: String, password: String) async throws -> Usuario {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/usuario/login") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Crear el cuerpo de la solicitud con email y password
        let requestBody = [
            "email": email,
            "password": password
        ]

        do {
            let requestBodyData = try JSONSerialization.data(withJSONObject: requestBody, options: [])

            urlRequest.httpBody = requestBodyData

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // Verificar el código de estado HTTP
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
                guard httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }

            // Decodificar la respuesta en LoginResponse
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)

            // Crear el usuario con los datos recibidos
            let usuarioResponse = loginResponse.usuario
            let usuario = Usuario(
                usuarioId: usuarioResponse.usuarioId,
                nombre: usuarioResponse.nombre,
                apellido: usuarioResponse.apellido,
                email: usuarioResponse.email,
                ciudad: usuarioResponse.ciudad,
                estado: usuarioResponse.estado,
                token: loginResponse.token // Asignar el token recibido
            )

            saveToUserDefaults(usuarioId: usuario.usuarioId, token: usuario.token)
            
            print(usuario.usuarioId)
            print(usuario.token)


            self.usuario = usuario

            // Devolver el usuario
            return usuario

        } catch {
            print("Error al obtener datos del usuario: \(error)")
            throw error
        }
    }
}


// Estructuras para decodificar la respuesta del servidor
struct LoginResponse: Decodable {
    let token: String
    let usuario: UsuarioResponse
}

struct UsuarioResponse: Decodable {
    let usuarioId: Int
    let nombre: String
    let apellido: String
    let email: String
    let ciudad: String?
    let estado: String?
    let fecharegistro: String?
}


@MainActor
class UsuarioRegister: ObservableObject {
    func register(nombre: String, apellido: String, email: String, password: String, ciudad: String?, estado: String?) async throws -> Usuario {
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
            print("Cuerpo de la solicitud:", String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "Cuerpo vacío")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }
            
            // Decodificar la respuesta en LoginResponse
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            
            // Crear el usuario y asignar el token
            let usuarioResponse = loginResponse.usuario
            let usuario = Usuario(
                usuarioId: usuarioResponse.usuarioId,
                nombre: usuarioResponse.nombre,
                apellido: usuarioResponse.apellido,
                email: usuarioResponse.email,
                ciudad: usuarioResponse.ciudad,
                estado: usuarioResponse.estado,
                token: loginResponse.token
            )
            
            saveToUserDefaults(usuarioId: usuario.usuarioId, token: usuario.token)
            
            // Devolver el usuario
            return usuario
        }
    }
}
    
// Reutilizamos LoginResponse y UsuarioResponse de UsuarioLogIn.swift
@MainActor
class UsuarioUpdate: ObservableObject {
    @Published var usuario: Usuario?
    
    func updateUser(usuarioId: Int, token: String, nombre: String, apellido: String, email: String, ciudad: String?, estado: String?) async throws -> Usuario {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/usuario/\(usuarioId)") else {
            print("URL inválida")
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Agregar el token
        
        let requestBody: [String: Any] = [
            "nombre": nombre,
            "apellido": apellido,
            "email": email,
            "ciudad": ciudad ?? "",
            "estado": estado ?? ""
        ]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            print("Cuerpo de la solicitud:", String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? "Cuerpo vacío")
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }
            
            // Decodificar el usuario actualizado
            let updatedUsuarioResponse = try JSONDecoder().decode(UsuarioResponse.self, from: data)
            let updatedUsuario = Usuario(
                usuarioId: updatedUsuarioResponse.usuarioId,
                nombre: updatedUsuarioResponse.nombre,
                apellido: updatedUsuarioResponse.apellido,
                email: updatedUsuarioResponse.email,
                ciudad: updatedUsuarioResponse.ciudad,
                estado: updatedUsuarioResponse.estado,
                token: token // Mantener el token existente
            )
            
            // Actualizar la propiedad publicada
            self.usuario = updatedUsuario
            
            // Devolver el usuario actualizado
            return updatedUsuario
            
        } catch {
            print("Error al actualizar el usuario: \(error)")
            throw error
        }
    }
}

func saveToUserDefaults(usuarioId: Int, token: String) {
    UserDefaults.standard.set(usuarioId, forKey: "usuarioId")
    UserDefaults.standard.set(token, forKey: "token")
    print("Datos guardados en UserDefaults: usuarioId=\(usuarioId), token=\(token)")
}
