//
//  DomesticoView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

// DomesticoView.swift

import SwiftUI
import CoreML
import SwiftData
import AVFoundation

struct DomesticoView: View {
    @EnvironmentObject var router: Router
    
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = ElectrodomesticoViewModel()
    
    @State var showActionSheet = false
    @State var selectedImage: UIImage?
    @State var isProcessingImage = false
    @State var showErrorAlert = false
    @State var errorMessage = ""
    @State var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    @State var showImagePicker = false
    @State var extractedElectrodomestico: Electrodomestico?
    @State var showNoMatchAlert = false
    @Query var usuario: [UsuarioResponse]
    
    func getToken() -> String {
        return usuario.first!.token
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    router.goBack()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "#FFA800"))
                }
                Spacer()
                EditButton()
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "#FFA800"))
                    .cornerRadius(25)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Text("Agrega tus\nElectrodomésticos")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                        
            if viewModel.electrodomesticos.isEmpty {
                VStack {
                    Image(systemName: "house.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No tienes electrodomésticos agregados")
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .padding(.top, 50)
            } else {
                List {
                    ForEach(viewModel.electrodomesticos) { electrodomestico in
                        DomesticCard(electrodomestico: electrodomestico)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                router.navigate(to: .editElectrodomesticoView(electrodomestico: electrodomestico))
                            }
                    }
                    .onDelete(perform: deleteElectrodomestico)
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
            
            // Botón de agregar en la esquina inferior derecha
            HStack {
                Spacer()
                Button(action: {
                    showActionSheet = true
                }) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Agregar Electrodoméstico"),
                buttons: [
                    .default(Text("Escanear con Cámara")) {
                        handleCameraAccess()
                    },
                    .default(Text("Subir Foto de la Galería")) {
                        imagePickerSourceType = .photoLibrary
                        showImagePicker = true
                    },
                    .default(Text("Agregar Manualmente")) {
                        router.navigate(to: .addElectrodomesticoView)
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
                .onDisappear {
                    if let image = selectedImage {
                        print("Hasta acá todo bien")
                        processImage(image, usuarioId: usuario.first!.usuario.usuarioId)
                    }
                }
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showNoMatchAlert) {
            Alert(
                title: Text("No se encontró coincidencia con este electrodoméstico"),
                message: Text("¿Deseas intentarlo de nuevo o llenar los datos manualmente?"),
                primaryButton: .default(Text("Intentar de nuevo")) {
                    // Acción para intentar de nuevo
                    self.selectedImage = nil
                    self.imagePickerSourceType = .camera // O .photoLibrary según prefieras
                    self.showImagePicker = true
                },
                secondaryButton: .default(Text("Llenar manualmente")) {
                    // Navegar a AddElectrodomesticoView
                    router.navigate(to: .addElectrodomesticoView)
                }
            )
        }
        .overlay(
            Group {
                if isProcessingImage {
                    ZStack {
                        Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                        VStack {
                            ProgressView("Procesando imagen...")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        )
        .onChange(of: extractedElectrodomestico) { newValue in
            if let electrodomestico = newValue {
                print("Navegando a AddElectrodomesticoView con: \(electrodomestico.nombre)")
                router.navigate(to: .addElectrodomesticoViewWithData(electrodomestico: electrodomestico))
                extractedElectrodomestico = nil
            }
        }
        .onAppear {
            Task {
                print(usuario.first?.usuario.usuarioId ?? 999999)
                await viewModel.fetchElectrodomesticos(usuarioId: usuario.first?.usuario.usuarioId ?? 0, token: usuario.first?.token ?? "")
            }
        }
    }
    
}
