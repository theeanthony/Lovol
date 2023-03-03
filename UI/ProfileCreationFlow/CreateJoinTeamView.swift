//
//  CreateJoinTeamView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/18/23.
//

import SwiftUI

struct CreateJoinTeamView: View {
    
    @EnvironmentObject private var authViewModel : AuthViewModel
    @EnvironmentObject private var profileViewModel : ProfilesViewModel

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
    @State private var teamSheet : Bool = false
    @State private var joinSheet : Bool = false
    @State private var createSheet : Bool = false
//    let email : String
    let name : String
    let role : String
    let pic : UIImage
    let age : Bool
//    @Binding var number : String
    @State private var waitingTeamName: String = ""
    
 
    @State private var teamInfo : TeamModel = TeamModel(teamName: "", teamDescription: "", teamRule: false, city:"",long:0,lat:0)
    @State private var teamCreatedOption : Bool = false
    @State private var teamPic : UIImage = UIImage()
    
    @State private var invites : [InviteModel] = []
    
    @State private var groupId : String = ""
    
    
    
    @State private var isPresented : Bool = false
    
    @State private var cantCreateTeam : Bool = false
    
    @State private var errorCheckingSize : Bool = false
    @State private var teamFull : Bool = false
    @State private var contactClicked : Bool = false
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                    VStack{
//                        HStack{
//                            Text("Invites")
//                                .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)
//                            Spacer()
//                        }
//                        if invites.isEmpty{
//                            Text("You have no invites.")
//                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
//                                .padding(.bottom,40)
//
//                        }else{
//                            ScrollView{
//
//                                ForEach(invites.indices,id:\.self){
//                                    index in
//
//                                    Button {
//
//                                        if joinGroupId == invites[index].groupId{
//                                            self.joinGroupId = ""
//                                        }else{
//                                            self.joinGroupId = invites[index].groupId
//
//                                        }
//
//                                    } label: {
//                                        HStack{
//                                            Text("\(invites[index].inviteName)")
//                                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
//
//                                            Image(systemName:"arrow.right").foregroundColor(.white)
//
//                                            Text("\(invites[index].teamName)")
//                                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
//
//                                            Spacer()
//
//
//                                            Text(joinGroupId != invites[index].groupId ? "Join" : "Leave")
//                                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
//
//                                                .padding(5)
//                                                .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish.opacity(0.4)))
//
//
//                                        }
//                                    }
//                                    ExDivider(color: .white.opacity(0.6))
//
//                                }
//                            }
//                            .frame(height:geo.size.height * 0.3)
//                        }
      
//                        Spacer()
                        Spacer()

                        Button {
                            
//
                            isPresented = true
                        } label: {
                            HStack{
                                Text(teamCreatedOption ? " Edit \(teamInfo.teamName)" :"Create a Team")
                                    .font(.custom("Rubik Bold", size: 20)).foregroundColor(.white)
                                Spacer()
                                Image(systemName:"arrow.right").foregroundColor(.white)
                            }
                        }
                        .padding(.bottom,20)

  
                        Spacer()
                        Button {
                          
                        } label: {
                            
                            NavigationLink(destination: FinishProfileView(joinGroupId:groupId, name: name, role: role, pic: pic, age: age , teamInfo: $teamInfo, teamPic: teamPic, teamCreatedOption: teamCreatedOption )) {
                                Text( teamCreatedOption ? "Continue" : "Skip")
                                    .padding().frame(width:geo.size.width * 0.7).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                                    .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)

                            }
                       
                        }
                        Spacer()


       

                    }
//                    .font(.custom("Rubik Regular", size: 28)).foregroundColor(.white)
                    .frame(width:geo.size.width * 0.9)
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
                         teamSheet = true
                       } label: {
                           Image(systemName: "questionmark.circle.fill").foregroundColor(.white)
                       }
                   }


               }
            }
            .onChange(of: teamCreatedOption, perform: { newValue in
                if teamCreatedOption{
                    self.groupId = UUID().uuidString.substring(fromIndex: 26)
                }
            })
            .alert("You cannot create a team if you have joined a team. Leave the team before creating a team.", isPresented: $cantCreateTeam, actions: {
                Button("OK", role: .cancel, action: {

                })
            })
            .alert("Error checking the size of the team. Try Again.", isPresented: $errorCheckingSize, actions: {
                Button("OK", role: .cancel, action: {

                })
            })
            .alert("That team is full. Sorry.", isPresented: $teamFull, actions: {
                Button("OK", role: .cancel, action: {

                })
            })
            .sheet(isPresented: $isPresented, content: {
                CreateTeamSheetView( userName: name, role: role, createdInFlow: true, teamInfo: $teamInfo, teamCreatedOption: $teamCreatedOption, teamPic : $teamPic)

            })
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $teamSheet) {
                QuestionTeamSheet()
                    .presentationDetents([ .medium])
                        .presentationDragIndicator(.hidden)
                

            }
//            .sheet(isPresented: $joinSheet) {
//                JoinTeamSheetView(waitingTeamName: $waitingTeamName)
//                    .presentationDetents([ .large])
//                        .presentationDragIndicator(.hidden)
//                
//
//            }
            .sheet(isPresented: $createSheet) {
                CreateTeamSheetView( userName: name, role: role, createdInFlow: true, teamInfo: $teamInfo, teamCreatedOption: $teamCreatedOption, teamPic : $teamPic)
                    .presentationDetents([ .large])
                        .presentationDragIndicator(.hidden)
                

            }
            .onAppear(perform:onAppear)
        }
        
    }

//    private func checkTeamSize(){
//        profileViewModel.checkGroupSize(id: joinGroupId) { result in
//            switch result{
//            case .success(let size):
//
//                if size == 6 {
//                    teamFull = true
//
//                    joinGroupId = ""
//                }
//
//            case .failure(let error):
//                print("error checking size \(error)")
//                joinGroupId = ""
//
//                errorCheckingSize = true
//                return
//            }
//        }
//    }
    private func onAppear(){
//        var newNumber = ""
//        for numbers in number.indices {
//            if number[numbers] == " " || number[numbers] == "(" || number[numbers] == ")" || number[numbers] == "-" {
//                continue
//
//            }else{
//                newNumber.append(number[numbers])
//            }
//        }
//                self.number = "1"+newNumber
//        print(number)
//        authViewModel.checkInvites(number:number) { result in
//            switch result{
//            case .success(let fetchInvites):
//                self.invites = fetchInvites
//                return
//
//            case .failure(let error):
//                print("error \(error)")
//                return
//            }
//        }
    }

}
//
//struct CreateJoinTeamView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateJoinTeamView(name: "Ant", role: "Ant", pic: UIImage(named:"elon_musk")!, age: false)
//    }
//}
