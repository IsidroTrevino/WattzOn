//
//  Router.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

// Router.swift

import Foundation

class Router: ObservableObject {
    @Published var navPath: [Destination] = []

    enum Destination: Hashable {
        case logIn
        case signIn
        case domesticoView
        case recibosListView
        case tipView
        case tipDetailView(tip: TipsModel)
        case homeView
        case addElectrodomesticoView
        case addElectrodomesticoViewWithData(electrodomestico: Electrodomestico)
        case editElectrodomesticoView(electrodomestico: Electrodomestico)
        case electrodomesticoReadingsInfo
        case addReciboView(initialData: ExtractedReceiptData?)
        case editReciboView(recibo: Recibo)
        case reciboReadingsInfo(field: ReciboField)

    }

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func goBack() {
        _ = navPath.popLast()
    }
}
