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
    
    var body: some View {
        if isLoggedIn || usuarios.first != nil {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
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
}
