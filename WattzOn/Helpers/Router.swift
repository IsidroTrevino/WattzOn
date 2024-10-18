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
    }

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func goBack() {
        _ = navPath.popLast()
    }
}
