//
//  AllianceFullFrameView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/27/23.
//

import SwiftUI

struct AllianceFullFrameView: View {
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
    let alliance : AllianceModel
    
    @State private var alliances : AllianceModel = AllianceModel(groupId: "",teamName: "", teamDescription: "", memberModel: [], teamPic: UIImage())
    @State private var fetchedMemberModel : [MemberModel] = []
    @State private var loading : Bool = true
    @State private var error : Bool = false
    @State private var fetchedEvent : [String] = []
    var body: some View {
        GeometryReader { geo in
            
            VStack{
                if loading {
                    ProgressView()
                    
                }else{
                ScrollView{
               
                        Image(uiImage: alliance.teamPic)
                            .resizable()
                            .centerCropped()
                            .foregroundColor(.gray)
                            .frame(width: geo.size.width, height: geo.size.height * 0.5)
                            .aspectRatio(contentMode: .fill)
//                            .overlay(
//
//                            )
                    HStack{
                        Spacer()
                        VStack(spacing:0){
                            HStack{
                                Text(alliances.teamDescription).font(.custom("Rubik Regular", size: 13)).foregroundColor(.white)
                                //                                .padding(.padding,10)
                                Spacer()
                            }
                            .padding()

//                                .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkerPurpleBackground))
                            
                        }
                        Spacer()
                        
                    }
                    Section(header: ListHeader(text: "Team Members")){
                        ForEach(fetchedMemberModel.indices, id:\.self) { member in
                                HStack{
                                    Image(uiImage: fetchedMemberModel[member].pic)
                                        .resizable()
                                        .centerCropped()
                                        .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                    VStack{
                                        HStack{
                                            Text(fetchedMemberModel[member].name).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                            Spacer()
                                        }
                                        HStack{
                                            Text(fetchedMemberModel[member].role).font(.custom("Rubik Regular", size: 10)).foregroundColor(.white).opacity(0.7)
                                            Spacer()
                                        }

                                    }
                                    Spacer()
                  
                                    
                                    
                                }
                            }
     
                    }
                    .frame(width:geo.size.width * 0.95)
                    
                    

//                    Section(header:ListHeader(text: "Most Recent Event")){
//                        
//                        if !fetchedEvent.isEmpty {
//                            AsyncImage(url: URL(string: fetchedEvent[1]),
//                                       content: { image in
//                                image.resizable()
////                                    .aspectRatio(contentMode:.fill)
//                                    .frame(height:geo.size.height * 0.5 )
//                                    .frame(width:geo.size.width  )
////                                    .background(RoundedRectangle(cornerRadius:20).stroke(.black,lineWidth:1))
//                                
//                                
//                                
//                                
//                                
//                                
//                            },
//                                       placeholder: {
//                                ProgressView()
//                                    .frame(height:geo.size.height * 0.5 )
//                                    .frame(width:geo.size.width  )
//                                
//                                
//                            })
//                            .overlay(
//                                VStack{
//                                    HStack{
//                                        Spacer()
//                                        Text(fetchedEvent[0]).font(.custom("Rubik Bold", size: 12)).foregroundColor(.white).multilineTextAlignment(.center).textCase(.uppercase)
//                                        Spacer()
//                                    }
//                                    .padding(.leading)
//                                    Spacer()
//                                }
//                            )
//                        }else{
//                            HStack{
//                                Spacer()
//                                Text("This team has not done a single event together...").font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).multilineTextAlignment(.center)
//                                    .frame(height:geo.size.height * 0.2)
//
//                                Spacer()
//
//                            }
//                        }
//                    }
//                    .frame(width:geo.size.width * 0.95)
                    
     
                        Spacer()
                    }                .frame(height:geo.size.height * 0.95)
                    

                }
            }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: btnBack)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar{
                        ToolbarItemGroup(placement:.principal){
                                    Text(alliance.teamName).font(.custom("Rubik Bold", size: 14)).foregroundColor(.white).textCase(.uppercase)
                             
                          
                        }
                    }
                    .overlay(
                        VStack{
                            HStack{
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(systemName:"xmark").foregroundColor(.white)
                                }

                                Spacer()
                            }
                            Spacer()
                        }.padding())
                    .frame(width:geo.size.width, height:geo.size.height)
                    .background(BackgroundView())

                    .onAppear(perform: onAppear)
            }
    }
    private func onAppear(){
        self.alliances = alliance
        print("before fetching \(alliance.memberModel)")

        profileViewModel.fetchMainPictureV1(members: alliance.memberModel) { result in
            switch result {
            case .success(let members):
                print("was this a success")
                self.fetchedMemberModel = members
                profileViewModel.fetchLatestEventInfo(groupId: alliance.groupId) { result in
                    switch result {
                    case .success(let info):
                        self.fetchedEvent = info
                        loading = false

                    case .failure(let error):
                        print("error fetching latest event \(error)")
                        loading = false

                        
                    }
                }
                loading = false
                return
            case .failure(let error):
                print("error loading teammates profile pics. \(error)")
                self.error = true
                loading = false
                return
            }
        }
        
    }
}

//struct AllianceFullFrameView_Previews: PreviewProvider {
//    
//    static let memberModel : [MemberModel] = [MemberModel(id: "", name: "Ant", role: "Cool", pic: UIImage(named:"elon_musk")!),MemberModel(id: "", name: "Ant", role: "Cool", pic: UIImage(named:"elon_musk")!),MemberModel(id: "", name: "Ant", role: "Cool", pic: UIImage(named:"elon_musk")!),MemberModel(id: "", name: "Ant", role: "Cool", pic: UIImage(named:"elon_musk")!)]
//    static var previews: some View {
//        AllianceFullFrameView(alliance: AllianceModel(teamName: "Anthony", teamDescription: "This is a pretty cool description and we should do something about its not cool ", memberModel: memberModel, teamPic: UIImage(named:"elon_musk")!))
//    }
//}
