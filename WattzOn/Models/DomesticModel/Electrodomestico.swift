//
//  Electrodomestico.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import Foundation
import SwiftData

/// !!!!!!!!!!!!!!!!!!!!!!!!! AGREGAR MIGRATION !!!!!!!!!!!!!!!!!!!!!!!!!!!!

@Model 
final class Electrodomestico: Identifiable {
    @Attribute(.unique) var id: UUID
    var nombre: String
    var marca: String
    var tipo: String
    var modelo: String
    var potenciaWatts: Double
    var imagePath: String?

    init(id: UUID = UUID(), nombre: String, marca: String, tipo: String, modelo: String, potenciaWatts: Double, imagePath: String? = nil) {
        self.id = id
        self.nombre = nombre
        self.marca = marca
        self.tipo = tipo
        self.modelo = modelo
        self.potenciaWatts = potenciaWatts
        self.imagePath = imagePath
    }
}

