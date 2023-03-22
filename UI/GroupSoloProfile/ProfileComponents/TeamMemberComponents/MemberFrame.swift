//
//  MemberFrame.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct MemberFrame: View {
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

//    @State private var teamMembers : [MemberModel] = []
    @State private var members: [MemberModel] = []
    @State var requests : [RequestModelPicture] = []
    let groupId: String
    let teamInfo: FirebaseTeam
    @Binding var searchString : String 
    @State private var alliances : [String] = []
    @State private var allianceDic : [String:Int] = [:]
    @State private var loadingTeamInfo : Bool = true
    @State private var showAllianceFetchError = false
    @State private var requestDic : [Int:AllianceModel] = [:]
    
    @EnvironmentObject private var requestViewModel : RequestViewModel
//    @Binding var requests : [RequestModelPicture]
  
    @State private var requestSent : Bool = false

    @State private var index : Int = 0
    @State private var loading : Bool = true
    @State private var allianceInformation : [AllianceModel] = []

    @State private var showError : Bool = false
    @State private var fullError : Bool = false
    @State private var loadingRequests : Bool = true
    @State private var urlString : URL = URL(string: "https://lovolac.com")!
    
    @State private var chosenRequest : AllianceModel = AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
    @State private var showChosenRequest : Bool = false
    var body: some View {
        GeometryReader{ geo in
            VStack{
                
                if loadingTeamInfo  {
                    ProgressView()
                        .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
                }else{


                            
                            ScrollView{
             
//                                if !allianceInformation.count == 0 {

//                                }
                                
                                Section(header: ListHeader(text: "\(members.count) \(members.count == 1 ? "Member" : "Team Members")")){
                                    
                                    ForEach(members.indices, id: \.self){
                                        member in
                                        
                                        HStack{
                                            Image(uiImage: members[member].pic)
                                                .resizable()
                                                .centerCropped()
                                                .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                            VStack{
                                                HStack{
                                                    Text(members[member].name).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                                    Spacer()
                                                }
                                                HStack{
                                                    Text(members[member].role).font(.custom("Rubik Regular", size: 10)).foregroundColor(.white).opacity(0.7)
                                                    Spacer()
                                                }
                                                
                                            }
                                            Spacer()
                                            
                                            
                                            
                                        }
                                        
                                        
                                    }
                                        
                                        
                                        //                                    ShareLink( "Invite Friends", item: urlString)
                                        //                                        .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white).multilineTextAlignment(.center)
                                        
                                        
                                    //                            }
                                }
                                .frame(width:geo.size.width )
        
                                
                            //section
                               

                        
                      
            }
        }
        

    }
            .fullScreenCover(isPresented: $showChosenRequest, content: {
                AllianceFullFrameView(alliance:$chosenRequest)
            })

//    .frame(height:geo.size.height )

        //            .onAppear(perform: populate)
    .alert("Your Team is Full. You Cannot Accept the Request", isPresented: $fullError, actions: {
        Button("OK", role: .cancel, action: {

        })
    })
    .alert("There has been an error accepting the request", isPresented: $showError, actions: {
        Button("OK", role: .cancel, action: {

        })
    })


}
//.navigationBarBackButtonHidden(true)
//.navigationBarItems(leading: btnBack)
//.navigationBarTitleDisplayMode(.inline)
.onAppear(perform: onAppear)

    }
//    func sendRequest(){
//        profileViewModel.sendAllianceRequest(id: searchString, sendingTeam: teamInfo)
//    }

    private func cancelRequest(index: Int ){
        requestViewModel.cancelRequest(id: requests[index].request.id) {
            requests.remove(at: index)
        }
    }
    private func acceptRequest(index: Int ){
        requestViewModel.acceptRequest(request:requests[index].request) { result in
            switch result{
            case .success(true):
                requests.remove(at: index)
            case .success(false):
                showError = true
            case .failure(let error):
                print("error accepting request \(error)")
                showError = true
            }
        }
    }
    private func onAppear(){
        self.alliances = teamInfo.alliances
        fillInInfo(team: teamInfo)
//        fillRequests(groupId: groupId)
//        fetchAlliances()
        firestoreViewModel.shareTapped(groupId) { url in
            self.urlString = url
        }
    }
    private func fillRequests(groupId:String){
        requestViewModel.fetchRequestsForGroup(groupId: groupId) { result in
            switch result{
            case .success(let fetchedRequests):
                var requestsWithPics : [RequestModelPicture] = []
                
                if fetchedRequests.isEmpty{
                    loadingRequests = false

                    return
                }
                for fetchedRequest in fetchedRequests {
                    requestsWithPics.append(RequestModelPicture(request:fetchedRequest, pic: UIImage()))
                }
                profileViewModel.fetchRequestsWithPictures(requests: requestsWithPics) { result in
                    switch result {
                    case .success(let requestWithPics):
                        self.requests = requestWithPics
                        
                        var teamsId : [String] = []
                        for request in requests.indices {
                            if requests[request].request.isATeam {
//                                print("is a team id \(requests[request].request.sendingRequestId)")
                                teamsId.append(requests[request].request.sendingRequestId)
                                requestDic[request] = AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
                                allianceDic[requests[request].request.sendingRequestId] = request
                            }
                        }
                        print("Teams id \(teamsId)")
                        profileViewModel.fetchAllianceTeamPics(groupIDS: teamsId) { result in
                            
                            switch result{
                            case .success(let alliances):
                                for alliance in alliances{
                                    let substitute = allianceDic[alliance.groupId]
                                    self.requestDic[substitute!] = alliance
                                }
                                print("loading request is equal to false")
                                loadingRequests = false
                                return
                            case .failure(let error):
                                print("error could not fetch alliance requests \(error)")
                                showAllianceFetchError = true
                                loadingRequests = false
                                return
                            }
                        }

                    case .failure(let error):
                        print("error fetching pictures for requets \(error)")
                        loadingRequests = false

                        return
                    }
                }
              
                return
            case .failure(let error):
                print("error fetching requests \(error)")
                return
            }
        }
    }
    private func fillInInfo(team:FirebaseTeam){
        var membersInfo : [MemberModel] = []
        for index in team.teamMemberIDS.indices {
            let member : MemberModel = MemberModel(id: team.teamMemberIDS[index], name: team.teamMemberNames[index], role: team.teamMemberRoles[index], pic: UIImage())
            membersInfo.append(member)
        }

            
        profileViewModel.fetchMainPictureV1(members: membersInfo){ result in
                switch result{
                    
                case .success(let membersFetched):
                    self.members = membersFetched
//                        self.suggestedEvents = team.suggestedEvents
//                        self.chosenEvent = team.chosenEvent
                    print("all info from team mebers")
                        loadingTeamInfo = false
                case .failure(let error):
                    print("error fetching main image \(error)")
                    loadingTeamInfo = false

                    
                    
                }
            }

    }
  

}

//struct MemberFrame_Previews: PreviewProvider {
//    static var previews: some View {
//        MemberFrame(teamName: "",teamDescription:"",members: [MemberModel(id: "", name: "Anthony", role: "Cheesey", pic: UIImage(named:"elon_musk")!),MemberModel(id: "", name: "Anthony", role: "Cheesey", pic: UIImage(named:"elon_musk")!),MemberModel(id: "", name: "Anthony", role: "Cheesey", pic: UIImage(named:"elon_musk")!),MemberModel(id: "", name: "Anthony", role: "Cheesey", pic: UIImage(named:"elon_musk")!)])
//    }
//}
