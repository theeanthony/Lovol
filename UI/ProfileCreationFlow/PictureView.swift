//
//  PictureView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct PictureView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.white)
                  
              }
          }
      }
//    let email : String

    let name: String
    let role: String
    let age : Bool 
    @State private var initialImage : UIImage = UIImage()
    @State private var uploadedImage : UIImage = UIImage()
    
    
    @State private var uploadPictureSheet : Bool = false
    @State private var showPermissionDenied : Bool = false
    @State private var showImagePicker : Bool = false
    @State private var selectedContentType: UIImagePickerController.SourceType =
        .photoLibrary
    @State private var questionSheet : Bool = false
    var body: some View {
        NavigationStack{
            GeometryReader {geo in
                VStack{
                    Text("Upload a Picture of You")
                        .font(.custom("Rubik Regular", size: 26)).foregroundColor(.white)
                        
                    Button {
                        uploadPictureSheet.toggle()
                    } label: {
                        if uploadedImage == initialImage {
                            Image(systemName:"person.crop.circle.fill")
                                .resizable()
                                .centerCropped()
                                .foregroundColor(.gray)
                                .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.3)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(.gray,lineWidth:2)
                                )
                                .padding(.bottom,20)
                        }else{
                            Image(uiImage: uploadedImage)
                                .resizable()
                                .centerCropped()
                                .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.3)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(.black,lineWidth:2)
                                )
                                .padding(.bottom,20)
                        }
                     
                    }
                    .padding(.bottom,40)

                        Button {
                            
                        } label: {
                            NavigationLink(destination: CreateJoinTeamView(name:name, role:role,pic:uploadedImage, age: age)) {
                                Text("Next")
                                    .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)

                                    .padding()
                                    .frame(width:geo.size.width * 0.7)
                                    .background(RoundedRectangle(cornerRadius: 30).fill( initialImage != uploadedImage ? AppColor.lovolPinkish : AppColor.lovolPinkish.opacity(0.5)))
                            }
                     
                        }
                        .disabled(initialImage == uploadedImage)
                    
                }
                .font(.custom("Rubik Regular", size: 28)).foregroundColor(.white)
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(AppColor.lovolDark)

            .navigationBarTitle("")
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack{
                        Spacer()
                        Button {
                            questionSheet = true 
                        } label: {
                            Image(systemName: "questionmark.circle.fill").foregroundColor(.white)
                        }
                    }
                    
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $uploadPictureSheet){
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
                ImagePicker(sourceType: selectedContentType, selectedImage: $uploadedImage)
            }
            .sheet(isPresented: $questionSheet) {
                                QuestionSheet()
                                    .presentationDetents([ .medium])
                                        .presentationDragIndicator(.hidden)
                
                
            }
            .onAppear(perform: onAppear)
        }
    }
    private func onAppear(){
        initialImage = uploadedImage
    }
        

}

//struct PictureView_Previews: PreviewProvider {
//    static var previews: some View {
//        PictureView(name: "Ant", role: "I do nothing", age: false)
//    }
//}
