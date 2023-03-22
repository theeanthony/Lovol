//
//  EditGroupProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/1/23.
//

import SwiftUI

struct EditSoloProfileView: View {
    
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
    @State private var name : String = ""
    @State private var role : String = ""
    @State private var age : Bool = false

    @State private var initialAge : Bool = false

    @State private var intitialName : String = ""
    @State private var initialRole : String = ""
//    @State private var initialTeamCity : String = ""
//    @State private var initialLong : Double = 0
//    @State private var initialLat : Double = 0

    @State private var picture : UIImage = UIImage()
    @State private var InitialPicture : UIImage = UIImage()

    @State var picturesModified : Bool = false
    @State private var showContentTypeSheet: Bool = false
    @State private var showError: Bool = false
//    @State private var showRemoveConfirmation: Bool = false
//    @State private var showPicDeleteError: Bool = false
    @State private var showImagePicker: Bool = false
//    @State private var showPermissionDenied: Bool = false
    
    @State private var confirmRemoveImageIndex: Int = 0
    @State private var selectedContentType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var showPermissionDenied : Bool = false
    @State private var editLoading :Bool = false
    
    @State private var alreadyAppeared : Bool = false
    

    
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

                            
                            VStack{
                                HStack{
                                    Text("Nickname")
                                        .font(.custom("Rubik Regular", size: 12))
                                        .foregroundColor(.white)
                                        .padding(10)
                                    Spacer()
                                }
                                .padding(.leading,5)
                                
                                Button {
                                    
                                } label: {
                                    NavigationLink(destination: EditStringView(name:$name,isTeam: false)) {
                                        HStack{
                                            Text(name)
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
                         
                                }

              

                            }
                            VStack{
                                HStack{
                                    Text("Role")
                                        .font(.custom("Rubik Regular", size: 12))
                                        .foregroundColor(.white)
                                        .padding(10)
                                    Spacer()
                                }
                                .padding(.leading,5)


                            }
                            Button {
                                
                            } label: {
                                NavigationLink(destination: EditRoleView(name:$role)) {
                                    HStack{
                                        Text(role)
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
                       
                            }

                        


                            VStack{
                                HStack{
                                    Text("Over 21?")
                                        .font(.custom("Rubik Regular", size: 12))
                                        .foregroundColor(.white)
                                        .padding(10)

                                    Spacer()
                                }
                                .padding(.leading,5)


                            }
                            Button {

                            } label: {
                                NavigationLink(destination: EditAgeView(over21: $age)) {
                                    HStack{
                                        Text(age ? "Yes" : "No")
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
               
                            }

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

            .showLoading(editLoading)
        }
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
        .alert("camera-permission-denied", isPresented: $showPermissionDenied, actions: {}, message: {Text("user-must-grant-camera-permission")})
        .alert("There was an error fetching your information. Try Again.", isPresented: $showError, actions: {
            Button("OK", role: .cancel, action: {
 
            })
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: fetchSoloInfo)
    }
    private func fieldsModified() -> Bool {
        if intitialName != name || initialAge != age || initialRole != role {
            return true
        }
        return false
    }
    private func picModified() -> Bool {
        if InitialPicture != picture {
            return true
        }
        return false
    }
    private func dictionizeModifiedFields()->[String:Any]{
        var dictionary: [String: Any] = [:]
        
        if intitialName != name {
            dictionary[FireMember.CodingKeys.name.rawValue] = name

        }
        if initialRole != role {
            dictionary[FireMember.CodingKeys.role.rawValue] = role

        }
        if initialAge != age {
            dictionary[FireMember.CodingKeys.over21.rawValue] = age

        }
        return dictionary
        
        
    }
    private func onCompletion(result: Result<Void, DomainError>){
        editLoading = false
        switch result{
        case .success(_):
            print("updating profile")
            presentationMode.wrappedValue.dismiss()
            return
           
        case .failure(let error):
            print("Error updating profile \(error)")
            showError = true
            return
        }
    }
    private func save(){
     
        editLoading = true
        if fieldsModified() && picModified(){
            profileViewModel.updateUserProfile(modified: dictionizeModifiedFields(), pictures: [picture], previousPicCount: 1, onCompletion: onCompletion)
        }else if fieldsModified(){
            profileViewModel.updateUserProfile(modified: dictionizeModifiedFields(), onCompletion: onCompletion)
        }
        else if picModified(){
            profileViewModel.updateUserProfile(pictures: [picture], previousPicCount: 1, onCompletion: onCompletion)
        }
        
    }
    private func fetchSoloInfo(){
        if alreadyAppeared {
            return
        }
        self.alreadyAppeared = true
        profileViewModel.fetchMember { result in
            switch result{
            case .success(let member):
                self.name = member.name
                self.age = member.over21
                self.role = member.role
                let memberId = member.id
                self.initialAge = age
                self.intitialName = name
                self.initialRole = role
                profileViewModel.fetchMainPicture(profileId: memberId) { result in
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
                print("error fetching member \(error)")
                showError = true
                presentationMode.wrappedValue.dismiss()
                return
            }
        }
    }
}

struct EditSoloProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditSoloProfileView()
    }
}
