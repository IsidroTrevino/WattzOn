//
//  PerfilView.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//

import SwiftUI
import SwiftData

struct PerfilView: View {
    @State var updateVM = UsuarioUpdate()
    @State var isEditing: Bool = false
    @State var isQuitting: Bool = false
    @Query var usuario: [UsuarioResponse]
    
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) var context
    @EnvironmentObject var electrodomesticoViewModel: ElectrodomesticoViewModel
    @EnvironmentObject var usageViewModel: ElectrodomesticoUsageViewModel
    
    @State var nombre: String = ""
    @State var apellido: String = ""
    @State var email: String = ""
    @State var ciudad: String = ""
    @State var estado: String = ""
    @State var showError = false
    @State var errorMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Edita tu perfil")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                
                Image("Miguel")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .padding(8)
                            .background(Circle().fill(Color.white))
                            .offset(x: 40, y: 40)
                    )
                
                Divider()
                    .frame(width: 250)
                    .background(Color.gray)
                
                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre")
                            .font(.headline)
                            .foregroundColor(.gray)
                        if isEditing {
                            TextField("Nombre", text: $nombre)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(nombre)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Apellido")
                            .font(.headline)
                            .foregroundColor(.gray)
                        if isEditing {
                            TextField("Apellido", text: $apellido)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(apellido)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 60)
                .padding(.top, 20)
                
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Correo Electrónico")
                            .font(.headline)
                            .foregroundColor(.gray)
                        if isEditing {
                            TextField("Correo Electrónico", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(email)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 60)
                
                HStack(spacing: 12) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ciudad")
                            .font(.headline)
                            .foregroundColor(.gray)
                        if isEditing {
                            TextField("Ciudad", text: $ciudad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(ciudad)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Estado")
                            .font(.headline)
                            .foregroundColor(.gray)
                        if isEditing {
                            TextField("Estado", text: $estado)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        } else {
                            Text(estado)
                                .font(.body)
                                .foregroundColor(.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 60)
                
                if !isEditing {
                    Button(action: {
                        // Acción para cambiar contraseña
                    }) {
                        Label("Cambia tu contraseña", systemImage: "lock")
                            .padding()
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .top)
            .toolbar {
                if isEditing {
                    ToolbarItem {
                        Button("Cancelar") {
                            isEditing = false
                            loadUserData()
                        }
                    }
                    ToolbarItem {
                        Button("Guardar") {
                            Task {
                                await updateUsuario()
                                isEditing = false
                                loadUserData()
                            }
                        }
                    }
                } else {
                    ToolbarItem {
                        Button(action: {
                            isEditing = true
                            loadUserData()
                        }) {
                            Image(systemName: "pencil")
                                .foregroundStyle(.primary)
                                .bold()
                        }
                    }
                    ToolbarItem {
                        Button(action: {
                            logOut()
                        }) {
                            Image(systemName: "iphone.and.arrow.right.outward")
                                .foregroundStyle(.red)
                                .bold()
                        }
                    }
                }
            }
            .onAppear {
                loadUserData()
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
