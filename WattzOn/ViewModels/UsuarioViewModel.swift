import Foundation
import SwiftData

let ipAddress = "10.22.217.194"

@MainActor
class UsuarioLogIn: ObservableObject {
    @Published var usuario: Usuario?
    var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func login(email: String, password: String) async throws {
        guard let url = URL(string: "http://\(ipAddress)/api/wattzon/usuario/login") else {
            print("URL inválida")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "email": email,
            "password": password
        ]

        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            // Decodificar directamente a Usuario
            let usuario = try JSONDecoder().decode(Usuario.self, from: data)
            self.usuario = usuario

            // Guardar el usuario en SwiftData
            try saveUsuarioToSwiftData(usuario: usuario)

        } catch {
            print("Error al obtener datos del usuario: \(error)")
            throw error
        }
    }

    private func saveUsuarioToSwiftData(usuario: Usuario) throws {
        context.insert(usuario)
        try context.save()
        print("Usuario guardado en SwiftData.")
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
        guard let url = URL(string: "http://\(ipAddress)/api/wattzon/usuario/register") else {
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

            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            // Decodificar directamente a Usuario
            let usuario = try JSONDecoder().decode(Usuario.self, from: data)
            self.usuario = usuario

            try saveUsuarioToSwiftData(usuario: usuario)

        } catch {
            print("Error al registrar usuario: \(error)")
            throw error
        }
    }

    private func saveUsuarioToSwiftData(usuario: Usuario) throws {
        context.insert(usuario)
        try context.save()
        print("Usuario guardado en SwiftData.")
    }
}
