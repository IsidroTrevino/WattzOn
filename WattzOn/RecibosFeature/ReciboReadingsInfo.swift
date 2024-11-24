//
//  ReciboReadingsInfo.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

import SwiftUI

enum ReciboField {
    case inicioPeriodo
    case finPeriodo
    case lecturaAnterior
    case lecturaActual
    case subtotal
}

struct ReciboReadingsInfo: View {
    let field: ReciboField
    @EnvironmentObject var router: Router
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Imagen correspondiente al campo
                Image(getImageName(for: field))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding()
                
                // Título del campo
                Text(getNote(for: field).title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // Explicación del campo
                Text(getNote(for: field).explanation)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle(getFieldTitle(for: field))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton {
            router.goBack()
        })
        .navigationBarBackButtonHidden()
    }
    
    // Obtener la imagen correspondiente al campo
    private func getImageName(for field: ReciboField) -> String {
        switch field {
        case .inicioPeriodo:
            return "campoFechaInicio" // Reemplaza con el nombre real de la imagen
        case .finPeriodo:
            return "campoFechaFin"
        case .lecturaAnterior:
            return "campoLecturaAnterior"
        case .lecturaActual:
            return "campoLecturaActual"
        case .subtotal:
            return "campoSubtotal"
        }
    }
    
    // Obtener el título y la explicación del campo
    private func getNote(for field: ReciboField) -> ReadingsNotes.Note {
        switch field {
        case .inicioPeriodo:
            return ReadingsNotes.fechaRegistro
        case .finPeriodo:
            return ReadingsNotes.fechaRegistro
        case .lecturaAnterior:
            return ReadingsNotes.lecturaAnterior
        case .lecturaActual:
            return ReadingsNotes.lecturaActual
        case .subtotal:
            return ReadingsNotes.totales
        }
    }
    
    // Obtener el título de navegación
    private func getFieldTitle(for field: ReciboField) -> String {
        switch field {
        case .inicioPeriodo:
            return "Inicio del Periodo"
        case .finPeriodo:
            return "Fin del Periodo"
        case .lecturaAnterior:
            return "Lectura Anterior"
        case .lecturaActual:
            return "Lectura Actual"
        case .subtotal:
            return "Subtotal"
        }
    }
}
