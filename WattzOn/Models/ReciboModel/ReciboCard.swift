//
//  ReciboCard.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import SwiftUI

struct ReciboCard: View {
    var recibo: Recibo
    
    var body: some View {
        HStack {
            Image("cfe")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(recibo.titulo)
                    .font(.headline)
                
                Text("Fecha: \(formattedDate(recibo.fechaRegistro))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Lectura Actual: \(recibo.lecturaActual)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Lectura Anterior: \(recibo.lecturaAnterior)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 5)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ReciboCard_Previews: PreviewProvider {
    static var previews: some View {
        ReciboCard(recibo: Recibo(
            fechaRegistro: Date(),
            lecturaActual: 1200,
            lecturaAnterior: 1100,
            totales: [100],
            precios: [1.5],
            totalFinales: [150.0]
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

/*
#Preview {
    ReciboCard()
}
*/
