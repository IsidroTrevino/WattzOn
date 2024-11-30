//
//  OnboardingView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 24/11/24.
//

// OnboardingView.swift

import SwiftUI
import UniformTypeIdentifiers

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var selectedTab = 0
    @State private var selectedImage: UIImage? = nil
    @State private var isProcessing = false
    @State private var showImagePicker = false
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var showDocumentPicker = false
    @State private var selectedPDFURL: URL? = nil

    var body: some View {
        TabView(selection: $selectedTab) {
            // Primera página del onboarding
            VStack {
                Spacer()
                Text("Bienvenido a WattzOn")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Tu asistente para monitorear y ahorrar energía.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()
                Image("appIcon") // Reemplaza con tu imagen
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                Spacer()
            }
            .tag(0)

            // Segunda página del onboarding con el botón para subir PDF
            VStack {
                Spacer()
                Text("Empieza subiendo tu recibo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Obtén información sobre tu consumo energético.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()
                Image("appIcon") // Reemplaza con tu imagen
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                Spacer()

                // Botón para subir PDF
                Button(action: {
                    // Acción para subir el PDF
                    showDocumentPicker = true
                }) {
                    HStack {
                        Image(systemName: "doc")
                            .font(.title2)
                        Text("Subir Recibo en PDF")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker(selectedURL: $selectedPDFURL)
                }
                .onChange(of: selectedPDFURL) { url in
                    if let _ = url {
                        // Por ahora, no hacemos nada con el PDF
                        // Aquí puedes simular la funcionalidad o mostrar un mensaje
                        // Por ejemplo, marcar el onboarding como completado
                        isOnboardingCompleted = true
                    }
                }

                // Texto que lleva a la tercera página
                Button(action: {
                    // Mover a la tercera página
                    selectedTab = 2
                }) {
                    Text("No sé cómo conseguir mi recibo digital")
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding(.top, 10)

                Spacer()
            }
            .tag(1)

            // Tercera página del onboarding - Tutorial
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Spacer()
                        Text("Cómo obtener tu recibo digital de CFE")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()

                        // Contenido del tutorial
                        Text("1. Visita el sitio web oficial de CFE.")
                            .font(.headline)
                            .padding(.horizontal)

                        // Agregar el link después del paso 1
                        Link("Haz clic aquí para ir al sitio web de CFE", destination: URL(string: "https://app.cfe.mx/aplicaciones/CCFE/SolicitudesCFE/Solicitudes/ConsultaTuReciboLuzGmx")!)
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.horizontal)

                        Text("2. Inicia sesión en tu cuenta o regístrate si no tienes una.")
                            .font(.headline)
                            .padding(.horizontal)
                        Text("3. Navega a la sección de 'Recibos' o 'Consulta tu recibo'.")
                            .font(.headline)
                            .padding(.horizontal)
                        Text("4. Descarga tu recibo en formato PDF.")
                            .font(.headline)
                            .padding(.horizontal)
                        Text("5. Vuelve a la aplicación y sube el PDF para empezar a monitorear tu consumo.")
                            .font(.headline)
                            .padding(.horizontal)

                        // Agregar la imagen después del paso 5
                        Image("cfepagina")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .padding()

                        Spacer()
                    }
                }
                Spacer()
                Button(action: {
                    // Volver a la segunda página
                    selectedTab = 1
                }) {
                    Text("Volver")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                Spacer()
            }
            .tag(2)

        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
    
    
}




/*
 
import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var selectedTab = 0
    @State private var selectedImage: UIImage? = nil
    @State private var isProcessing = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // Primera página del onboarding
            VStack {
                Spacer()
                Text("Bienvenido a WattzOn")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Tu asistente para monitorear y ahorrar energía.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()
                Image("Miguel") // Reemplaza con tu imagen
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                Spacer()
            }
            .tag(0)

            // Segunda página del onboarding con el botón para escanear el recibo
            VStack {
                Spacer()
                Text("Empieza escaneando tu recibo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Obtén información sobre tu consumo energético.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()
                Image("Miguel") // Reemplaza con tu imagen
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                Spacer()

                // Botón para escanear el recibo
                if isProcessing {
                    ProgressView("Procesando...")
                        .padding()
                } else {
                    Button(action: {
                        // Acción para escanear el recibo
                        showImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "camera")
                                .font(.title2)
                            Text("Escanear Recibo")
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                }
                Spacer()
            }
            .tag(1)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                isProcessing = true
                recognizeTextFromImage(image)
            }
        }
    }

    @State private var showImagePicker = false
    @StateObject private var homeViewModel = HomeViewModel()

    // Función para reconocer texto desde la imagen
    func recognizeTextFromImage(_ image: UIImage) {
        homeViewModel.recognizeTextFromImage(image) { success in
            isProcessing = false
            if success {
                // Almacenar el total de watts en UserDefaults
                let totalWatts = homeViewModel.consumoEnergetico.consumo
                UserDefaults.standard.set(totalWatts, forKey: "TotalWatts")

                // Marcar el onboarding como completado
                isOnboardingCompleted = true
            } else {
                // Mostrar error si es necesario
                // Puedes manejar errores adicionales aquí
            }
        }
    }
}

*/
