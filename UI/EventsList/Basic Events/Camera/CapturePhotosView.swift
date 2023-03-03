


import SwiftUI
import Foundation
import AVFoundation


//func startSession() {
//    DispatchQueue.global(qos: .userInitiated).async {
//        self.captureSession?.startRunning()
//    }
//}
struct CapturePhotosView : View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var eventViewModel : EventViewModel
    @State var takenPhotos : [UIImage] = []
    @State private var takenPhoto : UIImage = UIImage()
    
    @State private var selectedContentType: UIImagePickerController.SourceType =
        .camera
    @State private var takePicture : Bool = false
    
    @State private var editingPicture : Bool = false
    
    @State private var editIndex : Int = 0
    @State private var noMorePhotosError : Bool = false
    
    @State private var initialPhoto : UIImage = UIImage()
    
    @State private var pictureSubmitted : Bool = false
    
    @State private var uploadError : Bool = false
    @State private var loadingPics : Bool = false
    
    @Binding var totalPointsEarned : Int
    @Binding var reviewSheet : Bool
    @Binding var isCelebrationPresent : Bool
    
    @State private var askForConfirmation: Bool = false
    var maxPhotos : Int = 6
    
    var event : EventModel
    let newColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
     ]
    var body: some View {
        VStack{
            
            Section(header:ListHeader(text: "Rules")){
                VStack{

                    Text(event.eventRules)
                    .padding(.bottom)
                    Text("Only one person from your team has to submit pictures for your team to get lovol bits.")
                    Text("1 - 6 photos are allowed.")
                        .padding(.top)


            }
            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
            .padding(.horizontal)
            }
//            .padding()
            .padding(.top,40)


            
            HStack{
                Spacer()
                LazyVGrid(columns: newColumns, spacing: 10){
                    ForEach(takenPhotos.indices, id: \.self) { photo in
                        Button {
                            self.editIndex = photo
                            self.editingPicture = true
                        } label: {
                            Image(uiImage: takenPhotos[photo])
                                .resizable()
                                .centerCropped()
                                .frame(width:80,height:80)
                                .clipShape(Circle())
                        }
                        
                    }
                    
                }
                
                Spacer()
            }
            .padding()
            Spacer()

            Button {
                
                if takenPhotos.count < 6 {
                    self.takePicture = true

                }else{
                    self.noMorePhotosError = true 
                }
            } label: {
                Image(systemName:"camera.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width:35,height:32)

            }
            .padding()
            Spacer()
            
            if !takenPhotos.isEmpty{
                Button {
                    self.askForConfirmation = true
                } label: {
                    Text("Submit")
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))

                }
            }


            Spacer()

        }
        .background(BackgroundView())
        .overlay(
            VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"chevron.left").foregroundColor(.white)
                        
                    }
                    Spacer()
                }

     
                Spacer()
            }.padding()
        )
        .fullScreenCover(isPresented: $takePicture) {
            ImagePicker(sourceType:selectedContentType, selectedImage: $takenPhoto)
        }
        .onChange(of: takenPhoto) { newValue in

            if newValue != initialPhoto {
                takenPhotos.append(newValue)
            }

            self.takenPhoto = initialPhoto
        }
        .alert("Do you want to delete this picture?", isPresented: $editingPicture, actions: {
            Button("Yes", role: .destructive, action: {
                takenPhotos.remove(at: editIndex)
                self.editingPicture = false
                

            })
            Button("No",role:.cancel, action:{
                self.editingPicture = false
                
            })
        })
        .alert("Confirm that these are the pictures you are submitting.", isPresented: $askForConfirmation, actions: {
            Button("Yes", role: .none, action: {
          
                submitPhoto()

            })
            Button("No",role:.cancel, action:{
                self.askForConfirmation = false
            })
        })
        .alert("Only a maximum of 6 photos are allowed", isPresented: $noMorePhotosError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .onAppear(perform:onAppear)
//        .fullScreenCover(isPresented: $showPhotoTaken) {
//            ShowSinglePhotoView(takenPhoto: $takenPhoto, takenPhotos: $takenPhotos)
//        }
        .showLoading(loadingPics)
    }
    
//    private func capturePhoto(){
//            self.showPhotoTaken = true // show the "photo taken" screen
//
//    }
    private func onAppear(){
        self.initialPhoto = takenPhoto
    }
    private func submitPhoto(){
        
        pictureSubmitted = true
        if takenPhotos.isEmpty {
            return
        }
        
        self.loadingPics = true
        eventViewModel.submitEvent(useMultiplier:false,isGlobal:false,event: event, photo: takenPhotos) { result in
            switch result {

            case .success(let numberOfPoints):
                self.loadingPics = false

                pictureSubmitted = false
                self.totalPointsEarned = numberOfPoints
                print("points in this \(numberOfPoints)")
                reviewSheet = true
                presentationMode.wrappedValue.dismiss()
                self.isCelebrationPresent = true
                self.loadingPics = false

//                dismiss()
            case .failure(let error):
                
                if error == .downloadError{
                    pictureSubmitted = false
                    print("error submitting photo for event \(error)")
                    self.loadingPics = false

                    uploadError = true
                    return
                }
                else {
//                    alreadySubmittedEvent = true
                    self.loadingPics = false
                    pictureSubmitted = false
                }
            }
        }
        
    }

   
}

