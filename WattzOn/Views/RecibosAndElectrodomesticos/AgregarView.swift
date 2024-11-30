//
//  AgregarView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import SwiftUI

struct AgregarView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 30) {
            Text("Agrega tu Recibo de Luz \no Electrodomésticos")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.top, 30)

            VStack(spacing: 20) {
                Button(action: {
                    router.navigate(to: .recibosListView)
                }) {
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color(hex: "#FFA800"))
                        
                        Text("Agregar Recibo")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(15)
                    .shadow(radius: 2)
                }
                .padding(.horizontal, 20)

                Button(action: {
                    router.navigate(to: .domesticoView)
                }) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .font(.largeTitle)
                            .foregroundColor(Color(hex: "#FFA800"))
                        Text("Agregar Electrodoméstico")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(15)
                    .shadow(radius: 2)
                }
                .padding(.horizontal, 20)
            }
            
            // Vista de Bombilla
            LightbulbView(consumption: viewModel.consumoEnergetico.consumo / 1000)
                .frame(width: 100, height: 200)
                .padding(.top, 20)
            
            Spacer()
        }
        .padding(.bottom, 30)
        .navigationBarTitle("Agregar", displayMode: .inline)
    }
}

#Preview {
    AgregarView()
        .environmentObject(Router())
}

