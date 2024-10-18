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
            if let imagePath = electrodomestico.imagePath,
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
                Text("Potencia: \(String(format: "%.2f", electrodomestico.potenciaWatts)) W")
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
                nombre: "Refrigerador",
                marca: "LG",
                tipo: "Electrodoméstico",
                modelo: "GR-349SQF",
                potenciaWatts: 150.0,
                imagePath: nil
            ))
            .previewLayout(.sizeThatFits)
            .padding()

            DomesticCard(electrodomestico: Electrodomestico(
                nombre: "Microondas",
                marca: "Marca",
                tipo: "Tipo",
                modelo: "Modelo",
                potenciaWatts: 700.0,
                imagePath: nil
            ))
            .previewLayout(.sizeThatFits)
            .padding()
        }
    }
}
