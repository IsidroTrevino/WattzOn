//
//  ContentView.swift
//  WattzOn
//
//  Created by Isidro Treviño on 11/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var usuarios: [Usuario]
    @State private var isLoggedIn = false
    @EnvironmentObject var router: Router
    
    var body: some View {
        if true || usuarios.first != nil {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                AgregarView()
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
        } else {
            LogIn(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Router())
}
