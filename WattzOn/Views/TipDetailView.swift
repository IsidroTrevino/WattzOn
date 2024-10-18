//
//  TipDetailView.swift
//  WattzOn
//
//  Created by Debanhi Medina on 18/10/24.
//

import SwiftUI

struct TipDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("¿Por qué WattzOn?")
                .font(.system(size: 60))
                .fontWeight(.bold)
                .foregroundStyle(.wattz)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, -120)
                .padding(.bottom, 50)
            

            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
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
        .navigationTitle("Tips")
    }
}

#Preview {
    TipDetailView()
}
