//
//  AllianceFrame.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct AllianceFrameExpanded: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

//    @Binding var alliances : [String]
    
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var allianceInformation : [AllianceModel] = []

    @State private var loading : Bool = true
    
    @State private var error : Bool = false
    @State private var chosenIndex : Int = 0
    @State private var isPresented : Bool = false
    
    @State var navigationViewIsActive: Bool = false
      @State var selectedModel : AllianceModel? = nil
    
    @State private var searchString : String = ""
    @State private var charLimit : Int = 10
    @State private var showTeam :Bool = false
    @State private var idNotLongEnoughError : Bool = false
    @State private var errorFindingTeam :Bool = false
    
    @State private var loadingSearch : Bool = false
    
    @State private var allianceSearch : AllianceModel = AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
    
    @State private var loadingTeam : Bool = false
    
    @State private var requestSent : Bool = false
    
    @State private var requestSentAlready : Bool = false
    
    let teamInfo : FirebaseTeam
    
    var body: some View {
        
        GeometryReader{ geo in
            VStack{
                
                if loading {
                    ProgressView()
                }else{




//                    }


//                    .listStyle(.plain)
                    

                }
 
            }
//            .frame(width:geo.size.width , height:geo.size.height)
//            .background(
//                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
//            )
//            .onChange(of: searchString) { newValue in
//                if newValue.count == 10 {
//                    searchTeam()
//                }
//            }
//            .alert("You have already sent a request to join another group. Please cancel before requesting again.", isPresented: $duplicateRequest, actions: {
//                Button("OK", role: .cancel, action: {
//
//                })
//            })
            .alert("Please input the team's 10 character ID.", isPresented: $idNotLongEnoughError, actions: {
                Button("OK", role: .cancel, action: {
     
                })
            })
            .alert("A request for this alliance has already been sent. Stop.", isPresented: $requestSentAlready, actions: {
                Button("OK", role: .cancel, action: {
     
                })
            })
//            .alert("There has been an error fetching alliance requests", isPresented: $showAllianceFetchError, actions: {
//                Button("OK", role: .cancel, action: {
//
//                })
//            })
        }
//        .onAppear(perform:fetchAlliances)
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: btnBack)
//        .navigationBarTitleDisplayMode(.inline)
    }

    func sendRequest(){
        profileViewModel.sendAllianceRequest(id: searchString, sendingTeam: teamInfo){ result in
            switch result{
            case .success(true):
                requestSentAlready = true
            case .success(false):
                self.requestSent = true
            case .failure(let error):
                print("error fetching requests to check if i can send another request \(error)")
                return
            }
        }
    }
    func fetchAlliances(){
        profileViewModel.fetchAllianceTeamPics(groupIDS: teamInfo.alliances) { result in
            switch result {
                
            case .success(let fetchedAlliances):
                self.allianceInformation = fetchedAlliances
                loading = false
            case .failure(let error):
                print("error fetching alliances \(error)")
                return
                
            }
        }
        
    }
}

//struct AllianceFrameExpanded_Previews: PreviewProvider {
//    @State static var alliances : [String] = []
//    static var previews: some View {
//        AllianceFrameExpanded(alliances: $alliances)
//    }
//}
struct AllianceFrame: View {
    var body: some View {
        
        GeometryReader{ geo in
            VStack{
                
                
                Button {
                    
                } label: {
                    HStack{
                        Spacer()
                        Text("Alliances ").font(.custom("Rubik Regular", size: 16)).textCase(.uppercase)
                        Image(systemName:"arrow.up.and.down")
                        Spacer()
                        
                    }
                }
                .foregroundColor(.white)

    

                
                
                
                
            }
            .padding()
//            .background(AppColor.lovolDarkPurple)
        }
    }
    
}

struct AllianceFrame_Previews: PreviewProvider {
    static var previews: some View {
        AllianceFrame()
    }
}
