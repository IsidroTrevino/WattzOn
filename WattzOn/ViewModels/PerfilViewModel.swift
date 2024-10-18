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
        usuario = Usuario(
            usuarioId: 1,
            nombre: "Emilia Yeray",
            apellido: "Treviño Medina",
            email: "EmiliaYeri@hotmail.com",
            ciudad: "Monterrey",
            estado: "Nuevo León"
        )
    }
    
    func cambiarContrasena() {
        print("Cambiar contraseña")
    }
}
