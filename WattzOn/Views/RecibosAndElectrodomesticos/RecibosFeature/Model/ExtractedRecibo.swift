//
//  ExtractedRecibo.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

import Foundation

struct ExtractedReceiptData: Equatable, Hashable {
    var lecturaActual: Int
    var lecturaAnterior: Int
    var subtotal: Double
    var conceptos: [Concepto]
    
    /*
    // Implementación de Equatable
    static func == (lhs: ExtractedReceiptData, rhs: ExtractedReceiptData) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Conformidad al protocolo Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
     */
}
