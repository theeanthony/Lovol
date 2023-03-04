//
//  Member+Alliances+Requests.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/17/23.
//

import SwiftUI

struct Member_Alliances_Requests: View {
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
    let groupId: String
    let teamInfo: FirebaseTeam
    @State private var searchString : String = ""
    @State private var charLimit : Int = 10
    @State private var showTeam :Bool = false
    @State private var idNotLongEnoughError : Bool = false
    @State private var errorFindingTeam :Bool = false
    @State private var allianceInformation : [AllianceModel] = []
    @State private var allianceSearch : AllianceModel = AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
    @State private var loadingSearch : Bool = false
    @State private var requestSent : Bool = false
    
    @State private var showSearch : Bool = false
    
    @State private var requestSentAlready : Bool = false
    
    @State private var errorSendingRequest : Bool = false

    var body: some View {
        VStack{
            HStack{
                Image(systemName:"magnifyingglass").foregroundColor(.white)
                HStack{
                    
                    TextField("", text: $searchString, axis:.horizontal)
                    //                                .fixedSize(horizontal: true, vertical: false)
                        .placeholder(when: searchString.isEmpty) {
                            Text("Team #ID").opacity(0.5).font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                        }.onChange(of: searchString, perform: {newValue in
                            if(newValue.count >= charLimit){
                                searchString = String(newValue.prefix(charLimit))
                            }
                        })
                    
//                    Text("\(charLimit - searchString.count)").foregroundColor(.white).font(.headline).bold()
//                        .padding(.trailing,5)
                    
                    
                }
                
                Spacer()
            }
            .padding(.vertical)
            .padding(.horizontal,35)
            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.6))
            .padding(.horizontal,10)
            Spacer()
            InviteFriendsLabelView(groupId: groupId)
                .padding(.vertical,20)
            VStack{
                
                if loadingSearch {
                    HStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                if showTeam {
//                    NavigationLink(destination: AllianceFullFrameView(alliance: allianceSearch)) {
                        GeometryReader{geo in
                            HStack{
                                Image(uiImage: allianceSearch.teamPic)
                                    .resizable()
                                    .centerCropped()
                                
                                    .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                Text(allianceSearch.teamName).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                Spacer()
                                Button {
                                    self.showSearch = true 
                                } label: {
                                    Text("View Profile")
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 30).fill(.white).opacity(0.6))
                                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                }
                                .fullScreenCover(isPresented: $showSearch) {
                                    AllianceFullFrameView(alliance: allianceSearch)

                                }
                       
                                
                                Spacer()
                                Button {
                                    sendRequest()
                                } label: {
                                    
                                    if requestSent{
                                        Image(systemName:"person.crop.circle.badge.checkmark")
                                            .foregroundColor(.white)
                                    }else{
                                        Image(systemName:"person.crop.circle.badge.questionmark")
                                            .foregroundColor(.white)
                                    }
                                    
                                    
                                }
                                
                                
                                
                            }
                            .padding(.horizontal,15)
                        }
                        
//                    }
                }
                else if errorFindingTeam{
                    VStack{
                        Text("No Teams")
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                    }
                }
                else{
//                    ScrollView{
                 
                 
                        MemberFrame(groupId: groupId, teamInfo: teamInfo, searchString: $searchString)
                            .padding(.horizontal,5)
//                    }
                }
                Spacer()
            }
       

            
        }
        .ignoresSafeArea(.keyboard)
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(BackgroundView())

        .onChange(of: searchString) { newValue in
            if newValue.count == 10 {
                searchTeam()
            }
            else{
                showTeam = false 
                errorFindingTeam = false
            }
        }
        .alert("Please input the team's 10 character ID.", isPresented: $idNotLongEnoughError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .alert("A request for this alliance has already been sent. Stop.", isPresented: $requestSentAlready, actions: {
            Button("OK", role: .cancel, action: {
 
            })
        })
        .alert("There has been an error sending this request. Try again later.", isPresented: $errorSendingRequest, actions: {
            Button("OK", role: .cancel, action: {
 
            })
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
    }
    func sendRequest(){
        profileViewModel.sendAllianceRequest(id: searchString, sendingTeam: teamInfo){ result in
            switch result{
            case .success(true):
                requestSentAlready = true
                self.requestSent = true

            case .success(false):
                self.requestSent = true
            case .failure(let error):
                print("error fetching requests to check if i can send another request \(error)")
                self.errorSendingRequest = true
                return
            }
        }
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
        
        profileViewModel.searchAlliance(id: searchString) { result in
            switch result {
                
            case .success(let fetchedAlliances):
                self.allianceSearch = fetchedAlliances
                showTeam = true
//                requestSent = true
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
//struct Member_Alliances_Requests_Previews: PreviewProvider {
//    static var previews: some View {
//        Member_Alliances_Requests()
//    }
//}