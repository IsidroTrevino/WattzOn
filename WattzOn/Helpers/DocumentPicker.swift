//
//  DocumentPicker.swift
//  WattzOn
//
//  Created by Fernando Espidio on 25/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedURL = urls.first
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Manejar la cancelación si es necesario
        }
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}
