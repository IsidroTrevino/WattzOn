//
//  DomesticCard.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import SwiftUI

struct DomesticCard: View {
    var electrodomestico: Electrodomestico

    var body: some View {
        HStack {
            if let imagePath = electrodomestico.urlimagen,
               let uiImage = UIImage(contentsOfFile: imagePath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(electrodomestico.nombre)
                    .font(.headline)
                Text(electrodomestico.marca)
                    .font(.subheadline)
                Text("Potencia: \(electrodomestico.consumowatts).00 W")
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct DomesticCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DomesticCard(electrodomestico: Electrodomestico(
                electrodomesticoId: 1,
                nombre: "Refrigerador",
                tipo: "Electrodoméstico",
                consumowatts: 150,
                descripcion: "Refrigerador de gran capacidad",
                urlimagen: "cfe",
                marca: "LG",
                modelo: "GR-349SQF"
            ))
            .previewLayout(.sizeThatFits)
            .padding()

            DomesticCard(electrodomestico: Electrodomestico(
                electrodomesticoId: 2,
                nombre: "Microondas",
                tipo: "Pequeño Electrodoméstico",
                consumowatts: 700,
                descripcion: "Microondas compacto",
                urlimagen: "cfe",
                marca: "Marca",
                modelo: "Modelo"
            ))
            .previewLayout(.sizeThatFits)
            .padding()
        }

    }
}
