//
//  PerfilView.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//

import SwiftUI

struct PerfilView: View {
    @StateObject private var viewModel = PerfilViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
           
            
            VStack(spacing: 20) {
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
            }
            
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
                    Text(viewModel.userr.nombre)
                        .font(.body)
                        .foregroundColor(.black)
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
                    Text(viewModel.userr.email)
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 60)
            
            Button(action: {
                viewModel.cambiarContrasena()
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
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    PerfilView()
}
