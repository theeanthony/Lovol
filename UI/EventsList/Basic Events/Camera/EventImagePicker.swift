import SwiftUI
import MobileCoreServices // import for kUTTypeMovie
import UniformTypeIdentifiers
import AVFoundation

struct EventImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode)  var presentationMode
    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var selectedImage: UIImage
    @Binding var selectedVideo: URL?
    func makeUIViewController(context: UIViewControllerRepresentableContext<EventImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.mediaTypes = [UTType.movie.identifier, UTType.image.identifier]
        imagePicker.videoMaximumDuration = 10.0 // Limit video duration to 10 seconds
        imagePicker.videoQuality = .typeHigh

        imagePicker.delegate = context.coordinator
        return imagePicker
    }


    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<EventImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: EventImagePicker

        init(_ parent: EventImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            } else if let videoURL = info[.mediaURL] as? URL {
                    VideoCompressor().compressVideo(inputURL: videoURL) { result in
                        switch result {
                        case .success(let compressedURL):
                            self.parent.selectedVideo = compressedURL
                        case .failure(let error):
                            print("Video compression failed: \(error.localizedDescription)")
                            self.parent.selectedVideo = nil
                        }
                    }
                    
                
                parent.presentationMode.wrappedValue.dismiss()
            }
        }

    }
}


func generateThumbnail(for videoURL: URL) -> UIImage? {
    let asset = AVAsset(url: videoURL)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true

    let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
    var image: UIImage?

    do {
        let cgImage = try generator.copyCGImage(at: timestamp, actualTime: nil)
        image = UIImage(cgImage: cgImage)
    } catch {
        print("Error generating thumbnail: \(error)")
    }

    return image
}
//switch result {
//case .success(let compressedURL):
//    parent.selectedVideo = compressedURL
//case .failure(let error):
//    print("Video compression failed: \(error.localizedDescription)")
//    parent.selectedVideo = nil
//}
