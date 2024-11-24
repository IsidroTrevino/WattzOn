//
//  PerfilView.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//

import SwiftUI
import SwiftData

struct PerfilView: View {
    @Query var usuario: [Usuario]
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var context
    @StateObject private var usuarioUpdateVM = UsuarioUpdate()
    
    @State private var isEditing = false
    @State private var nombre = ""
    @State private var apellido = ""
    @State private var email = ""
    @State private var ciudad = ""
    @State private var estado = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        if usuario.first != nil {
            VStack(spacing: 25) {
                // Encabezado con título, botón de edición y botón de log out
                HStack {
                    Text("Perfil")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        if isEditing {
                            Task {
                                await handleUpdate()
                            }
                        }
                        isEditing.toggle()
                    }) {
                        Image(systemName: isEditing ? "checkmark" : "pencil")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: logOut) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding(.leading, 15)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // ... Resto de tu interfaz de usuario ...

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                loadUserData()
            }
        } else {
            VStack {
                Text("Error")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                Text("No se encontró el usuario.")
                    .foregroundColor(.red)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
    
    private func handleUpdate() async {
        guard !nombre.isEmpty, !apellido.isEmpty, !email.isEmpty, !ciudad.isEmpty, !estado.isEmpty else {
            errorMessage = "Por favor, completa todos los campos."
            showError = true
            return
        }
        
        showError = false
        
        do {
            guard let existingUsuario = usuario.first else {
                errorMessage = "Usuario no encontrado."
                showError = true
                return
            }

            let updatedUsuario = try await usuarioUpdateVM.updateUser(
                usuarioId: existingUsuario.usuarioId,
                token: existingUsuario.token,
                nombre: nombre,
                apellido: apellido,
                email: email,
                ciudad: ciudad,
                estado: estado
            )
            
            // Actualizar el usuario en SwiftData
            existingUsuario.nombre = updatedUsuario.nombre
            existingUsuario.apellido = updatedUsuario.apellido
            existingUsuario.email = updatedUsuario.email
            existingUsuario.ciudad = updatedUsuario.ciudad
            existingUsuario.estado = updatedUsuario.estado
            
            try context.save()
            
            loadUserData()
        } catch {
            errorMessage = "Error al actualizar el usuario."
            showError = true
            print("Error al actualizar el usuario:", error)
        }
    }
    
    private func loadUserData() {
        guard let usuario = usuario.first else { return }
        nombre = usuario.nombre
        apellido = usuario.apellido
        email = usuario.email
        ciudad = usuario.ciudad ?? ""
        estado = usuario.estado ?? ""
    }
    
    private func logOut() {
        do {
            if let existingUsuario = usuario.first {
                context.delete(existingUsuario)
                try context.save()
            }
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            router.navigate(to: .logIn)
        } catch {
            print("Error al eliminar el usuario:", error)
        }
    }
}
