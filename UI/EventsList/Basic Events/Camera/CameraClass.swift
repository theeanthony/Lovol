import SwiftUI
import AVFoundation
import CoreData


struct CameraView: UIViewRepresentable {

    @Binding var takenPhoto: UIImage
    @Binding var showPhotoTaken: Bool

    func makeCoordinator() -> Coordinator {
        return Coordinator(takenPhoto: $takenPhoto, showPhotoTaken: $showPhotoTaken)
    }

    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect.zero)
        
        let captureSession = AVCaptureSession()
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            return view
        }
        
        captureSession.addInput(input)
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = false
        
        captureSession.addOutput(photoOutput)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)
        
        previewLayer.frame = view.bounds // Resize the preview layer to fill the view bounds
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
        
        @Binding var takenPhoto: UIImage
        @Binding var showPhotoTaken: Bool
        
        init(takenPhoto: Binding<UIImage>, showPhotoTaken: Binding<Bool>) {
            _takenPhoto = takenPhoto
            _showPhotoTaken = showPhotoTaken
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            // Handle video output if needed
        }
        
        func capturePhoto() {
            let photoOutput = AVCapturePhotoOutput()
            
            let settings = AVCapturePhotoSettings()
            settings.isHighResolutionPhotoEnabled = true
            settings.isAutoStillImageStabilizationEnabled = true
            
            photoOutput.capturePhoto(with: settings, delegate: self) // pass context object here
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) else { return }
            
            takenPhoto = image
            showPhotoTaken = true
        }
    }
}

//extension CameraView.Coordinator: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let imageData = photo.fileDataRepresentation(),
//              let image = UIImage(data: imageData) else { return }
//        
//        takenPhoto = image
//        showPhotoTaken = true
//    }
//}
