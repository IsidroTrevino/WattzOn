import Foundation

let ipAddress = "10.22.135.186:3000"

@MainActor
class UsuarioLogIn: ObservableObject {
    @Published var usuario: Usuario?

    func login(email: String, password: String) async throws {
        // Construir la URL con parámetros de consulta para email y password
        guard let url = URL(string: "http://\(ipAddress)/api/wattzon/usuario/login?email=\(email)&password=\(password)") else {
            print("URL inválida")
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"  // Cambiar el método a GET

        do {
            // Realizar la solicitud
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            // Imprimir el código de estado de la respuesta para verificación
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            // Verificar que el código de estado sea 200 OK
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }

            // Imprimir los datos de respuesta para depuración
            print("Datos de respuesta:", String(data: data, encoding: .utf8) ?? "Respuesta vacía")

            // Decodificar la respuesta en el modelo Usuario
            let usuario = try JSONDecoder().decode(Usuario.self, from: data)
            self.usuario = usuario

        } catch {
            print("Error al obtener datos del usuario: \(error)")
            throw error
        }
    }
}

@MainActor
class UsuarioRegister: ObservableObject {
    @Published var usuario: Usuario?

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

        } catch {
            print("Error al registrar usuario: \(error)")
            throw error
        }
    }
}
