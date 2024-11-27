//
//  ElectrodomesticoReadingsInfo.swift
//  WattzOn
//
//  Created by Fernando Espidio on [Fecha].
//

import SwiftUI

struct ElectrodomesticoReadingsInfo: View {
    @EnvironmentObject var router: Router
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image("potencia_watts")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding()

                Text(ElectrodomesticoNotes.potenciaWatts.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text(ElectrodomesticoNotes.potenciaWatts.explanation)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Potencia en Watts")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: BackButton {
                    router.goBack()
                })
        .navigationBarBackButtonHidden()
    }
}

/*
#Preview {
    let router = Router()
    return NavigationStack {
        ElectrodomesticoReadingsInfo()
            .environmentObject(router)
            .modelContainer(for: [Electrodomestico.self, Recibo.self, Usuario.self])
    }
}
*/
