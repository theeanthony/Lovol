//
//  NewToGameView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct NewToGameView: View {
    
    
    @EnvironmentObject private var requestViewModel : RequestViewModel
    @EnvironmentObject private var profileViewModel : ProfilesViewModel

    @State private var joinTeamSheet : Bool = false
    @State private var createTeamSheet : Bool = false
    
    @State private var waitingTeamName : String = ""
    let name : String
    let id: String
    let role : String
    
    
    @State private var teamInfo : TeamModel = TeamModel(teamName: "", teamDescription: "", teamRule: false,city:"",long:0,lat:0)
    @Binding  var teamCreatedOption : Bool
    
    @State private var teamPic : UIImage = UIImage()
    
    @State private var requests : RequestModel = RequestModel(id: "", sendingRequestId: "", nameOfSender: "", groupId: "", sendRole: "", isATeam: false )
    
    @State private var sentRequest : Bool = false
    
    @State private var allianceSearch : AllianceModel = AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
    
    
    @State private var loading : Bool = false
    

    var body: some View {
        GeometryReader{ geo in
            
            VStack{
      
                    Section(header:ListHeader(text: "Search for a team to join")){
                        JoinTeamSheetView(waitingTeamName: $waitingTeamName, sentRequest:$sentRequest)
                    }
                    .padding(.horizontal,10)
                    .padding(.top,25)
         
                
                
                Spacer()
                
    
                if loading {
                    ProgressView()
                    
                }
                else{
                    
                    if !allianceSearch.groupId.isEmpty{
                        Section(header:ListHeader(text: "Pending")){
                            
                            HStack{
                                Image(uiImage: allianceSearch.teamPic)
                                    .resizable()
                                    .centerCropped()
                                
                                    .frame(width: geo.size.width * 0.1, height: geo.size.width * 0.1)
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                Text(allianceSearch.teamName).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                Spacer()
                                Button {
                                    
                                } label: {
                                    NavigationLink(destination: AllianceFullFrameView(alliance: allianceSearch)) {
                                        Text("View Profile")
                                            .padding(5)
                                            .background(RoundedRectangle(cornerRadius: 30).fill(.white).opacity(0.6))
                                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                    }

                                }

               
                                
                                Spacer()
                                
                                Button {
                                    cancelRequest()
                                } label: {
                                    Image(systemName:"xmark").foregroundColor(.white)
                                    
                                }
                                
                                
                            }
                            .padding(.horizontal,15)
                            
                            
                            
                            
                        }
                        .padding(.horizontal,10)
                        .padding(.bottom,35)
                    }
                }
             

        

            }
 
            .sheet(isPresented: $createTeamSheet) {
                CreateTeamSheetView( userName: name, role: role, createdInFlow: false, teamInfo: $teamInfo, teamCreatedOption: $teamCreatedOption, teamPic: $teamPic)
                    .presentationDetents([ .large])
//                        .presentationDragIndicator(.hidden)
                

            }

            .toolbar{
                ToolbarItemGroup(placement:.navigationBarTrailing){
                    Button {
                        createTeamSheet.toggle()
                    } label: {
                        Image(systemName:"plus").foregroundColor(.white)

                    }

                }
            }
            .onAppear(perform:onAppear)
            
        }
    }
    private func cancelRequest(){
        requestViewModel.cancelRequest {
            self.waitingTeamName = ""
            self.sentRequest = false

        }
    }
    private func onAppear(){
        requestViewModel.fetchRequestForClient { result in
            switch result{
            case .success(let request):
                self.requests = request
            
                if !request.groupId.isEmpty{
                    profileViewModel.searchAlliance(id: request.groupId) { request in
                        switch request{
                        case .success(let alliance):
                            self.allianceSearch = alliance
                            
                        case .failure(let error):
                            print("error searching alliance after fetching request \(error)")
                        }
                    }
                }

                
      
            case .failure(let error):
                print("error fetching requests \(error)")
            }
        }
    }
}
