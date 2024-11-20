import Foundation
import SwiftData

let ipAddress = "wattzonapi.onrender.com"

@MainActor
class UsuarioLogIn: ObservableObject {
    @Published var usuario: Usuario?
    var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func login(email: String, password: String) async throws {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/usuario/login?email=\(email)&password=\(password)") else {
            print("URL inválida")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }

            let usuario = try JSONDecoder().decode(Usuario.self, from: data)
            self.usuario = usuario

            // Save to SwiftData
            context.insert(usuario)
            try context.save()
            print("Usuario guardado en SwiftData.")

        } catch {
            print("Error al obtener datos del usuario: \(error)")
            throw error
        }
    }
}

@MainActor
class UsuarioRegister: ObservableObject {
    @Published var usuario: Usuario?
    var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func register(nombre: String, apellido: String, email: String, password: String, ciudad: String?, estado: String?) async throws {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/usuario/register") else {
            print("URL inválida")
            return
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

            let usuario = try JSONDecoder().decode(Usuario.self, from: data)
            self.usuario = usuario

            // Save to SwiftData
            context.insert(usuario)
            try context.save()
            print("Usuario guardado en SwiftData.")

        } catch {
            print("Error al registrar usuario: \(error)")
            throw error
        }
    }
}

@MainActor
class UsuarioUpdate: ObservableObject {
    @Published var usuario: Usuario?
    var context: ModelContext?

    init(context: ModelContext? = nil) {
        self.context = context
    }

    func updateUser(usuarioId: Int, nombre: String, apellido: String, email: String, ciudad: String?, estado: String?) async throws {
        guard let url = URL(string: "https://\(ipAddress)/api/wattzon/usuario/\(usuarioId)") else {
            print("URL inválida")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

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

            let updatedUsuario = try JSONDecoder().decode(Usuario.self, from: data)
            self.usuario = updatedUsuario

            // Actualizar en SwiftData
            if let context = context, let usuario = self.usuario {
                usuario.nombre = updatedUsuario.nombre
                usuario.apellido = updatedUsuario.apellido
                usuario.email = updatedUsuario.email
                usuario.ciudad = updatedUsuario.ciudad
                usuario.estado = updatedUsuario.estado

                try context.save()
                print("Usuario actualizado en SwiftData.")
            } else {
                print("Error: Contexto no asignado o usuario no encontrado.")
            }

        } catch {
            print("Error al actualizar el usuario: \(error)")
            throw error
        }
    }
}
