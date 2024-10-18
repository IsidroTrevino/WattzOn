//
//  Router.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import Foundation

class Router: ObservableObject {
    @Published var navPath: [Destination] = []

    enum Destination: Hashable {
        case domesticoView
        case recibosListView
        case tipView        // Añadido para TipView
        case tipDetailView  // Añadido para TipDetailView
    }

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func goBack() {
        _ = navPath.popLast()
    }
}
