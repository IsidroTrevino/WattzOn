//
//  GeneralUseFunctions.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

import Foundation

func getCurrentUsuario() -> (usuarioId: Int, token: String)? {
    if let token = UserDefaults.standard.string(forKey: "token") {
        let usuarioId = UserDefaults.standard.integer(forKey: "usuarioId")

        if usuarioId != 0 {
            return (usuarioId: usuarioId, token: token)
        }
    }
    return nil
}
