//
//  RequestListView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/13/23.
//

import SwiftUI

struct RequestListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var requestViewModel : RequestViewModel
    @State var requests : [RequestModelPicture] = []

    let groupId :String
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var loading : Bool = true
    @State private var allianceInformation : [AllianceModel] = []
    @State private var requestDic : [Int:AllianceModel] = [:]

    @State private var chosenRequest : AllianceModel = AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
    @State private var showChosenRequest : Bool = false
    @State private var showError : Bool = false
    @State private var fullError : Bool = false
    @State private var loadingRequests : Bool = true
    @State private var allianceDic : [String:Int] = [:]
    @State private var showAllianceFetchError = false
    
    @State private var chosenGroupId : String = ""

    var body: some View {
        VStack{
            Section(header: ListHeader(text: "Requests")){
                
                if loadingRequests{
                    ProgressView()
                }else{
                    ScrollView{
                        if !requests.isEmpty{
                            VStack{
                                ForEach(requests.indices, id: \.self){
                                    member in
                                    
                                    HStack{
                                        Image(uiImage: requests[member].pic)
                                            .resizable()
                                            .centerCropped()
                                            .frame(width: 50, height: 50)
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                        VStack{
                                            HStack{
                                                Text(requests[member].request.nameOfSender).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                                Spacer()
                                            }
                                            HStack{
                                                Text(requests[member].request.sendRole).font(.custom("Rubik Regular", size: 10)).foregroundColor(.white).opacity(0.7)
                                                Spacer()
                                            }
                                            
                                        }
                                        if requests[member].request.isATeam{
                                            
                                            Button {
//                                                self.chosenRequest = AllianceModel(groupId:requestDic[member]?.groupId ?? requests[member].request.sendingRequestId, teamName: requestDic[member]?.teamName ?? requests[member].request.nameOfSender, teamDescription: requestDic[member]?.teamDescription ?? requests[member].request.sendRole, memberModel: requestDic[member]?.memberModel ?? [], teamPic: requests[member].pic)
                                                self.chosenGroupId = requestDic[member]!.groupId
                                                if !chosenGroupId.isEmpty{
                                                    print("GROUP ID OF BEING CHOSEN \(chosenGroupId)")

                                                    self.showChosenRequest = true
                                                }
                                            } label: {
                                                
                                                //                                                            NavigationLink(destination: AllianceFullFrameView(alliance:requestDic[member]!)) {
                                                Text("View").font(.custom("Rubik Regular", size: 10)).foregroundColor(AppColor.lovolDarkerPurpleBackground
                                                ).padding(5)
                                                    .background(RoundedRectangle(cornerRadius:30).fill(.white.opacity(0.6)))
                                                //                                                            }
                                                
                                            }
                                            
                                        }
                                        Spacer()
                                        Button {
                                            cancelRequest(index:member)
                                        } label: {
                                            Image(systemName: "person.fill.xmark")
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal)
                                        Button {
                                            acceptRequest(index:member)
                                        } label: {
                                            Image(systemName: "person.fill.checkmark")
                                                .foregroundColor(.white)
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    .padding(.horizontal)
                                    
                                }
                            }
                            
                            
                        }else{
                            Text("No Requests").font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                        }
                    }
                    Spacer()
                }

                
            }
            .padding(.top,50)
//            .padding(.top)
//            .padding(.top)


            Spacer()
//            .frame(width:geo.size.width)
        }
        
        .background(BackgroundView())
        .overlay(
            VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"xmark").foregroundColor(.white)
                            .padding(5)
                            .background(Circle().fill(AppColor.lovolDark.opacity(0.6)))
                    }

                    Spacer()
                }
                Spacer()
            }
                .padding()
        )
        .fullScreenCover(isPresented: $showChosenRequest, content: {
                OtherTeamProfileView(groupId:$chosenGroupId)
        })
        .alert("Your Team is Full. You Cannot Accept the Request", isPresented: $fullError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .alert("There has been an error accepting the request", isPresented: $showError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .onAppear(perform: onAppear)
    }
    
    private func onAppear(){
  
        fillRequests(groupId: groupId)
//        fetchAlliances()
   
    }
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
    private func fillRequests(groupId:String){
        requestViewModel.fetchRequestsForGroup(groupId: groupId) { result in
            switch result{
            case .success(let fetchedRequests):
                var requestsWithPics : [RequestModelPicture] = []
                
                if fetchedRequests.isEmpty{
                    
                    print("is empty")
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
}

//struct RequestListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestListView()
//    }
//}
