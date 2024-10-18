//
//  HomeViewModel.swift
//  WattzOn
//
//  Created by Ale Peña on 17/10/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var consumoEnergetico: ConsumoEnergetico
    
    init() {
        consumoEnergetico = ConsumoEnergetico(ahorro: 1987.69, consumo: 570)
    }
}
