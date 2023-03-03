//
//  CreateTeamSheetView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI
import ContactsUI

struct CreateTeamSheetView: View {
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
    @EnvironmentObject private var profileViewModel : ProfilesViewModel

    @State private var name : String = ""
    @State private var bio : String = ""

    @State private var charLimit : Int = 20
    @State private var bioLimit : Int = 50
    
    @State private var choiceOfRule : Bool = true
    
    @State private var initialimage : UIImage = UIImage()
    @State private var uploadedImage : UIImage = UIImage()
    
    @State private var imageSheetView : Bool = false
    
    @State private var teamNameQuestionSheet : Bool = false
    @State private var teamMottoQuestionSheet : Bool = false
    @State private var teamRuleQuestionSheet : Bool = false
    
    @State private var completedQuestionsWarning : Bool = false
    @State private var uploadPictureSheet : Bool = false
    @State private var showPermissionDenied : Bool = false
    @State private var showImagePicker : Bool = false
    @State private var selectedContentType: UIImagePickerController.SourceType = .photoLibrary
    
    let userName : String
    let role : String
    let createdInFlow : Bool
    
    @Binding var teamInfo : TeamModel
    @Binding var teamCreatedOption : Bool
    @Binding var teamPic : UIImage
    
    @State private var loading : Bool = false
    
    @State private var groupCreateError : Bool = false
    
    @State private var city: String = ""
    @State private var long : Double = 0
    @State private var lat : Double = 0



    var body: some View {
        GeometryReader {geo in
            
            VStack{
                if loading {
                    ProgressView()
                }
                ScrollView{
               
                    HStack{
                        Text("Team Name").font(.custom("Rubik Regular", size: 14)).foregroundColor(.white).tracking(2.4).multilineTextAlignment(.center)
                        //Available in iOS 14 only
                        Button {
                            teamNameQuestionSheet.toggle()
                        } label: {
                            Image(systemName: "questionmark.circle.fill").foregroundColor(.white)

                        }

                        Spacer()
                    }
                    .padding(.leading,15)
                    .padding(.top,20)
                    HStack{
                        TextField("", text: $name, axis:.horizontal)
                            .lineLimit(1)
.placeholder(when: name.isEmpty) {
                            Text("Team Name").opacity(0.5).foregroundColor(.white)
                        }                        .lineLimit(1)

.onChange(of: name, perform: {newValue in
                            if(newValue.count >= charLimit){
                                name = String(newValue.prefix(charLimit))
                            }
                        })
                        .lineLimit(1)

                        Text("\(charLimit - name.count)").foregroundColor(.white).font(.headline).bold()
                            .padding(.trailing,5)
                        
                    }
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                    .padding(.leading,10)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .lineLimit(1)
                    
//                    .frame(width: geo.size.width * 0.9, height:100)
                    .padding()
                    HStack{
                        Text("Team Motto").font(.custom("Rubik Regular", size: 14)).foregroundColor(.white).tracking(2.4).multilineTextAlignment(.center)
                        //Available in iOS 14 only
                        Button {
                            teamMottoQuestionSheet.toggle()

                        } label: {
                            Image(systemName: "questionmark.circle.fill").foregroundColor(.white)

                        }
                        Spacer()
                    }
                    .padding(.leading,15)
                    HStack{
                        TextField("", text: $bio, axis:.horizontal)
                            .lineLimit(1)
.placeholder(when: bio.isEmpty) {
                            Text("Team Motto").opacity(0.5).foregroundColor(.white)
                        }                        .lineLimit(1)
.onChange(of: bio, perform: {newValue in
                            if(newValue.count >= bioLimit){
                                bio = String(newValue.prefix(bioLimit))
                            }
                        })
                        .lineLimit(1)

                        Text("\(bioLimit - bio.count)").foregroundColor(.white).font(.headline).bold()
                            .padding(.trailing,5)
                        
                    }
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                    .padding(.leading,10)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .lineLimit(1)

//                    .frame(width: geo.size.width * 0.9, height:150)
//                    .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
                    .padding()
                    

                    Button {
                       uploadPictureSheet = true

                    } label: {
                        VStack{
                            HStack{
                                Spacer()
                                Text( initialimage == uploadedImage ? "Upload Team Picture" : "Change Team Picture").font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                //Available in iOS 14 only
                                Spacer()
                            }
                            .padding(.leading,15)
                            if initialimage != uploadedImage  {
                                Image(uiImage: uploadedImage)
                                    .resizable()
                                    .centerCropped()
                                    .frame(width: 100, height: 100)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle().stroke(.white,lineWidth:2)
                                    )
                                    .padding(.bottom,20)
                                
                                
                            }
                            else{
                               Circle().stroke(.white,lineWidth:2)
                                    .frame(width: 100, height:  100)
                                    .padding(.bottom,20)
                                
                                
                            }
                        }
     
                    }
                    
                }
                .frame(width:geo.size.width,height:geo.size.height * 0.9)
                
                Button {
                    
                    createTeam()
                } label: {
                    Text("Create")
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)

                        .padding()
                        .frame(width:geo.size.width * 0.7)

                        .background(RoundedRectangle(cornerRadius:30).fill(AppColor.lovolPinkish))
                }




                
            }
            .sheet(isPresented: $teamNameQuestionSheet) {
                TeamNameQuestionSheetView()
                    .presentationDetents([ .medium])
//                        .presentationDragIndicator(.hidden)
                

            }
            .sheet(isPresented: $teamMottoQuestionSheet) {
                TeamMottoQuestionSheetView()
                    .presentationDetents([ .medium])
//                        .presentationDragIndicator(.hidden)
                

            }
            .sheet(isPresented: $teamRuleQuestionSheet) {
                TeamRuleQuestionView()
                    .presentationDetents([ .medium])
//                        .presentationDragIndicator(.hidden)
                

            }
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.keyboard)
            .frame(width:geo.size.width, height:geo.size.height)
            .background(BackgroundView())
            .onAppear(perform: onAppear)
            .alert("Please make sure to fill out team name, team motto, and upload a picture.", isPresented: $completedQuestionsWarning, actions: {
                Button("OK", role: .cancel, action: {
     
                })
            })
            .alert("There was an error creating the team. Try again?", isPresented: $groupCreateError, actions: {
                Button("OK", role: .cancel, action: {
     
                })
            })
            .ignoresSafeArea(.keyboard)
        }
    }

    private func onAppear(){
        initialimage = uploadedImage
    }
    private func questionsCompleted () -> Bool{
        if name.isEmpty || bio.isEmpty || initialimage == uploadedImage {
            return false
        }
        return true
    }
    private func createTeam(){
        if questionsCompleted(){
            let teamModel : TeamModel = TeamModel(teamName: name, teamDescription: bio, teamRule: choiceOfRule,city:city,long:long,lat:lat)
            print("team Model")
            if createdInFlow{
                
                teamInfo = teamModel
                teamPic = uploadedImage
                teamCreatedOption = true
                presentationMode.wrappedValue.dismiss()
                return

                
            }
            loading = true
            let randomId = UUID().uuidString.substring(fromIndex: 26)
            profileViewModel.createTeam(info: teamModel, name:userName, role: role, teamPic: uploadedImage, id: randomId) { result in
                switch result {
                case .success():
                    self.teamCreatedOption = true
                    loading = false

                    presentationMode.wrappedValue.dismiss()
                    return
                case .failure(let error):
                    loading = false
                    groupCreateError = true
                    print("ERror creating group \(error)")
                    
                }
            }
            return
        }else{
            self.completedQuestionsWarning = true
            return
            
        }
    }
}
//
struct CreateTeamSheetView_Previews: PreviewProvider {
    @State static var option : Bool = false
    @State static var teamInfo : TeamModel = TeamModel(teamName: "", teamDescription: "This is a descriotoipn that was purposelfy made to be very long so ic an see how it fits", teamRule: false)
    @State static var teamPic : UIImage = UIImage()
    static var previews: some View {
        CreateTeamSheetView(userName: "rat", role: "", createdInFlow: false, teamInfo: $teamInfo,teamCreatedOption: $option, teamPic: $teamPic )
    }
}
