//
//  Electrodomestico.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import Foundation
import SwiftData

@Model
final class Electrodomestico: Identifiable, Decodable {
    @Attribute(.unique) var electrodomesticoId: Int
    var nombre: String
    var tipo: String
    var consumowatts: Int
    var descripcion: String
    var urlimagen: String?
    var marca: String
    var modelo: String

    init(electrodomesticoId: Int, nombre: String, tipo: String, consumowatts: Int, descripcion: String, urlimagen: String?, marca: String, modelo: String) {
        self.electrodomesticoId = electrodomesticoId
        self.nombre = nombre
        self.tipo = tipo
        self.consumowatts = consumowatts
        self.descripcion = descripcion
        self.urlimagen = urlimagen
        self.marca = marca
        self.modelo = modelo
    }

    // MARK: - Decodable conformance
    enum CodingKeys: String, CodingKey {
        case electrodomesticoId
        case nombre
        case tipo
        case consumowatts
        case descripcion
        case urlimagen
        case marca
        case modelo
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let electrodomesticoId = try container.decode(Int.self, forKey: .electrodomesticoId)
        let nombre = try container.decode(String.self, forKey: .nombre)
        let tipo = try container.decode(String.self, forKey: .tipo)
        let consumowatts = try container.decode(Int.self, forKey: .consumowatts)
        let descripcion = try container.decode(String.self, forKey: .descripcion)
        let urlimagen = try container.decodeIfPresent(String.self, forKey: .urlimagen)
        let marca = try container.decode(String.self, forKey: .marca)
        let modelo = try container.decode(String.self, forKey: .modelo)

        self.init(electrodomesticoId: electrodomesticoId, nombre: nombre, tipo: tipo, consumowatts: consumowatts, descripcion: descripcion, urlimagen: urlimagen, marca: marca, modelo: modelo)
    }
}

