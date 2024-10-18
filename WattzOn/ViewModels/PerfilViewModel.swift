//
//  PerfilViewModel.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//

import Foundation

class PerfilViewModel: ObservableObject {
    @Published var usuario: Usuario
    
    init() {
        usuario = Usuario(nombre: "Emilia Yeray Treviño Medina", correo: "EmiliaYeri@hotmail.com", imagenPerfil: "Miguel")
    }
    
    func cambiarContrasena() {
        print("Cambiar contraseña")
    }
}
