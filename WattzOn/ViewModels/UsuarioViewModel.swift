//
//  UsuarioViewModel.swift
//  WattzOn
//
//  Created by Isidro Treviño on 17/10/24.
//

import Foundation
import SwiftData

@MainActor
class UsuarioLogIn: ObservableObject {
    @Published var usuario: Usuario?
    
    var context: ModelContext?

    init(context: ModelContext? = nil) {
        self.context = context
    }
    
    func login(email: String, password: String) async throws {
        guard var urlComponents = URLComponents(string: "http://localhost:3000/api/wattzon/usuario/login") else {
            print("Invalid URL")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password", value: password)
        ]
        
        guard let url = urlComponents.url else {
            print("Invalid URL components")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let usuario = try JSONDecoder().decode(Usuario.self, from: data)
            self.usuario = usuario
            
            try saveUsuarioToSwiftData(usuario: usuario)
            
        } catch {
            print("Failed to fetch user data: \(error)")
            throw error
        }
    }
    
    private func saveUsuarioToSwiftData(usuario: Usuario) throws {
        guard let context = context else {
            print("No SwiftData context available")
            return
        }
        
        let usuario = Usuario(
            usuarioId: usuario.usuarioId,
            nombre: usuario.nombre,
            apellido: usuario.apellido,
            email: usuario.email,
            ciudad: usuario.ciudad,
            estado: usuario.estado
        )
        
        context.insert(usuario)
        
        try context.save()
        print("Usuario guardado en SwiftData.")
    }
}

@MainActor
class UsuarioRegister: ObservableObject {
    @Published var usuario: Usuario?
    
    var context: ModelContext?

    init(context: ModelContext? = nil) {
        self.context = context
    }
    
    func register(nombre: String, apellido: String, email: String, password: String, ciudad: String, estado: String) async throws {
        guard let url = URL(string: "http://localhost:3000/api/wattzon/usuario/register") else {
            print("Invalid URL")
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
            "ciudad": ciudad,
            "estado": estado
        ]
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let usuario = try JSONDecoder().decode(Usuario.self, from: data)
            self.usuario = usuario
            
            try saveUsuarioToSwiftData(usuario: usuario)
            
        } catch {
            print("Failed to register user: \(error)")
            throw error
        }
    }
    
    private func saveUsuarioToSwiftData(usuario: Usuario) throws {
        guard let context = context else {
            print("No SwiftData context available")
            return
        }
        
        let usuario = Usuario(
            usuarioId: usuario.usuarioId,
            nombre: usuario.nombre,
            apellido: usuario.apellido,
            email: usuario.email,
            ciudad: usuario.ciudad,
            estado: usuario.estado
        )
        
        context.insert(usuario)
        
        try context.save()
        print("Usuario guardado en SwiftData.")
    }
}
