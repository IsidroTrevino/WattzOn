//
//  IsidroTests.swift
//  IsidroTests
//
//  Created by Isidro Treviño on 01/12/24.
//

import Testing
import Foundation
@testable import WattzOn

class UsuarioLogIn {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func login(email: String, password: String) async throws -> UsuarioResponse {
        guard let url = URL(string: "https://wattzonapi.onrender.com/api/wattzon/usuario/login") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 200 {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let usuarioResponse = try decoder.decode(UsuarioResponse.self, from: data)
            return usuarioResponse
        } else {
            let errorResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            let message = errorResponse?["message"] ?? "Error desconocido."
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }
}


class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler no está configurado.")
        }
        
        do {
            // Obtener la respuesta simulada y los datos
            let (response, data) = try handler(request)
            
            // Enviar la respuesta al cliente
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            // Enviar los datos al cliente
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            // Indicar que la carga ha finalizado
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // Enviar el error al cliente
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

}


class TestBase {
    static func makeMockSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
}

struct IsidroTests {
    
    @Test func testLoginSuccess() async throws {
        // Configurar la sesión mockeada
        let mockSession = TestBase.makeMockSession()
        let logInVM = UsuarioLogIn(session: mockSession)
        
        // Datos de prueba
        let testEmail = "isidro@gmail.com"
        let testPassword = "12345"
        
        // Crear una cadena JSON simulada para la respuesta exitosa
        let responseJSON = """
        {
            "token": "mocked_token_123456",
            "usuario": {
                "usuarioId": 1,
                "nombre": "Isidro",
                "apellido": "Trevino",
                "email": "\(testEmail)",
                "ciudad": "Monterrey",
                "estado": "Nuevo Leon",
                "fecharegistro": "2023-12-01T00:00:00Z"
            }
        }
        """
        let responseData = responseJSON.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url.absoluteString.contains("/api/wattzon/usuario/login") else {
                throw NSError(domain: "URL inválida", code: 400, userInfo: nil)
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response, responseData)
        }
        
        do {
            let usuarioResponse = try await logInVM.login(email: testEmail, password: testPassword)
            
            print("usuarioResponse:", usuarioResponse)
            print("usuarioResponse.usuario:", usuarioResponse.usuario)
            print("usuarioResponse.usuario.nombre:", usuarioResponse.usuario.nombre)
            print("usuarioResponse.usuario.email:", usuarioResponse.usuario.email)
            
            #expect(usuarioResponse.usuario.nombre == "Isidro")
            #expect(usuarioResponse.usuario.email == testEmail)
        } catch {
            print("Error en login:", error)
        }
    }
    
    @Test func testLoginFailure() async throws {
        let mockSession = TestBase.makeMockSession()
        let logInVM = UsuarioLogIn(session: mockSession)
        
        let testEmail = "invalid@example.com"
        let testPassword = "wrongpassword"
        
        let errorResponseJSON = """
        {
            "message": "Correo o contraseña incorrectos."
        }
        """
        let responseData = errorResponseJSON.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            
            return (response, responseData)
        }
        
        do {
            _ = try await logInVM.login(email: testEmail, password: testPassword)
            #expect(false, "La función de login debería lanzar un error para credenciales inválidas.")
        } catch {
            // Verificar que el error sea el esperado
            let expectedErrorMessage = "Correo o contraseña incorrectos."
            #expect(error.localizedDescription == expectedErrorMessage)
        }
    }
}
