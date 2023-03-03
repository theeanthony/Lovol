//
//  SixthCreateView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/6/22.
//

import SwiftUI
import UniformTypeIdentifiers


struct SixthCreateView: View {
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

    var count: Int
    var questions: [String]
    var name: String
    var pronouns: String
    var bio : String
    var birthDate : Date
    var college : String
   var occupation : String
    var gender : String
    
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
                    ProfileSection(questions[count]){
                        PictureGridView(pictures: $pictures, droppedOutside: $droppedOutside, onAddedImageClick: { index in
                            confirmRemoveImageIndex = index
                            showRemoveConfirmation.toggle()
                        }, onAddImageClick: {
                            showContentTypeSheet.toggle()
                        }).padding(.leading).padding(.trailing)
                        
                    }

                    Button(action:{
                    }, label: {
                        NavigationLink(destination: EigthCreateView(count: count + 1, questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college:college, occupation:occupation,gender: gender, pictures: pictures)) {
                            
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
                    LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
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

struct SixthCreateView_Previews: PreviewProvider {
    static let questions : [String] = ["Name...", "Who are you...?", "What is your birth date...", "What University do you attend", "What is your occupation...?", "What do you identify as...?", "What is your sexual preference...?", "Please upload 3 pictures...", "If you have a solid friend group and never intend on using this app to find new friends, feel free to skip customizing your interests and hobbies to discover similar people.", "What are your interest/hobbies? Please choose 3-6.", "Let's dig deeper into how committed you are into your interests. Please slide the bar to how interested you are. "]
    static var previews: some View {
        SixthCreateView(count: 7, questions: questions, name: "ant", pronouns: "", bio: "", birthDate: Date(), college: "", occupation: "", gender: "")
    }
}
