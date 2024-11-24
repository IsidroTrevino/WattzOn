//
//  Electrodomestico.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

// Electrodomestico.swift

import Foundation

final class Electrodomestico: Identifiable, Codable, Equatable, Hashable {
    var electrodomesticoId: Int?
    var usuarioId: Int
    var nombre: String
    var tipo: String
    var consumowatts: Double
    var descripcion: String?
    var urlimagen: String?
    var marca: String
    var modelo: String
    var fecharegistro: String?

    init(
        electrodomesticoId: Int,
        usuarioId: Int,
        nombre: String,
        tipo: String,
        consumowatts: Double,
        descripcion: String? = nil,
        urlimagen: String? = nil,
        marca: String,
        modelo: String,
        fecharegistro: String? = nil
    ) {
        self.electrodomesticoId = electrodomesticoId
        self.usuarioId = usuarioId
        self.nombre = nombre
        self.tipo = tipo
        self.consumowatts = consumowatts
        self.descripcion = descripcion
        self.urlimagen = urlimagen
        self.marca = marca
        self.modelo = modelo
        self.fecharegistro = fecharegistro
    }

    // Implementación de Equatable
    static func == (lhs: Electrodomestico, rhs: Electrodomestico) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Conformidad al protocolo Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
