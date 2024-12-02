//
//  DebanhiTests.swift
//  DebanhiTests
//
//  Created by Debanhi Medina on 01/12/24.
//

import Testing
@testable import WattzOn

struct DebanhiTests {

    @Test func testGetTips() async throws {
        let tipsViewModel = TipsViewModel()
        
        #expect(!tipsViewModel.arrTip.isEmpty, "arrTip no debería estar vacío después de la inicialización")
        
        if let firstTip = tipsViewModel.arrTip.first {
            #expect(firstTip.tipName == "¿Cómo reducir el consumo eléctrico?")
            #expect(firstTip.description == "Reducir el consumo eléctrico es una excelente forma de ahorrar dinero y cuidar el medio ambiente.")
        } else {
            print("No se pudo")
        }
    }

}
