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
    @StateObject private var viewModel = ElectrodomesticoViewModel()

    @State private var showActionSheet = false
    @State private var selectedImage: UIImage?
    @State private var isProcessingImage = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    @State private var showImagePicker = false
    @State private var extractedElectrodomestico: Electrodomestico?

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
            ImagePicker(selectedImage: $selectedImage)
                .onDisappear {
                    if let image = selectedImage {
                        processImage(image)
                    }
                }
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
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
                router.navigate(to: .addElectrodomesticoViewWithData(electrodomestico: electrodomestico))
                extractedElectrodomestico = nil
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchElectrodomesticos()
            }
        }
    }

    private func deleteElectrodomestico(at offsets: IndexSet) {
        for index in offsets {
            let electrodomestico = viewModel.electrodomesticos[index]

            // Eliminar el archivo de imagen si existe
            if let imagePath = electrodomestico.urlimagen {
                do {
                    try FileManager.default.removeItem(atPath: imagePath)
                } catch {
                    print("Error al eliminar la imagen: \(error)")
                }
            }

            // Eliminar del servidor
            Task {
                do {
                    if let electrodomesticoId = electrodomestico.electrodomesticoId {
                        try await viewModel.deleteElectrodomestico(electrodomesticoId)
                        DispatchQueue.main.async {
                            viewModel.electrodomesticos.remove(at: index)
                        }
                    }
                } catch {
                    print("Error al eliminar electrodoméstico:", error)
                    DispatchQueue.main.async {
                        viewModel.errorMessage = "Error al eliminar electrodoméstico."
                        viewModel.showErrorAlert = true
                    }
                }
            }
        }
    }

    // MARK: - Manejo de permisos y disponibilidad de la cámara

    func handleCameraAccess() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.presentCamera()
                    } else {
                        self.errorMessage = "El acceso a la cámara ha sido denegado."
                        self.showErrorAlert = true
                    }
                }
            }
        case .authorized:
            presentCamera()
        case .restricted, .denied:
            errorMessage = "El acceso a la cámara está restringido o denegado."
            showErrorAlert = true
        @unknown default:
            errorMessage = "Error desconocido al acceder a la cámara."
            showErrorAlert = true
        }
    }

    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showImagePicker = true
            imagePickerSourceType = .camera
        } else {
            errorMessage = "La cámara no está disponible en este dispositivo."
            showErrorAlert = true
        }
    }

    // MARK: - Procesamiento de imagen y ML

    func processImage(_ image: UIImage) {
        isProcessingImage = true

        // Convertir UIImage a CVPixelBuffer
        guard let pixelBuffer = image.toCVPixelBuffer() else {
            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.errorMessage = "No se pudo procesar la imagen."
                self.showErrorAlert = true
            }
            return
        }

        // Cargar el modelo de ML
        do {
            let config = MLModelConfiguration()
            let model = try AppliancesMLSprint2(configuration: config)

            // Crear la entrada del modelo utilizando el CVPixelBuffer
            let input = AppliancesMLSprint2Input(image: pixelBuffer)

            // Realizar la predicción
            let output = try model.prediction(input: input)
            let classification = output.target

            // Determinar los valores basados en la clasificación
            var nombre = ""
            var marca = "N/A"
            var tipo = ""
            var modelo = "N/A"
            var potenciaWatts: Double = 0.0

            switch classification {
            case "Microondas":
                nombre = "Microondas Promedio"
                tipo = "Microondas"
                potenciaWatts = 1200.0
            case "Aire Acondicionado":
                nombre = "Aire Acondicionado Promedio"
                tipo = "Aire Acondicionado"
                potenciaWatts = 1300.0
            case "Refrigerador":
                nombre = "Refrigerador Promedio"
                tipo = "Refrigerador"
                potenciaWatts = 575.0
            default:
                nombre = "Electrodoméstico Desconocido"
                tipo = "Desconocido"
                potenciaWatts = 0.0
            }

            // Guardar la imagen y obtener su ruta
            let imagePath = saveImageToDocuments(image: image)

            // Obtener el usuario actual
            let fetchRequest = FetchDescriptor<Usuario>(predicate: nil)
            guard let usuarios = try? modelContext.fetch(fetchRequest), let usuario = usuarios.first else {
                print("Usuario no encontrado")
                DispatchQueue.main.async {
                    self.isProcessingImage = false
                    self.errorMessage = "Usuario no encontrado."
                    self.showErrorAlert = true
                }
                return
            }
            let usuarioId = usuario.usuarioId

            // Crear el objeto Electrodomestico
            let nuevoElectrodomestico = Electrodomestico(
                electrodomesticoId: 0,
                usuarioId: usuarioId,
                nombre: nombre,
                tipo: tipo,
                consumowatts: potenciaWatts,
                descripcion: "",
                urlimagen: imagePath,
                marca: marca,
                modelo: modelo
            )

            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.extractedElectrodomestico = nuevoElectrodomestico
            }
        } catch {
            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.errorMessage = "Error al procesar la imagen con el modelo de ML."
                self.showErrorAlert = true
            }
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

// Extensión para convertir UIImage a CVPixelBuffer
import UIKit
import CoreVideo
import SwiftData

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let image = self.cgImage!
        let frameSize = CGSize(width: image.width, height: image.height)

        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(frameSize.width),
            Int(frameSize.height),
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(buffer)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: Int(frameSize.width),
            height: Int(frameSize.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
            return nil
        }

        context.draw(image, in: CGRect(origin: .zero, size: frameSize))

        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))

        return buffer
    }
}

/*
import SwiftUI
import CoreML
import SwiftData
import AVFoundation

struct DomesticoView: View {
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    @Query var electrodomesticos: [Electrodomestico]

    @State private var showActionSheet = false
    @State private var selectedImage: UIImage?
    @State private var isProcessingImage = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    @State private var showImagePicker = false
    @State private var extractedElectrodomestico: Electrodomestico?

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
                        showImagePicker = true
                        imagePickerSourceType = .photoLibrary
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
                        processImage(image)
                    }
                }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
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
                router.navigate(to: .addElectrodomesticoViewWithData(electrodomestico: electrodomestico))
                extractedElectrodomestico = nil
            }
        }
    }

    private func deleteElectrodomestico(at offsets: IndexSet) {
        for index in offsets {
            let electrodomestico = electrodomesticos[index]

            // Eliminar el archivo de imagen si existe
            if let imagePath = electrodomestico.urlimagen {
                do {
                    try FileManager.default.removeItem(atPath: imagePath)
                } catch {
                    print("Error al eliminar la imagen: \(error)")
                }
            }

            // Eliminar de SwiftData
            modelContext.delete(electrodomestico)

            // Si el electrodomesticoId no es nil, eliminar del servidor
            if let remoteId = electrodomestico.electrodomesticoId {
                // Llamar a la API para eliminar del servidor
                Task {
                    do {
                        try await deleteElectrodomesticoAPI(remoteId: remoteId)
                        print("Electrodoméstico eliminado del servidor.")
                    } catch {
                        print("Error al eliminar electrodoméstico:", error)
                    }
                }
            }
        }
    }

    // Función para eliminar el electrodoméstico en el servidor
    func deleteElectrodomesticoAPI(remoteId: Int) async throws {
        // Obtener el usuario y el token
        let fetchRequest = FetchDescriptor<Usuario>(predicate: nil)
        guard let usuarios = try? modelContext.fetch(fetchRequest), let usuario = usuarios.first else {
            print("Usuario no encontrado")
            throw NSError(domain: "Usuario no encontrado", code: 0)
        }
        let token = usuario.token

        guard let url = URL(string: "https://wattzonapi.onrender.com/api/wattzon/electrodomestico/\(remoteId)") else {
            print("URL inválida")
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP:", httpResponse.statusCode)
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: Respuesta del servidor no fue 200 OK")
                throw URLError(.badServerResponse)
            }

        } catch {
            print("Error al realizar la solicitud:", error)
            throw error
        }
    }

    // MARK: - Manejo de permisos y disponibilidad de la cámara

    func handleCameraAccess() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.presentCamera()
                    } else {
                        self.errorMessage = "El acceso a la cámara ha sido denegado."
                        self.showErrorAlert = true
                    }
                }
            }
        case .authorized:
            presentCamera()
        case .restricted, .denied:
            errorMessage = "El acceso a la cámara está restringido o denegado."
            showErrorAlert = true
        @unknown default:
            errorMessage = "Error desconocido al acceder a la cámara."
            showErrorAlert = true
        }
    }

    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showImagePicker = true
            imagePickerSourceType = .camera
        } else {
            errorMessage = "La cámara no está disponible en este dispositivo."
            showErrorAlert = true
        }
    }

    // MARK: - Procesamiento de imagen y ML

    func processImage(_ image: UIImage) {
        isProcessingImage = true

        // Convertir UIImage a CVPixelBuffer
        guard let pixelBuffer = image.toCVPixelBuffer() else {
            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.errorMessage = "No se pudo procesar la imagen."
                self.showErrorAlert = true
            }
            return
        }

        // Cargar el modelo de ML
        do {
            let config = MLModelConfiguration()
            let model = try AppliancesMLSprint2(configuration: config)

            // Crear la entrada del modelo utilizando el CVPixelBuffer
            let input = AppliancesMLSprint2Input(image: pixelBuffer)

            // Realizar la predicción
            let output = try model.prediction(input: input)
            let classification = output.target

            // Determinar los valores basados en la clasificación
            var nombre = ""
            var marca = "N/A"
            var tipo = ""
            var modelo = "N/A"
            var potenciaWatts: Double = 0.0

            switch classification {
            case "Microondas":
                nombre = "Microondas Promedio"
                tipo = "Microondas"
                potenciaWatts = 1200.0
            case "Aire Acondicionado":
                nombre = "Aire Acondicionado Promedio"
                tipo = "Aire Acondicionado"
                potenciaWatts = 1300.0
            case "Refrigerador":
                nombre = "Refrigerador Promedio"
                tipo = "Refrigerador"
                potenciaWatts = 575.0
            default:
                nombre = "Electrodoméstico Desconocido"
                tipo = "Desconocido"
                potenciaWatts = 0.0
            }

            // Guardar la imagen y obtener su ruta
            let imagePath = saveImageToDocuments(image: image)

            // Obtener el usuario actual
            let fetchRequest = FetchDescriptor<Usuario>(predicate: nil)
            guard let usuarios = try? modelContext.fetch(fetchRequest), let usuario = usuarios.first else {
                print("Usuario no encontrado")
                DispatchQueue.main.async {
                    self.isProcessingImage = false
                    self.errorMessage = "Usuario no encontrado."
                    self.showErrorAlert = true
                }
                return
            }
            let usuarioId = usuario.usuarioId

            // Crear el objeto Electrodomestico
            let nuevoElectrodomestico = Electrodomestico(
                id: UUID(),
                electrodomesticoId: 0,
                usuarioId: usuarioId,
                nombre: nombre,
                tipo: tipo,
                consumowatts: potenciaWatts,
                descripcion: "",
                urlimagen: imagePath,
                marca: marca,
                modelo: modelo
            )

            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.extractedElectrodomestico = nuevoElectrodomestico
            }
        } catch {
            DispatchQueue.main.async {
                self.isProcessingImage = false
                self.errorMessage = "Error al procesar la imagen con el modelo de ML."
                self.showErrorAlert = true
            }
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

// Extensión para convertir UIImage a CVPixelBuffer
import UIKit
import CoreVideo

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let image = self.cgImage!
        let frameSize = CGSize(width: image.width, height: image.height)

        var pixelBuffer: CVPixelBuffer?
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ] as CFDictionary

        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(frameSize.width),
            Int(frameSize.height),
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(buffer)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: Int(frameSize.width),
            height: Int(frameSize.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
            return nil
        }

        context.draw(image, in: CGRect(origin: .zero, size: frameSize))

        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))

        return buffer
    }
}
*/
