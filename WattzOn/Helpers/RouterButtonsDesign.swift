//
//  RouterButtonsDesign.swift
//  WattzOn
//
//  Created by Fernando Espidio on 07/11/24.
//

import Foundation
import SwiftUI

struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left") // Usamos un ícono apropiado para la barra de navegación
                .foregroundColor(Color(hex: "#FFA800"))
        }
    }
}


struct SaveButton: View {
    var title: String = "Guardar"
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(hex: "#FFA800"))
                .cornerRadius(25)
        }
    }
}

struct CustomEditButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Editar")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(hex: "#FFA800"))
                .cornerRadius(25)
        }
    }
}
