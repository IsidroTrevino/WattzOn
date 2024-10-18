//
//  ContentView.swift
//  WattzOn
//
//  Created by Isidro Treviño on 11/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
