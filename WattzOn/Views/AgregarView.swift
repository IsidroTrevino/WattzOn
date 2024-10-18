//
//  AgregarView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import SwiftUI

struct AgregarView: View {
    @EnvironmentObject var router: Router

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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 4), (int >> 4) & 0xF, int & 0xF)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
