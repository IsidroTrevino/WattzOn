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
        guard let usuario = usuario.first else {
            return AnyView(
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
            )
        }

        return AnyView(
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

                VStack {
                    Image("Miguel")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .padding(8)
                                .background(Circle().fill(Color.white))
                                .offset(x: 30, y: 30)
                                .opacity(isEditing ? 1 : 0)
                        )
                }

                Divider()
                    .background(Color.gray)
                    .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 30) {
                    HStack(spacing: 30) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 60) {
                                VStack(alignment: .leading) {
                                    Text("Nombre")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    if isEditing {
                                        TextField("Nombre", text: $nombre)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(height: 30)
                                    } else {
                                        Text(nombre)
                                            .font(.body)
                                            .foregroundColor(.black)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text("Apellido")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    if isEditing {
                                        TextField("Apellido", text: $apellido)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(height: 30)
                                    } else {
                                        Text(apellido)
                                            .font(.body)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }

                    HStack(spacing: 30) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Correo Electrónico")
                                .font(.headline)
                                .foregroundColor(.gray)
                            if isEditing {
                                TextField("Correo Electrónico", text: $email)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(height: 30)
                            } else {
                                Text(email)
                                    .font(.body)
                                    .foregroundColor(.black)
                            }
                        }
                    }

                    HStack(spacing: 30) {
                        Image(systemName: "location.fill")
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 60) {
                                VStack(alignment: .leading) {
                                    Text("Ciudad")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    if isEditing {
                                        TextField("Ciudad", text: $ciudad)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(height: 30)
                                    } else {
                                        Text(ciudad)
                                            .font(.body)
                                            .foregroundColor(.black)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text("Estado")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    if isEditing {
                                        TextField("Estado", text: $estado)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(height: 30)
                                    } else {
                                        Text(estado)
                                            .font(.body)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                if !isEditing {
                    Button(action: {
                        router.navigate(to: .homeView)
                    }) {
                        Label("Cambia tu contraseña", systemImage: "lock")
                            .padding()
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                            .shadow(radius: 10)
                    }
                    .padding(.top, 20)
                }

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                usuarioUpdateVM.context = context
                loadUserData()
            }
        )
    }
    
    private func handleUpdate() async {
        guard !nombre.isEmpty, !apellido.isEmpty, !email.isEmpty, !ciudad.isEmpty, !estado.isEmpty else {
            errorMessage = "Por favor, completa todos los campos."
            showError = true
            return
        }
        
        showError = false
        
        do {
            try await usuarioUpdateVM.updateUser(
                usuarioId: usuario.first?.usuarioId ?? 0,
                nombre: nombre,
                apellido: apellido,
                email: email,
                ciudad: ciudad,
                estado: estado
            )
            
            if let existingUsuario = usuario.first {
                context.delete(existingUsuario)
            }
            let updatedUsuario = Usuario(
                usuarioId: usuario.first?.usuarioId ?? 0,
                nombre: nombre,
                apellido: apellido,
                email: email,
                ciudad: ciudad,
                estado: estado
            )
            context.insert(updatedUsuario)
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
