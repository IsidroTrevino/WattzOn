//
//  Recibo.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import Foundation
import SwiftData

@Model
final class Recibo: Identifiable {
    @Attribute(.unique) var id: UUID
    var fechaRegistro: Date
    var lecturaActual: Int
    var lecturaAnterior: Int
    var totales: [Int]
    var precios: [Double]
    var totalFinales: [Double]
    
    init(id: UUID = UUID(), fechaRegistro: Date, lecturaActual: Int, lecturaAnterior: Int, totales: [Int], precios: [Double], totalFinales: [Double]) {
        self.id = id
        self.fechaRegistro = fechaRegistro
        self.lecturaActual = lecturaActual
        self.lecturaAnterior = lecturaAnterior
        self.totales = totales
        self.precios = precios
        self.totalFinales = totalFinales
    }
    
    var titulo: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "LLLL yyyy" 
        let formattedDate = dateFormatter.string(from: fechaRegistro).capitalized
        return "Recibo \(formattedDate)"
    }
}
