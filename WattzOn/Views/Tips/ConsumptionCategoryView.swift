//
//  ConsumptionCategoryView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 25/11/24.
//

import SwiftUI

struct ConsumptionCategoryView: View {
    let category: ConsumptionCategory
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .font(.title)
                .foregroundColor(category.color)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(category.name)
                    .font(.headline)
                ProgressView(value: category.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: category.color))
            }
            Spacer()
            Text("\(Int(category.progress * 100))%")
                .font(.headline)
                .foregroundColor(category.color)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
        )
    }
}
