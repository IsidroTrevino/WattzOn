//
//  TipDetailView.swift
//  WattzOn
//
//  Created by Debanhi Medina on 18/10/24.
//

import SwiftUI

struct TipDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let tip : TipsModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(tip.tipName)
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundStyle(.wattz)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom)
            
            Text(tip.description)
                .font(.system(size: 20))
                .padding(.horizontal, 30)
                .padding(.bottom)
                
            ScrollView {
                Text("Estrategia 1: \(tip.estrategia1)")
                    .italic()
                    .padding(.horizontal, 30)
                
                Text(tip.textEs1)
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                
                Text("Estrategia 2: \(tip.estrategia2)")
                    .italic()
                    .padding(.horizontal, 30)
                
                Text(tip.textEs2)
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                
                Text("Estrategia 3: \(tip.estrategia3)")
                    .italic()
                    .padding(.horizontal, 30)
                
                Text(tip.textEs3)
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                
                Text("Estrategia 4: \(tip.estrategia4)")
                    .italic()
                    .padding(.horizontal, 30)
                
                Text(tip.textEs4)
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                
                Text("Estrategia 5: \(tip.estrategia5)")
                    .italic()
                    .padding(.horizontal, 30)
                
                Text(tip.textEs5)
                    .padding(.horizontal, 30)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundStyle(Color.wattz)
                Text("Tips")
                    .foregroundStyle(Color.wattz)
            }
        })
    }
}

#Preview {
    TipDetailView(tip: TipsModel.defaultTip)
}
