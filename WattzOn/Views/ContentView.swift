//
//  ContentView.swift
//  WattzOn
//
//  Created by Isidro Treviño on 11/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var router: Router
    @StateObject private var usageViewModel = ElectrodomesticoUsageViewModel()
    @StateObject private var electrodomesticoViewModel = ElectrodomesticoViewModel()
    @StateObject var tabSelection = TabSelection()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var reciboViewModel = ReciboViewModel()

    var body: some View {
        TabView(selection: $tabSelection.selectedTab) {
            HomeView()
                .environmentObject(homeViewModel) // Inject HomeViewModel
                .environmentObject(usageViewModel)
                .environmentObject(electrodomesticoViewModel) // Inject ElectrodomesticoViewModel
                .environmentObject(reciboViewModel)
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
                .tag("Inicio")
            CasaProgresivaView()
                .environmentObject(usageViewModel)
                .environmentObject(electrodomesticoViewModel)
                .environmentObject(reciboViewModel)
                .environmentObject(tabSelection)
                .environmentObject(homeViewModel)
                .tabItem {
                    Label("Mi Hogar", systemImage: "bolt.house.fill")
                }
                .tag("MiHogar")
            AgregarView()
                .environmentObject(usageViewModel)
                .environmentObject(homeViewModel)
                .tabItem {
                    Label("Agregar", systemImage: "plus.circle.fill")
                }
                .tag("Agregar")
            TipView()
                .environmentObject(homeViewModel) // Inject HomeViewModel
                .tabItem {
                    Label("Tips", systemImage: "lightbulb.led.fill")
                }
                .tag("Tips")
            PerfilView()
                .environmentObject(usageViewModel)
                .environmentObject(electrodomesticoViewModel)
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
                .tag("Perfil")
            
        }
        .navigationBarBackButtonHidden()
        .modelContainer(for: [UsuarioResponse.self])
        .environmentObject(tabSelection)
    }
}


/*
import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var router: Router
    @StateObject private var usageViewModel = ElectrodomesticoUsageViewModel()

    var body: some View {
        TabView {
            HomeView()
                .environmentObject(usageViewModel)
                .tabItem {
                    Label("Inicio", systemImage: "house")
                }
            CasaProgresivaView()
                .environmentObject(usageViewModel)
                .tabItem {
                    Label("Mi Hogar", systemImage: "bolt.house.fill")
                }
            AgregarView()
                .environmentObject(usageViewModel)
                .tabItem {
                    Label("Agregar", systemImage: "plus.circle.fill")
                }
            TipView()
                .tabItem {
                    Label("Tips", systemImage: "lightbulb.led.fill")
                }
            PerfilView()
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }
        .navigationBarBackButtonHidden()
        .modelContainer(for: [Usuario.self])
    }
}
*/

class TabSelection: ObservableObject {
    @Published var selectedTab: String = "Inicio"
}

/*
#Preview {
    ContentView()
        .environmentObject(Router())
}
*/
