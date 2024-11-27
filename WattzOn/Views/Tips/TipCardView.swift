//
//  TipCardView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 25/11/24.
//

import SwiftUI

struct TipCardView: View {
    let tip: TipsModel
    
    var body: some View {
        HStack {
            // Placeholder for an image
            Image(systemName: "lightbulb.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(tip.color)
                .padding()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(tip.tipName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(tip.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }
}
