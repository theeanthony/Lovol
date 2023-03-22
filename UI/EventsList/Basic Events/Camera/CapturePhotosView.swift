


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
    @State private var takenVideo : URL?
    
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
    @State private var confirmedSubmission : Bool = false
    @State private var editingVideo : Bool = false
    
    @State private var askForConfirmation: Bool = false
    
    @State private var videoTaken : Bool = false
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
                    Text("Utilize 1 - 6 photos and or 10 second video.")
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
                                .clipShape(RoundedRectangle(cornerRadius:10))
                                .overlay(RoundedRectangle(cornerRadius:10).stroke(.white,lineWidth:1))
                        }
                        
                    }
                    if let takenVideo = takenVideo {
                        Button {
                            self.editingVideo = true
                        } label: {
                            ZStack {
                                if let thumbnail = generateThumbnail(for: takenVideo) {
                                    Image(uiImage: thumbnail)
                                        .resizable()
                                        .centerCropped()
                                } else {
                                    // Display placeholder image
                                    Image(systemName: "play.circle")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1))
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
                    
                }

            else{
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
            
            if !takenPhotos.isEmpty || videoTaken  {
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
            EventImagePicker(sourceType:selectedContentType, selectedImage: $takenPhoto,selectedVideo:$takenVideo)
        }
        .fullScreenCover(isPresented: $askForConfirmation) {
            ConfirmImages(videos:takenVideo!,images:takenPhotos, event: event, reviewSheet: $reviewSheet,totalPointsEarned:$totalPointsEarned,isCelebrationPresent:$isCelebrationPresent, confirmedSubmission:$confirmedSubmission)
        }
        .onChange(of: takenPhoto) { newValue in

            if newValue != initialPhoto {
                takenPhotos.append(newValue)
            }

            self.takenPhoto = initialPhoto
        }
        .onChange(of: takenVideo) { newValue in
            guard let newVideo = newValue else { return } // check if newValue is nil
            self.videoTaken = true
            self.takenVideo = newValue
        }

        .onChange(of: confirmedSubmission, perform: { newValue in
            if newValue{
                presentationMode.wrappedValue.dismiss()
            }
        })
        .alert("Do you want to delete this picture?", isPresented: $editingPicture, actions: {
            Button("Yes", role: .destructive, action: {
                takenPhotos.remove(at: editIndex)
                self.editingPicture = false
                

            })
            .alert("Do you want to delete this picture?", isPresented: $editingVideo, actions: {
                Button("Yes", role: .destructive, action: {
                    self.takenVideo = nil 
                    self.editingVideo = false
                    
                    
                })
            })
            Button("No",role:.cancel, action:{
                self.editingPicture = false
                
            })
        })

        .alert("Only a maximum of 6 photos are allowed", isPresented: $noMorePhotosError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .alert("Only one video per", isPresented: $noMorePhotosError, actions: {
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

   
}

