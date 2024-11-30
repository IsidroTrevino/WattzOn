//
//  ReciboView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import SwiftUI

struct RecibosView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ReciboViewModel()
    
    @State private var showActionSheet = false
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isCamera = false
    @State private var isProcessingImage = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var extractedData: ExtractedReceiptData?
    
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
            
            Text("Tus Recibos de Luz")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            if viewModel.recibos.isEmpty {
                VStack {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("No tienes recibos de luz agregados")
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .padding(.top, 50)
            } else {
                List {
                    ForEach(viewModel.recibos) { recibo in
                        ReciboCard(recibo: recibo)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                // print("Conceptos del recibo al cargar: \(recibo.conceptos.map { $0.description }.joined(separator: "\n"))")
                                router.navigate(to: .editReciboView(recibo: recibo))
                            }
                        /*
                            .onAppear {
                                print("Conceptos del recibo al cargar: \(recibo.conceptos.map { $0.description }.joined(separator: "\n"))")
                            }
                        */
                    }
                    .onDelete(perform: deleteRecibo)
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
            
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
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(
                        title: Text("Agregar Recibo"),
                        buttons: [
                            .default(Text("Escanear con Cámara")) {
                                isCamera = true
                                showImagePicker = true
                            },
                            .default(Text("Subir Foto")) {
                                isCamera = false
                                showImagePicker = true
                            },
                            .default(Text("Agregar Manualmente")) {
                                router.navigate(to: .addReciboView(initialData: nil))
                            },
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: isCamera ? .camera : .photoLibrary)
                        .onDisappear {
                            if let image = selectedImage {
                                processReceiptImage(image)
                            }
                        }
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationBarHidden(true)
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
        .onChange(of: extractedData) { newValue in
            if let data = newValue {
                router.navigate(to: .addReciboView(initialData: data))
                extractedData = nil
            }
        }
        .onAppear {
            if viewModel.modelContext == nil {
                viewModel.modelContext = modelContext
            }
            Task {
                await viewModel.fetchRecibos()
            }
        }
    }
    
    private func deleteRecibo(at offsets: IndexSet) {
        for index in offsets {
            let recibo = viewModel.recibos[index]
            Task {
                do {
                    if let idRecibo = recibo.idRecibo {
                        try await viewModel.deleteRecibo(idRecibo)
                        DispatchQueue.main.async {
                            viewModel.recibos.remove(at: index)
                        }
                    }
                } catch {
                    print("Error al eliminar recibo:", error)
                    DispatchQueue.main.async {
                        viewModel.errorMessage = "Error al eliminar recibo."
                        viewModel.showErrorAlert = true
                    }
                }
            }
        }
    }
    
    private func processReceiptImage(_ image: UIImage) {
        isProcessingImage = true
        let ocrProcessor = OCRProcessor()
        ocrProcessor.recognizeText(from: image) { result in
            DispatchQueue.main.async {
                self.isProcessingImage = false
                switch result {
                case .success(let extractedData):
                    // Navegar a AddReciboView con los datos extraídos
                    self.extractedData = extractedData
                case .failure(let error):
                    // Manejar el error
                    self.errorMessage = "No se pudo procesar la imagen. Por favor, intente nuevamente."
                    self.showErrorAlert = true
                    print("Error al procesar la imagen: \(error)")
                }
            }
        }
    }
}
