//
//  CreateGroupPicturesView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct CreateGroupPicturesView: View {
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
    var name: String
    var bio : String
    var college : String
   var occupation : String

    @State private var pictures: [UIImage] = []
    @State private var image = UIImage()
    @State private var selectedContentType: UIImagePickerController.SourceType = .photoLibrary

    @State private var showImagePicker: Bool = false
    @State private var showContentTypeSheet: Bool = false
    @State private var showError: Bool = false
    @State private var showRemoveConfirmation: Bool = false
    @State private var showPermissionDenied: Bool = false

    @State private var confirmRemoveImageIndex: Int = 0
    @State private var droppedOutside: Bool = false
    @State private var showWarning : Bool = false
    

    

//
    var body: some View {
        NavigationStack{

                VStack{
                        PictureGridView(pictures: $pictures, droppedOutside: $droppedOutside, onAddedImageClick: { index in
                            confirmRemoveImageIndex = index
                            showRemoveConfirmation.toggle()
                        }, onAddImageClick: {
                            showContentTypeSheet.toggle()
                        }).padding(.leading).padding(.trailing)
                        

                    Button(action:{
                    }, label: {
                        NavigationLink(destination: CreateGroupInterestsView(name: name, bio: bio, college:college, occupation:occupation, pictures: pictures)) {
                            
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(!checkPictures() ? AppColor.lovolTan :    Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))

                            
                        }
                    })
                    .padding(.top,50)
                    .disabled(checkPictures())
                    .onChange(of: image, perform: {newValue in
                        pictures.append(newValue)
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
                    .alert("camera-permission-denied", isPresented: $showPermissionDenied, actions: {}, message: {Text("user-must-grant-camera-permission")})
                }
                .frame(maxWidth:.infinity,maxHeight:.infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                )
                .onDrop(of: [UTType.text], delegate: DropOutsideDelegate(droppedOutside: $droppedOutside))
                .alert("Upload Error", isPresented: $showError, actions: {}, message: {Text("There was an error while trying to upload your profile. Please, try again later")})
                .alert("Remove this picture?", isPresented: $showRemoveConfirmation, actions: {
                    Button("Yes", action: removePicture)
                    Button("Cancel", role: .cancel, action: {})
                })
                .navigationBarTitle("")
                .toolbar {
                   ToolbarItemGroup(placement: .principal) {
                       Text("Choose Pictures")
                           .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

                   }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func removePicture(){
        pictures.remove(at: confirmRemoveImageIndex)
    }
    private func checkPictures() -> Bool {
        if pictures.count < 3 {
            return true
        }
        return false
    }

}

struct CreateGroupPicturesView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupPicturesView(name: "", bio: "", college: "", occupation: "")
    }
}
