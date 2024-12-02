//
//  AuxiliarPerfilView.swift
//  WattzOn
//
//  Created by Isidro Treviño on 01/12/24.
//

extension PerfilView {
    @MainActor
    func updateUsuario() async {
        guard !nombre.isEmpty, !apellido.isEmpty, !email.isEmpty, !ciudad.isEmpty, !estado.isEmpty else {
            errorMessage = "Por favor, completa todos los campos."
            showError = true
            return
        }

        showError = false

        do {
            guard let existingUsuario = usuario.first else {
                print("Usuario no existe")
                return
            }

            let updatedUsuarioResponse = try await updateVM.updateUser(
                usuarioId: existingUsuario.usuario.usuarioId,
                token: existingUsuario.token,
                nombre: nombre,
                apellido: apellido,
                email: email,
                ciudad: ciudad,
                estado: estado
            )

            // Actualizar el usuario en SwiftData
            existingUsuario.usuario.nombre = updatedUsuarioResponse.nombre
            existingUsuario.usuario.apellido = updatedUsuarioResponse.apellido
            existingUsuario.usuario.email = updatedUsuarioResponse.email
            existingUsuario.usuario.ciudad = updatedUsuarioResponse.ciudad
            existingUsuario.usuario.estado = updatedUsuarioResponse.estado

            try context.save()

            loadUserData()
        } catch {
            errorMessage = "Error al actualizar el usuario."
            showError = true
            print("Error al actualizar el usuario:", error)
        }
    }

    
    func loadUserData() {
        guard let user = usuario.first else { return }
        nombre = user.usuario.nombre
        apellido = user.usuario.apellido
        email = user.usuario.email
        ciudad = user.usuario.ciudad ?? ""
        estado = user.usuario.estado ?? ""
    }
    
    func logOut() {
        // Eliminar todos los datos de SwiftData
        do {
            for user in usuario {
                context.delete(user)
            }
            try context.save()
        } catch {
            print("Error al eliminar los datos de SwiftData:", error)
        }

        electrodomesticoViewModel.electrodomesticos = []

        usageViewModel.usages = []
        usageViewModel.saveUsages()
        
        router.navPath = []
        router.navigate(to: .logIn)
    }
}
