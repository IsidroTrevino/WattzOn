//
//  ImagePicker.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // No se requiere actualización
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
