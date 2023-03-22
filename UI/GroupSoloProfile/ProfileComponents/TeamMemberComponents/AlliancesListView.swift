//
//  AlliancesListView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/7/23.
//

import SwiftUI

struct AlliancesListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var loading : Bool = true
    @State var allianceInformation : [AllianceModel] = []

    @State private var showAlliance : Bool = false
    
    @State private var picLoaded : [Bool] = []
    
    @State private var picDic : [String:UIImage] = [:]
    @State private var picDicLoad : [String:Bool] = [:]
    @State private var picDicFilled : Bool = false

    
    @State private var chosenAlliance : AllianceModel = AllianceModel(groupId: "", teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
    
    let alliances : [String]
    @State var isPictureLoaded = false
    
    @State private var updateView: Bool = false
    @State private var chosenGroupId : String = ""
    var body: some View {
        
        GeometryReader{geo in
            VStack{
                
                if loading{
                    VStack{
                        Spacer()
                    HStack{
                        Spacer()
                        ProgressView()
                        Spacer()

                    }
                        Spacer()
                }
                }else{
                    Section(header: ListHeader(text: "\(allianceInformation.count) \(allianceInformation.count == 1 ? "Alliance" : "Alliances")")){
                        ScrollView{
                            
                            
                            ForEach(allianceInformation.indices, id: \.self){
                                alliance in
                                
                                Button {
//                                    
//                                    self.chosenAlliance = AllianceModel(groupId: allianceInformation[alliance].groupId, teamName: allianceInformation[alliance].teamName, teamDescription: allianceInformation[alliance].teamDescription, memberModel: allianceInformation[alliance].memberModel, teamPic: picDic[allianceInformation[alliance].groupId]!)
                                
                                    self.chosenGroupId = allianceInformation[alliance].groupId
                                    
                                    self.showAlliance = true
                                } label: {
//                                    NavigationLink(destination: AllianceFullFrameView(alliance: alliance)) {
                                        HStack{
                                      
//                                            if isPictureLoaded{
//                                            if picLoaded[alliance] {
                                            if picDicLoad[allianceInformation[alliance].groupId] ?? picDicFilled{
                                                Image(uiImage: picDic[allianceInformation[alliance].groupId]!)
                                                        .resizable()
                                                        .centerCropped()
                                                        .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                                                        .aspectRatio(contentMode: .fill)
                                                        .clipShape(Circle())
                                            }else{
                                                Circle().stroke(.white,lineWidth:1)
                                                    .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                                            }
                                          
//                                            }else{
                                             

//                                            }
                                                
//                                            }else{
                                       
                                                    
//                                            }
                                       
                                            Text(allianceInformation[alliance].teamName).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                            Spacer()
                                            Text("View Profile")
                                                .padding(5)
                                                .background(RoundedRectangle(cornerRadius: 30).fill(.white).opacity(0.6))
                                                .font(.custom("Rubik Regular", size: 10)).foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                            
                                            
                                        }
                                        
//                                    }
                                }
                                
                            }
                        }.frame(height:geo.size.height * 0.9)
                        
                    }
                    .padding(.top,50)
                    Spacer()

                    .frame(width:geo.size.width )
                }

            }
            
        }
        .fullScreenCover(isPresented: $showAlliance, content: {
            OtherTeamProfileView(groupId: $chosenGroupId)
        })
        .background(AppColor.lovolDark)
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
                    .padding()

                    Spacer()
                }
                Spacer()
            }
        )

        .onAppear(perform:fetchAlliances)
 
    }
    func fetchGroupPics(){
        
        for information in allianceInformation {
            picDicLoad[information.groupId] = false
            
        }
        picDicFilled = true
        for information in allianceInformation.indices {
            profileViewModel.fetchGroupMainPicture(profileId: allianceInformation[information].groupId) { result in
                switch result {
                case .success(let pic):
                   
                    picDic[allianceInformation[information].groupId] = pic
                    picDicLoad[allianceInformation[information].groupId] = true
//                    isPictureLoaded = true
                case .failure(let error):
                    print("error fetching team pic \(error)")
                }
            }
        }
    }
    func fetchAlliances() {
        profileViewModel.fetchAllianceTeamPics(groupIDS: alliances) { result in
            switch result {
            case .success(let fetchedAlliances):
                self.allianceInformation = fetchedAlliances
                loading = false
                
                fetchGroupPics()
      
  
            case .failure(let error):
                print("error fetching alliances \(error)")
                return
            }
        }
    }

    
}

//struct AlliancesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlliancesListView()
//    }
//}
