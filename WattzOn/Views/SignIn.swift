//
//  SignIn.swift
//  WattzOn
//
//  Created by Isidro Treviño on 17/10/24.
//

import SwiftUI
import SwiftData

struct SignIn: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var router: Router
    @StateObject private var registerVM: UsuarioRegister = {
        do {
            let container = try ModelContainer(for: Usuario.self)
            return UsuarioRegister(context: container.mainContext)
        } catch {
            fatalError("Error al crear el ModelContainer: \(error)")
        }
    }()
    
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var apellido = ""
    @State private var ciudad = ""
    @State private var estado = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showErrorMessage = false
    @State private var errorMessage = ""
    @Binding var isLoggedIn: Bool 

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("WattzOn")
                        .font(.system(size: 70))
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 50)
                    
                    Text("Registrarse")
                        .font(.system(size: 32, weight: .bold))
                        .padding(.bottom, 20)
                    
                    if showErrorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        TextField("Nombre", text: $name)
                            .keyboardType(.default)
                            .autocapitalization(.words)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5, x: 0, y: 2)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.gray)
                        TextField("Apellido", text: $apellido)
                            .keyboardType(.default)
                            .autocapitalization(.words)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5, x: 0, y: 2)
                    
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.gray)
                        TextField("Ciudad", text: $ciudad)
                            .keyboardType(.default)
                            .autocapitalization(.words)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5, x: 0, y: 2)
                    
                    HStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.gray)
                        TextField("Estado", text: $estado)
                            .keyboardType(.default)
                            .autocapitalization(.words)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5, x: 0, y: 2)
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Correo", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5, x: 0, y: 2)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if showPassword {
                            TextField("Contraseña", text: $password)
                        } else {
                            SecureField("Contraseña", text: $password)
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5, x: 0, y: 2)
                    
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if showPassword {
                            TextField("Confirmar contraseña", text: $confirmPassword)
                        } else {
                            SecureField("Confirmar contraseña", text: $confirmPassword)
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                    .shadow(radius: 5, x: 0, y: 2)
                    
                    Button(action: {
                        Task {
                            await registerUser()
                        }
                    }) {
                        Text("Registrarse")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .padding(.vertical, 20)
                    
                    HStack {
                        Text("¿Ya tienes una cuenta?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            router.goBack()
                        }) {
                            Text("Ingresa aquí.")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .onAppear {
                registerVM.context = context
            }
        }
    }

    private func registerUser() async {
        guard !name.isEmpty, !apellido.isEmpty, !ciudad.isEmpty, !estado.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor, llena todos los campos."
            showErrorMessage = true
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden."
            showErrorMessage = true
            return
        }

        do {
            try await registerVM.register(nombre: name, apellido: apellido, email: email, password: password, ciudad: ciudad, estado: estado)
            showErrorMessage = false
            isLoggedIn = true
        } catch {
            showErrorMessage = true
            errorMessage = "Hubo un error en el registro."
        }
    }
}

