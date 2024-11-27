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
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted = false // Use @AppStorage

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Usuario.self])
        return try! ModelContainer(for: schema)
    }()
    
    init() {
        // Configura los valores predeterminados
        UserDefaults.standard.set(3, forKey: "usuarioId")
        UserDefaults.standard.set(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c3VhcmlvSWQiOjIsImlhdCI6MTczMjI5NTUxNn0.LCX6zYt2ngIYulw7jfZpOwWw1KyT3ib0LpyDeR2nw1E",
            forKey: "token"
        )
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                Group {
                    if true {
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
                    }
                }
            }
            .environmentObject(router)
            .modelContainer(sharedModelContainer)
        }
    }
}
