//
//  Models.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//


import Foundation
import SwiftData

@Model
class Usuario: Identifiable, Decodable {
    var usuarioId: Int
    var nombre: String
    var apellido: String
    var email: String
    var ciudad: String?
    var estado: String?

    init(usuarioId: Int, nombre: String, apellido: String, email: String, ciudad: String?, estado: String?) {
        self.usuarioId = usuarioId
        self.nombre = nombre
        self.apellido = apellido
        self.email = email
        self.ciudad = ciudad
        self.estado = estado
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let usuarioId = try container.decode(Int.self, forKey: .usuarioId)
        let nombre = try container.decode(String.self, forKey: .nombre)
        let apellido = try container.decode(String.self, forKey: .apellido)
        let email = try container.decode(String.self, forKey: .email)
        let ciudad = try container.decodeIfPresent(String.self, forKey: .ciudad)
        let estado = try container.decodeIfPresent(String.self, forKey: .estado)
        
        self.init(usuarioId: usuarioId, nombre: nombre, apellido: apellido, email: email, ciudad: ciudad, estado: estado)
    }
    
    private enum CodingKeys: String, CodingKey {
        case usuarioId, nombre, apellido, email, ciudad, estado
    }
}


struct ConsumoEnergetico {
    var ahorro: Double
    var consumo: Double
}
