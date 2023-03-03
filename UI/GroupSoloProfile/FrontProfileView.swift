//
//  FrontProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI
import ContactsUI

struct FrontProfileView: View {
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var eventViewModel : EventViewModel
    @EnvironmentObject private var requestViewModel : RequestViewModel

    let name: String
    let groupId : String
    @State private var teamInfo : FirebaseTeam = FirebaseTeam(id: "", teamName: "", teamDescription: "", teamRule: false, teamPoints: 0, teamMemberNames: [], teamMemberRoles: [], teamMemberIDS: [], suggestedEvents: [], chosenEvent: "", requests: [], achievements: [], alliances: [], exists: false, setTimeForChosenEvent: "", teamLovols: 0, lifeTimeLovols: 0, city: "", long : 0, lat : 0, timeCreated: "", locationSet: false, address: "", lifetimeLovolBits: 0, totalEventsCompleted: 0,multiplier: 0,resurrection: 0,isMember:false)
    @State private var teamPic : UIImage = UIImage()
    @State private var loadingTeamInfo : Bool = true
    
    @State private var fetchingError : Bool = false
    
    @State private var members : [MemberModel] = []
    @State private var suggestedEvents : [EventModelWithLikes] = []
    @State private var chosenEvent : String = ""
    
    @State private var requests : [RequestModelPicture] = []
    
    @State private var trophies : [FirebaseTrophyModel] = []
    @State private var date : Date = Date()
    @State private var alliances : [String] = []
    @State private var isPresent : Bool = false
    
    @State private var teamMembersPresented : Bool = false
    var body: some View {
        
        GeometryReader{geo in
            
            VStack{
                if  loadingTeamInfo {
                    ProgressView()
                }else{
                    Spacer()
                    VStack{
                        ScrollView{
                            ProfileFrameView(teamInfo:teamInfo,  image: teamPic )
                                .frame(height:geo.size.height * 0.65)
                                .padding(.bottom)
                            
                            Section(header:ListHeader(text:"My Team")){
                                VStack(spacing:15){
                                    
                                    Group{
                                        Button {
                                            
                                        } label: {
                                            NavigationLink(destination: EditGroupProfileView(groupId:groupId)) {
                                                HStack{
                                                    Text("Edit Team Info")
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                }
                                            }
                                            
                                        }
                                        
                                        ExDivider(color: .white.opacity(0.5))
                                        Button {
                                            
                                        } label: {
                                            NavigationLink(destination: Member_Alliances_Requests(groupId: groupId, teamInfo:teamInfo)) {
                                                HStack{
                                                    Text("Team Members")
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                        ExDivider(color: .white.opacity(0.5))
                                        Button {
                                            
                                        } label: {
                                            NavigationLink(destination: CompletedEventFeedView(groupId:groupId)) {
                                                HStack{
                                                    Text("Completed Events")
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                }
                                            }
                                        }
                                        
                                        
                                        ExDivider(color: .white.opacity(0.5))
                                        Button {
                                            
                                        } label: {
                                            NavigationLink(destination: StoreView(groupId:groupId)) {
                                                HStack{
                                                    Text("Lovol Store")
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                }
                                            }
                                        }
                                        
//                                        ExDivider(color: .white.opacity(0.5))
//                                        Button {
//
//                                        } label: {
//                                            NavigationLink(destination: AllianceFrameExpanded(alliances:$alliances, teamInfo: teamInfo)) {
//                                                HStack{
//                                                    Text("Alliances")
//                                                    Spacer()
//                                                    Image(systemName: "chevron.right")
//                                                }
//                                            }
//
//
//                                        }
                                    }
                                    Group{
                                        
                                        ExDivider(color: .white.opacity(0.5))
                                        Button {
                                            
                                        } label: {
                                            NavigationLink(destination: LeaderBoardFrame(groupId:groupId)) {
                                                
                                                HStack{
                                                    Text("Leader Board")
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                }
                                            }
                                        }
                                        ExDivider(color: .white.opacity(0.5))
                                        Button {
                                            
                                        } label: {
                                            NavigationLink(destination: FrontHostEventView(groupId:groupId)) {
                                                
                                                HStack{
                                                    Text("Host An Activity")
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                }
                                            }
                                        }
//                                        ExDivider(color: .white.opacity(0.5))
//                                        Button {
//                                            isPresent = true
////                                            inviteContacts()
//                                        } label: {
//                                            NavigationLink(destination: ContactList()) {
//                                                HStack{
//                                                    Text("Invite Contacts")
//                                                    Spacer()
//                                                    Image(systemName: "chevron.right")
//                                                }
//                                            }
//                                        }
                                        
                              
                                        
                                    }
                                    
                                }//end of vstack
                                
                                .padding()
                                .frame(width:geo.size.width * 0.85)
                                .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolPinkish))
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                .padding(.vertical,10)
                                
                                
                            }//end of section
                            
                            .frame(width:geo.size.width * 0.9)

                            
                            
                        }//end of scroll
//                        .frame(width:geo.size.width * 0.95)
                    }//end of vstack
                    .frame(width:geo.size.width, height:geo.size.height * 0.95)
                    
                }
 
            }//end of top vstack
            .frame(width:geo.size.width, height:geo.size.height)
//            .alert("There was an error fetching your team information. Try again?", isPresented: $fetchingError, actions: {
//                Button("OK", role: .cancel, action: {
//
//                })
//            })
            
//
//            .fullScreenCover(isPresented: $isPresent) {
//                ContactListView()
//            }
            .onAppear(perform:populate)
            

        }//end of georeader

        
        
    }

//private func inviteContacts(){
//
//}
    private func fetchTeamPic(){
        profileViewModel.fetchGroupMainPicture(profileId: groupId) { result in
            switch result {
            case .success(let image):
                self.teamPic = image
                loadingTeamInfo = false

                return
            case .failure(let error):
                print("error fetching teampic \(error))")
                loadingTeamInfo = false

            }
        }
    }

    private func populate(){
        if groupId.isEmpty{
            profileViewModel.fetchMember { result in
                switch result{
                case .success(let member):
                    profileViewModel.fetchTeam(id: member.groupId) { result in
                        switch result{
                        case .success(let team):
                            self.teamInfo = team
                            self.chosenEvent = team.chosenEvent
                            self.alliances = team.alliances
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            let dateFromString = dateFormatter.date(from:team.setTimeForChosenEvent)!
                            self.date = dateFromString
                            fetchTeamPic()
                            fillSuggestedEvents(team: team)
            //                fillTrophies(team:team)
            //                fillInInfo(team: team)
            //                fillRequests(groupId: groupId)
                            
                            return
                        case .failure(let error):
                            fetchingError = true
                            print("could not fetch team information \(error)")
                            return
                        }
                    }
                case .failure(let error):
                    print("error fetching member to check group profile \(error)")
                    
                    fetchingError = true
                    return
                    
                }
            }
        }else{
            profileViewModel.fetchTeam(id: groupId) { result in
                switch result{
                case .success(let team):
                    self.teamInfo = team
                    self.chosenEvent = team.chosenEvent
                    self.alliances = team.alliances
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let dateFromString = dateFormatter.date(from:team.setTimeForChosenEvent)!
                    self.date = dateFromString
                    fetchTeamPic()
//                    fillSuggestedEvents(team: team)
    //                fillTrophies(team:team)
    //                fillInInfo(team: team)
    //                fillRequests(groupId: groupId)
                    
                    return
                case .failure(let error):
                    fetchingError = true 
                    print("could not fetch team information \(error)")
                    return
                }
            }
        }

    }

//    }
    private func fillSuggestedEvents(team:FirebaseTeam){
//        var suggestedEvents : [EventModel] = []
        eventViewModel.fetchSavedEvents(teamId: team.id, chosen: team.chosenEvent, suggestedEvents: team.suggestedEvents) { result in
            switch result{
            case .success(let events):
                self.suggestedEvents = events
                
   
                
            case .failure(let error):
                print("error fetching suggested Events \(error)")
                loadingTeamInfo = false

                return
            }
        }
    }


}

struct FrontProfileView_Previews: PreviewProvider {
    static var previews: some View {
        FrontProfileView(name: "rat", groupId: "")


    }
}
