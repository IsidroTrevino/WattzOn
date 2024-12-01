//
//  WattzonApp.swift
//  WattzOn
//
//  Created by Isidro Treviño on 11/10/24.
//

import SwiftUI
import SwiftData

@main
struct WattzonApp: App {
    @StateObject private var router = Router()
    @State private var isLoggedIn = false
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                Group {
                    if isLoggedIn {
                        if isOnboardingCompleted {
                            ContentView()
                        } else {
                            OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                        }
                    } else {
                        LogIn(isLoggedIn: $isLoggedIn)
                    }
                }
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case .logIn:
                        LogIn(isLoggedIn: $isLoggedIn)
                    case .signIn:
                        SignIn(isLoggedIn: $isLoggedIn)
                    case .domesticoView:
                        DomesticoView()
                    case .recibosListView:
                        RecibosView()
                    case .tipView:
                        TipView()
                    case .tipDetailView(let tip):
                        TipDetailView(tip: tip)
                    case .homeView:
                        ContentView()
                    case .addElectrodomesticoView:
                        AddElectrodomesticoView()
                    case .addElectrodomesticoViewWithData(let electrodomestico):
                        AddElectrodomesticoView(electrodomestico: electrodomestico)
                    case .editElectrodomesticoView(let electrodomestico):
                        EditElectrodomesticoView(electrodomestico: electrodomestico)
                    case .electrodomesticoReadingsInfo:
                        ElectrodomesticoReadingsInfo()
                    case .addReciboView(let initialData):
                        AddReciboView(initialData: initialData)
                    case .editReciboView(let recibo):
                        EditReciboView(recibo: recibo)
                    case .reciboReadingsInfo(let field):
                        ReciboReadingsInfo(field: field)
                    case .onBoardingView:
                        OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                    }
                }
            }
            .environmentObject(router)
            .modelContainer(for: [UsuarioResponse.self])
        }
    }
}
