//
//  WattzOnApp.swift
//  WattzOn
//
//  Created by Isidro Treviño on 11/10/24.
//

import SwiftUI
import SwiftData

@main
struct WattzonApp: App {
    @StateObject private var router = Router()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Electrodomestico.self, Recibo.self])
        return try! ModelContainer(for: schema)
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .domesticoView:
                            DomesticoView()
                        case .recibosListView:
                            RecibosView()
                        case .tipView:
                            TipView()
                        case .tipDetailView:
                            TipDetailView()
                        }
                    }
            }
            .environmentObject(router)
            .modelContainer(sharedModelContainer)
        }
    }
}

/*
import SwiftUI

@main
struct WattzOnApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
*/
