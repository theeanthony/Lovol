//
//  EditGroupProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/1/23.
//

import SwiftUI

struct EditGroupProfileView: View {
    
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
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State var isLoading : Bool = true
    @State private var teamName : String = ""
    @State private var teamMotto : String = ""
//    @State private var teamCity : String = ""
//    @State private var long : Double = 0
//    @State private var lat : Double = 0
    @State private var editLoading : Bool = false
    @State private var initialTeamName : String = ""
    @State private var initialTeamMotto : String = ""
    @State private var initialTeamCity : String = ""
    @State private var initialLong : Double = 0
    @State private var initialLat : Double = 0

    @State private var picture : UIImage = UIImage()
    @State private var InitialPicture : UIImage = UIImage()

    @State var picturesModified : Bool = false
    @State private var showContentTypeSheet: Bool = false
    @State private var showError: Bool = false
//    @State private var showRemoveConfirmation: Bool = false
//    @State private var showPicDeleteError: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var showPermissionDenied: Bool = false
    let groupId: String
    @State private var confirmRemoveImageIndex: Int = 0
    @State private var selectedContentType: UIImagePickerController.SourceType = .photoLibrary

    @State private var alreadyAppeared : Bool = false
    
    @State private var isPresented : Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            HStack{
                Spacer()

                VStack{
                    if isLoading {
                        ProgressView()
                    }else{
                        Spacer()
                        ScrollView{
                            
                            Image(uiImage: picture)
                                .resizable()
                                .centerCropped()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fit)
                                .frame(width:geo.size.width * 0.3, height:geo.size.width * 0.3)
                            Button {
                                showContentTypeSheet.toggle()
                            } label: {
                                Text("Change")
                                    .font(.custom("Rubik Bold", size: 12))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                            }
                            .padding()

                            
//                            VStack{
//                                HStack{
//                                    Text("Team Name")
//                                        .font(.custom("Rubik Regular", size: 12))
//                                        .foregroundColor(.white)
//                                        .padding(10)
//                                    Spacer()
//                                }
//                                .padding(.leading,5)
//
//                                Button {
//
//                                } label: {
//                                    NavigationLink(destination: EditStringView(name:$teamName,isTeam: true)) {
//                                        HStack{
//                                            Text(teamName)
//                                                .font(.custom("Rubik Regular", size: 16))
//                                                .foregroundColor(.white)
//                                                .padding(10)
//
//                                            Spacer()
//                                            Image(systemName:"chevron.right")
//                                                .foregroundColor(.white)
//                                                .padding(.trailing,10)
//
//                                        }
//                                        .frame(width:geo.size.width)
//                                        .background(AppColor.lovolDarkPurple.opacity(0.3))
//                                    }
//
//                                }
//
//
//
//                            }
                            VStack{
                                HStack{
                                    Text("Team Motto")
                                        .font(.custom("Rubik Regular", size: 12))
                                        .foregroundColor(.white)
                                        .padding(10)
                                    Spacer()
                                }
                                .padding(.leading,5)


                            }
                            Button {
                                isPresented = true 
                            } label: {
                                    HStack{
                                        Text(teamMotto)
                                            .font(.custom("Rubik Regular", size: 16))
                                            .foregroundColor(.white)
                                            .padding(10)

                                        Spacer()
                                        Image(systemName:"chevron.right")
                                            .foregroundColor(.white)
                                            .padding(.trailing,10)
                                    }
                                    .frame(width:geo.size.width)
                                    .background(AppColor.lovolDarkPurple.opacity(0.3))
                       
                            }

    //                        }

                        }
                        Button {
                            save()
                        } label: {
                            Text("Save")
                                .font(.custom("Rubik Bold", size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width:geo.size.width * 0.7)
                                .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                        }
                        .padding(.bottom,15)

                    }
                  
                }
                
                
                Spacer()

            }
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            .background(BackgroundView())

          
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
                ImagePicker(sourceType: selectedContentType, selectedImage: $picture)
            }
        
            .fullScreenCover(isPresented: $isPresented, content: {
                EditMottoView(name:$teamMotto)

            })
            .alert("camera-permission-denied", isPresented: $showPermissionDenied, actions: {}, message: {Text("user-must-grant-camera-permission")})
            .alert("There was an error fetching your team's information. Try Again.", isPresented: $showError, actions: {
                Button("OK", role: .cancel, action: {
     
                })
            })
        }
        .showLoading(editLoading)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchinfo)

    }
    private func picModified() -> Bool {
        if InitialPicture != picture {
            return true
        }
        return false
    }
    private func dictionizeModifiedFields()->[String:Any]{
        var dictionary: [String: Any] = [:]
        
        if initialTeamName != teamName {
            dictionary[FirebaseTeam.CodingKeys.teamName.rawValue] = teamName

        }
        if initialTeamMotto != teamMotto {
            dictionary[FirebaseTeam.CodingKeys.teamDescription.rawValue] = teamMotto

        }
     
        return dictionary
        
        
    }
    private func fieldsModified() -> Bool {
        if initialTeamName != teamName || initialTeamMotto != teamMotto{
            return true
        }
        return false
    }

    private func onCompletion(result: Result<Void, DomainError>){
//        editLoading = false
        switch result{
        case .success(_):
            editLoading = false
            presentationMode.wrappedValue.dismiss()
            print("updating profile")
       
           
        case .failure(let error):
            print("Error updating profile \(error)")
            editLoading = false 
            showError = true
            return
        }
    }
    private func save(){
     
        editLoading = true
        if fieldsModified() && picModified(){
            print("here")
            profileViewModel.updateGroupProfile(groupId: groupId, modified: dictionizeModifiedFields(), pictures: [picture], previousPicCount: 1, onCompletion: onCompletion)
        }else if fieldsModified(){
            print("tere")

            profileViewModel.updateGroupProfile(groupId:groupId,modified: dictionizeModifiedFields(), onCompletion: onCompletion)
        }
        else if picModified(){
            print("sere")

            profileViewModel.updateGroupProfilePics(groupId: groupId, pictures: [picture], previousPicCount: 1, onCompletion: onCompletion)
        }
        
    }
    private func fetchinfo(){
//        profileViewModel.fetchMember { result in
//            switch result{
//            case .success(let member):
//                let groupId = member.groupId
        if alreadyAppeared {
            return
        }
        self.alreadyAppeared = true
                profileViewModel.fetchTeam(id: groupId) { result in
                    switch result{
                    case .success(let team):
                        self.teamName = team.teamName
                        self.teamMotto = team.teamDescription
                        self.initialTeamName = teamName
                        self.initialTeamMotto = teamMotto
                        profileViewModel.fetchGroupMainPicture(profileId: groupId) { result in
                            switch result {
                            case .success(let image):
                                self.picture = image
                                self.InitialPicture = picture
                                
                                isLoading = false
                            case .failure(let error):
                                print("error fetching pictures \(error)")
                                isLoading = false
                            }
                            
                            
                        }
                    case .failure(let error):
                        print("error fetching team \(error)")
                        showError = true
                        presentationMode.wrappedValue.dismiss()
                        return
                    }
                }
        
                
                
      
            
        }
    }


//struct EditGroupProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditGroupProfileView()
//    }
//}
