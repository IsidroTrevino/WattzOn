//
//  LogIn.swift
//  WattzOn
//
//  Created by Isidro Treviño on 17/10/24.
//

import SwiftUI

struct LogIn: View {
    @StateObject private var LogIn = UsuarioLogIn()
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showErrorMessage = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("WattzOn")
                        .font(.system(size: 70))
                        .fontWeight(.bold)
                        .foregroundStyle(.wattz)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, -120)
                        .padding(.bottom, 50)
                    
                    Text("Ingresar")
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

                    Button(action: {
                    }) {
                        Text("¿Olvidaste tu contraseña?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }

                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        Text("Ingresar")
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
                        Text("¿No tienes una cuenta?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: SignIn()) {
                            Text("Registrate aquí.")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    private func login() async {
        do {
            try await LogIn.login(email: email, password: password)
            showErrorMessage = false
            isLoggedIn = true
        } catch {
            showErrorMessage = true
            errorMessage = "Correo o contraseña incorrectos."
        }
    }
}

#Preview {
    LogIn()
}
