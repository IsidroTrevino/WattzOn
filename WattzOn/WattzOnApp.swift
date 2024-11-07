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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Electrodomestico.self, Recibo.self, Usuario.self])
        return try! ModelContainer(for: schema)
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                Group {
                    if isLoggedIn {
                        ContentView()
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
                    }
                }
            }
            .environmentObject(router)
            .modelContainer(sharedModelContainer)
        }
    }
}
