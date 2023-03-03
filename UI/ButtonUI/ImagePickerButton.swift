//
//  ImagePickerButton.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//

import SwiftUI

struct ImagePickerButton<Label: View>: View {
    @Binding var imageURL: URL?
    @ViewBuilder let label: () -> Label
    @State private var showImageSourceDialog = false
    @State private var sourceType: UIImagePickerController.SourceType?
    var body: some View {
        Button(action: {
            showImageSourceDialog = true

        }) {
            label()
        }

        .confirmationDialog("Choose Image", isPresented: $showImageSourceDialog) {
            Button("Choose from Library", action: {
                sourceType = .photoLibrary
            })
            Button("Take Photo", action: {
                sourceType = .camera
            })
            if imageURL != nil {
                Button("Remove Photo", role: .destructive, action: {
                    imageURL = nil
                })
            }
        }
        .fullScreenCover(item: $sourceType) { sourceType in
            ImagePickerView(sourceType: sourceType) {
                imageURL = $0
            }
            .ignoresSafeArea()
        }
        
    }
}

private extension ImagePickerButton {
struct ImagePickerView: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onSelect: (URL) -> Void
 
    @Environment(\.dismiss) var dismiss
 
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(view: self)
    }
 
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = sourceType
        return imagePicker
    }
 
    func updateUIViewController(_ imagePicker: UIImagePickerController, context: Context) {}
    }
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let view: ImagePickerView
     
        init(view: ImagePickerView) {
            self.view = view
        }
     
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let imageURL = info[.imageURL] as? URL else { return }
            view.onSelect(imageURL)
            view.dismiss()
        }
    }
}
extension UIImagePickerController.SourceType: Identifiable {
    public var id: String { "\(self)" }
}
