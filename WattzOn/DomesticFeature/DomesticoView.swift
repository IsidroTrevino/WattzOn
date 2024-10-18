//
//  DomesticoView.swift
//  WattzOn
//
//  Created by Fernando Espidio on 16/10/24.
//

import SwiftUI
import Vision
import CoreML
import SwiftData

struct DomesticoView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    @Query var electrodomesticos: [Electrodomestico]

    @State private var showAddSheet = false
    @State private var showActionSheet = false
    @State private var selectedElectrodomestico: Electrodomestico?

    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isProcessingImage = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera

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

            Text("Agrega tus\n Electrodomésticos")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 10)

            if electrodomesticos.isEmpty {
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
                    ForEach(electrodomesticos) { electrodomestico in
                        DomesticCard(electrodomestico: electrodomestico)
                            .padding(.vertical, 5)
                            .onTapGesture {
                                selectedElectrodomestico = electrodomestico
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
                        showImagePicker = true
                        imagePickerSourceType = .camera
                    },
                    .default(Text("Subir Foto de la Galería")) {
                        showImagePicker = true
                        imagePickerSourceType = .photoLibrary
                    },
                    .default(Text("Agregar Manualmente")) {
                        showAddSheet = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showAddSheet) {
            AddElectrodomesticoView()
                .environment(\.modelContext, modelContext)
        }
        .sheet(item: $selectedElectrodomestico) { electrodomestico in
            EditElectrodomesticoView(electrodomestico: electrodomestico)
                .environment(\.modelContext, modelContext)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                // Guardar la imagen y obtener su ruta
                let imagePath = saveImageToDocuments(image: image)
                // Usar pd_id fijo
                let pd_id = "3417972"
                // Llamar a la API con el pd_id fijo y la ruta de la imagen
                fetchDataWithPdId(pd_id, imagePath: imagePath)
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func deleteElectrodomestico(at offsets: IndexSet) {
        for index in offsets {
            let electrodomestico = electrodomesticos[index]

            // Eliminar el archivo de imagen si existe
            if let imagePath = electrodomestico.imagePath {
                do {
                    try FileManager.default.removeItem(atPath: imagePath)
                } catch {
                    print("Error al eliminar la imagen: \(error)")
                }
            }

            modelContext.delete(electrodomestico)
        }
    }

    // MARK: - Funciones Auxiliares

    func fetchDataWithPdId(_ pd_id: String, imagePath: String?) {
        isProcessingImage = true

        fetchEnergyStarData(pd_id: pd_id) { products in
            DispatchQueue.main.async {
                self.isProcessingImage = false
            }

            guard let products = products, !products.isEmpty else {
                DispatchQueue.main.async {
                    self.errorMessage = "No se encontraron productos para el ID proporcionado."
                    self.showErrorAlert = true
                }
                return
            }

            let product = products[0]
            self.createElectrodomestico(from: product, imagePath: imagePath)
        }
    }

    func createElectrodomestico(from product: EnergyStarModel, imagePath: String?) {
        // Convertir los valores numéricos
        let potenciaWatts = Double(product.category_2_short_idle_watts) ?? 0.0

        let nuevoElectrodomestico = Electrodomestico(
            nombre: product.model_name,
            marca: product.brand_name,
            tipo: product.type,
            modelo: product.model_number,
            potenciaWatts: potenciaWatts,
            imagePath: imagePath
        )

        DispatchQueue.main.async {
            modelContext.insert(nuevoElectrodomestico)
        }
    }

    func saveImageToDocuments(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let url = getDocumentsDirectory().appendingPathComponent(filename)

        do {
            try data.write(to: url)
            return url.path
        } catch {
            print("Error al guardar la imagen: \(error)")
            return nil
        }
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

#Preview {
    DomesticoView()
        .environmentObject(Router())
        .modelContainer(for: Electrodomestico.self)
}
