import SwiftUI
import AVFoundation

struct EventImagePicker: UIViewRepresentable {

    @Binding var takenPhotos: [UIImage]

    func makeCoordinator() -> Coordinator {
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        let coordinator = Coordinator(self, photoOutput: photoOutput)
        return coordinator
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.8))

        DispatchQueue.global(qos: .userInitiated).async {
            let captureSession = AVCaptureSession()
            print("in dispatch")
            // Check camera device availability
            guard let captureDevice = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: captureDevice) else {
                print("Camera device is not available")
                return
            }
            print("camera device is available")
            
            // Verify AVCaptureDeviceInput object was created successfully
            guard captureSession.canAddInput(input) else {
                print("Could not add AVCaptureDeviceInput to capture session")
                return
            }
            print("capture session verified, \(input)")
            
            captureSession.addInput(input)
            
            let photoOutput = AVCapturePhotoOutput()
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = false
            print("photooutput \(photoOutput)")
            // Verify AVCapturePhotoOutput object was added successfully
            guard captureSession.canAddOutput(photoOutput) else {
                print("Could not add AVCapturePhotoOutput to capture session")
                return
            }
            
            print("capture before session running")
            captureSession.addOutput(photoOutput)
            
            captureSession.startRunning()
            print("capture session running")

            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.frame = view.layer.bounds
                previewLayer.videoGravity = .resizeAspectFill
                view.layer.addSublayer(previewLayer)

                let takePhotoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                takePhotoButton.backgroundColor = .white
                takePhotoButton.layer.cornerRadius = 40
                takePhotoButton.layer.masksToBounds = true
                takePhotoButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height - 80)
                print("button created ")
                takePhotoButton.addTarget(context.coordinator, action: #selector(Coordinator.takePhoto), for: .touchUpInside)
                view.addSubview(takePhotoButton)
            }
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed
    }

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {

        let parent: EventImagePicker
        let photoOutput: AVCapturePhotoOutput
        
        init(_ parent: EventImagePicker, photoOutput: AVCapturePhotoOutput) {
            self.parent = parent
            self.photoOutput = photoOutput
        }

        @objc func takePhoto() {
            let settings = AVCapturePhotoSettings()
            settings.flashMode = .auto
            print("takephotos method activitated")
            
            guard let videoConnection = photoOutput.connection(with: .video) else {
                print("video connection \(String(describing: photoOutput.connection(with: .video)))")
                print("Could not retrieve video connection")
                return
            }
            videoConnection.videoOrientation = .portrait
            print("phot capture photo")
            photoOutput.capturePhoto(with: settings, delegate: self)
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                print("Error capturing photo: \(error.localizedDescription)")
                return
            }
            print("Photo captured successfully")
            
            guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
                print("Error converting captured photo to UIImage")
                return
            }
            
            parent.takenPhotos.append(image)
            print("Image added to takenPhotos array")
        }
    }

}
