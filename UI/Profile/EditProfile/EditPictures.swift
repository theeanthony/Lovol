//
//  EditPictures.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct EditPictures: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(AppColor.lovolTan)
                  
              }
          }
      }
    @Binding var picturesModified : Bool
    @State private var showContentTypeSheet: Bool = false
    @State private var showError: Bool = false
    @State private var showRemoveConfirmation: Bool = false
    @State private var showPicDeleteError: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showPermissionDenied: Bool = false
    
    @State private var confirmRemoveImageIndex: Int = 0
    @State private var selectedContentType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var pictures: [UIImage]
    @State private var image = UIImage()
    @State private var droppedOutside: Bool = false
//    @State private var previousPicCount: Int = 0

    var body: some View {
        NavigationStack{
            VStack{
                Text("The first picture will be your profile picture.")
                    .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolTan)
                    .padding(15)
                PictureGridView(pictures: $pictures, picturesChanged: $picturesModified, droppedOutside: $droppedOutside, onAddedImageClick: { index in
                    confirmRemoveImageIndex = index
                    showRemoveConfirmation.toggle()
                }, onAddImageClick: {
                    showContentTypeSheet.toggle()
                }).padding(.leading).padding(.trailing)
                    .padding(.bottom,15)
                
                Button {
                    done()
                } label: {
                    Text("done")
                        .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolTan)

                }

            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
//            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Edit Pictures")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            
            .onChange(of: image, perform: {newValue in
                pictures.append(newValue)
                picturesModified = true
            })
            .sheet(isPresented: $showContentTypeSheet){
                ContentTypeView(onContentTypeSelected: { contentType in
                    switch contentType{
                    case .permissionDenied:
                        showPermissionDenied.toggle()
                        return
                    case .contentType(let sourceType):
                        self.selectedContentType = sourceType
                        showImagePicker.toggle()
                        return
                    }
                })
            }
            .sheet(isPresented: $showImagePicker){
                ImagePicker(sourceType: selectedContentType, selectedImage: $image)
            }
            .alert("pic-delete-error", isPresented: $showPicDeleteError, actions: {}, message: {Text("pic-delete-error-msg")})
            .alert("camera-permission-denied", isPresented: $showPermissionDenied, actions: {}, message: {Text("user-must-grant-camera-permission")})
            .alert("upload-error", isPresented: $showError, actions: {}, message: {Text("error-uploading-profile")})
            .alert("remove-confirmation", isPresented: $showRemoveConfirmation, actions: {
                Button("yes", action: removePicture)
                Button("cancel", role: .cancel, action: {})
            })

        }
    }
    private func removePicture(){
        if pictures.count <= 2 {
            showPicDeleteError = true
        } else{
            pictures.remove(at: confirmRemoveImageIndex)
            picturesModified = true
        }
    }
    func done(){
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditPictures_Previews: PreviewProvider {
    @State static var picturesModified: Bool = false
    @State static var pictures: [UIImage] = []
    static var previews: some View {
        EditPictures(picturesModified: $picturesModified, pictures:$pictures)
    }
}
