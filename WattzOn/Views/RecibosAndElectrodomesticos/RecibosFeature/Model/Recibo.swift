//
//  Recibo.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

// Recibo.swift

import Foundation

// Modelo para Concepto
class Concepto: Codable, Identifiable, Equatable, Hashable {
    var idConcepto: Int?
    var idRecibo: Int?
    var idCategoriaConcepto: Int? // Para enviar al crear/actualizar
    var TotalPeriodo: Int
    var Precio: Double
    
    init(idConcepto: Int? = nil, idRecibo: Int? = nil, idCategoriaConcepto: Int? = nil, TotalPeriodo: Int, Precio: Double) {
        self.idConcepto = idConcepto
        self.idRecibo = idRecibo
        self.idCategoriaConcepto = idCategoriaConcepto
        self.TotalPeriodo = TotalPeriodo
        self.Precio = Precio
    }
    
    // Implementación de Equatable
    static func == (lhs: Concepto, rhs: Concepto) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Conformidad al protocolo Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var description: String {
        """
        Concepto(idConcepto: \(idConcepto ?? 0), 
                 idRecibo: \(idRecibo ?? 0), 
                 idCategoriaConcepto: \(idCategoriaConcepto ?? 0), 
                 TotalPeriodo: \(TotalPeriodo), 
                 Precio: \(Precio))
        """
    }
}

// Modelo para Recibo
class Recibo: Codable, Identifiable, Equatable, Hashable {
    var idRecibo: Int?
    var usuarioId: Int
    var LecturaActual: Int
    var LecturaAnterior: Int
    var InicioPeriodo: Date
    var FinPeriodo: Date
    var Subtotal: Double
    var conceptos: [Concepto]

    init(
        idRecibo: Int? = nil,
        usuarioId: Int,
        LecturaActual: Int,
        LecturaAnterior: Int,
        InicioPeriodo: Date,
        FinPeriodo: Date,
        Subtotal: Double,
        conceptos: [Concepto]
    ) {
        self.idRecibo = idRecibo
        self.usuarioId = usuarioId
        self.LecturaActual = LecturaActual
        self.LecturaAnterior = LecturaAnterior
        self.InicioPeriodo = InicioPeriodo
        self.FinPeriodo = FinPeriodo
        self.Subtotal = Subtotal
        self.conceptos = conceptos
    }
    
    var titulo: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "LLLL yyyy"
        let formattedDate = dateFormatter.string(from: InicioPeriodo).capitalized
        return "Recibo \(formattedDate)"
    }
    
    static func == (lhs: Recibo, rhs: Recibo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
