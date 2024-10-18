//
//  ReciboView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import SwiftUI
import SwiftData

struct RecibosView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    @Query var recibos: [Recibo]
    
    @State private var showAddSheet = false
    @State private var showActionSheet = false
    @State private var selectedRecibo: Recibo?
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isCamera = false
    @State private var isProcessingImage = false
    @State private var addReciboView: AnyView?
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
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
            
            if recibos.isEmpty {
                // Mostrar texto e icono cuando la lista está vacía
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
                    ForEach(recibos) { recibo in
                        ReciboCard(recibo: recibo)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                selectedRecibo = recibo
                            }
                    }
                    .onDelete(perform: deleteRecibo)
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
                                showAddSheet = true
                                addReciboView = AnyView(
                                    AddReciboView()
                                        .environment(\.modelContext, modelContext)
                                )
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
                .sheet(isPresented: $showAddSheet) {
                    if let addReciboView = addReciboView {
                        addReciboView
                    }
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $selectedRecibo) { recibo in
            EditReciboView(recibo: recibo)
                .environment(\.modelContext, modelContext)
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
    }
    
    private func deleteRecibo(at offsets: IndexSet) {
        for index in offsets {
            let recibo = recibos[index]
            modelContext.delete(recibo)
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
                    // Presentar AddReciboView con los datos extraídos
                    self.addReciboView = AnyView(
                        AddReciboView(initialData: extractedData)
                            .environment(\.modelContext, modelContext)
                    )
                    self.showAddSheet = true
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

#Preview {
    RecibosView()
        .environmentObject(Router())
        .modelContainer(for: Recibo.self)
}
