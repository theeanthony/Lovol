//
//  JoinTeamSheetView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct JoinTeamSheetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var charLimit : Int = 10
    @State private var searchString : String = ""
    
    @State private var teamName : String = ""
    @State private var teamBio : String = ""
    @State private var teamPic : UIImage = UIImage()
    
    @Binding  var waitingTeamName : String
    
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @EnvironmentObject private var requestViewModel : RequestViewModel

    @State private var loadingSearch = false
    @State private var teamExists = false
    @State private var initialSearch = false
    
    @State private var teamMembers : [MemberModel] = []
    @Binding  var sentRequest : Bool
    @State private var duplicateRequest : Bool = false
    
    @FocusState private var textFocused : Bool
    
    @State private var idNotLongEnoughError : Bool = false
    
    @State private var showTeam : Bool = false
    @State private var errorFindingTeam : Bool = false
    
    @State private var allianceSearch : AllianceModel = AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())

    
//    AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
    
    var body: some View {
        GeometryReader{geo in
            VStack{
                
                    HStack{
                        Image(systemName:"magnifyingglass")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: geo.size.width * 0.05, height: geo.size.width * 0.05)
                            .padding(.leading,10)

                        TextField("", text: $searchString, axis:.horizontal)
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                            .textCase(.uppercase)
                            .autocorrectionDisabled(true)
                        //                                .fixedSize(horizontal: true, vertical: false)
                            .placeholder(when: searchString.isEmpty) {
                                Text("Team #ID").opacity(0.5).font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                            }.onChange(of: searchString, perform: {newValue in
                                if(newValue.count >= charLimit){
                                    searchString = String(newValue.prefix(charLimit))
                                }
                            })

                        Spacer()

                    }
                    .padding(.vertical)
                    .frame(width:geo.size.width * 0.9)
                    .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.6))
                    
       
                
                Spacer()
                
                if loadingSearch {
                    HStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }                }else{
                        if showTeam {
                            NavigationLink(destination: AllianceFullFrameView(alliance: $allianceSearch)) {
                                GeometryReader{geo in
                                    HStack{
                                        Image(uiImage: allianceSearch.teamPic)
                                            .resizable()
                                            .centerCropped()
                                        
                                            .frame(width: geo.size.width * 0.1, height: geo.size.width * 0.1)
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                        Text(allianceSearch.teamName).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                        Spacer()
                                        Text("View Profile")
                                            .padding(5)
                                            .background(RoundedRectangle(cornerRadius: 30).fill(.white).opacity(0.6))
                                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                        
                                        Spacer()
                                        Button {
                                            sendRequest()
                                        } label: {
                                            
                                            if sentRequest{
                                                Image(systemName:"person.crop.circle.badge.checkmark")
                                                    .resizable()
                                                    .foregroundColor(.white)
                                                    .frame(width: geo.size.width * 0.05, height: geo.size.width * 0.05)
                                                
                                            }
                                            else{
                                                Image(systemName:"person.crop.circle.badge.questionmark")
                                                            .resizable()
                                                            .foregroundColor(.white)
                                                            .frame(width: geo.size.width * 0.05, height: geo.size.width * 0.05)
                                            }
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    .padding(.horizontal,15)
                                }
                                
                            }
                        }
                        else if errorFindingTeam{
                            VStack{
                                Text("No Teams")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            }
                        }
                }
 
                Spacer()
                
         


            
            }

        

            .ignoresSafeArea(.keyboard)
            .frame(width:geo.size.width, height:geo.size.height)
//            .background(AppColor.lovolDarkPurple)
//            .background(AppColor.lovolDarkPurple)

            .alert("You have already sent a request to join another group. Please cancel before requesting again.", isPresented: $duplicateRequest, actions: {
                Button("OK", role: .cancel, action: {
     
                })
            })
            .alert("Please input the team's 10 character ID.", isPresented: $idNotLongEnoughError, actions: {
                Button("OK", role: .cancel, action: {
     
                })
            })
   
            .onChange(of: searchString) { newValue in
                
                self.searchString = newValue.uppercased()
                if newValue.count == 10 {
                    print("Search string \(searchString)")
                    searchString = newValue.uppercased()

                    searchTeam()
                }
                else{
                    showTeam = false
                    errorFindingTeam = false
                }
            }
     
        }
    }

    private func sendRequest(){
        searchString = searchString.uppercased()

        requestViewModel.sendRequest(groupId: searchString) { result in
            switch result {
            case .success(true):
                self.sentRequest = true
                self.waitingTeamName = searchString
                print("Sent request team name \(searchString) and \(teamName)")
//                presentationMode.wrappedValue.dismiss()
            case .success(false):
                duplicateRequest = true
            case .failure(let error):
                print("error sending request \(error)")
                
            }
        }
    }
    private func onDisappear(){
        self.teamMembers = []
    }
    private func searchTeam(){
        showTeam = false
        errorFindingTeam = false

        if searchString.count != 10 {
            idNotLongEnoughError = true
            return
        }
        loadingSearch = true
//        initialSearch = true
        searchString = searchString.uppercased()
        profileViewModel.searchAlliance(id: searchString) { result in
            switch result {
                
            case .success(let fetchedAlliances):
                self.allianceSearch = fetchedAlliances
                showTeam = true
//                sentRequest = true
                loadingSearch = false
            case .failure(let error):
                print("error fetching alliances \(error)")
                loadingSearch = false
                errorFindingTeam = true
                return
                
            }
        }
    }
        

}

//struct JoinTeamSheetView_Previews: PreviewProvider {
//    @State static var waitingTeamName : String = "Anthonny Team"
//    static var previews: some View {
//        JoinTeamSheetView(waitingTeamName: $waitingTeamName)
//    }
//}


/// fixed requests view model, had collection groupv1
/// right now i believe i have to fix the groupo display layout, but bio on the bottom below the members view, or jsut combine the views all togtehr so that they dont go over each other 
