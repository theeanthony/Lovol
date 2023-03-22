//
//  FrontChatView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/26/23.
//

import SwiftUI

struct FrontChatView: View {
    
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var loading = true
    @State private var groupChats : [ChatModel] = []
    @State private var groupChat : ChatModel = ChatModel(id: "", groupId: "", name: "", picture: UIImage(), lastMessage: "")
    @State private var groupId : String = ""
    @State private var alliances : [String] = []
    
    @State private var newMessage : Bool = false
    @State private var addChat : Bool = false
    
    @State private var chatFullScreen : Bool = false
    @State private var chatOtherFullScreen : Bool = false
    
    @State private var chosenMessage : ChatModel = ChatModel(id: "", groupId: "", name: "", picture: UIImage(), lastMessage: "")
    
    @State private var teamInfo : FirebaseTeam = FirebaseTeam()
    
    @State private var loadingGroupChats : Bool = true
    
    @State private var initialImage : UIImage = UIImage()
    
    @State private var chosenIndex : Int = 0
    var body: some View {
        GeometryReader{geo in
            VStack{
                Spacer()
                if loading {
                    ProgressView()
                        .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                }else{
                    VStack{
                        Spacer()
                        ScrollView{
                            if teamInfo.id != "" {
                                
                                Button {
                                   fillChosen()
                                } label: {
                                    ChatItemView(model: groupChat)
                                }
                                
                                if loadingGroupChats{
                                    HStack{
                                        Spacer()
                                        ProgressView()
                                        Spacer()
                                    }
                                }else{
                                    ForEach(groupChats.indices,id:\.self){
                                        chat in
                                        
                                        Button {
                                            fillOtherChosen(chat:groupChats[chat], index: chat)
                                        } label: {
                                            ChatItemView(model: groupChats[chat])
                                        }
                                        
                                    }
                                }
                 

                                
                                
                              
                            }else{
                                HStack{
                                    Spacer()

                                    Text("Join a team to have group chats.")
                                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                                Spacer()
                                }

                            }
                           

                        }
                        .frame(width:geo.size.width, height:geo.size.height * 0.9)
                        .padding(.vertical,5)
                    }
                }
                
  
            }
            .background(BackgroundView())
            .overlay(
                VStack{
                    HStack{
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName:"xmark").foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(AppColor.lovolDark).opacity(0.6))
                        }
                        Spacer()
                        
                        Text("Messages")
                            .font(.custom("Rubik Bold", size: 12))
                                .foregroundColor(.white)
                        Spacer()
                        Button {
                            self.newMessage = true 
                        } label: {
                            Image(systemName:"plus").foregroundColor(.white)
                        }
                        .padding(.trailing,10)

//                        Button {
//
//                        } label: {
//                            Image(systemName:"plus").foregroundColor(.white)
//                        }

                    }.padding()
                    Spacer()
                })
            .onAppear(perform: onAppear)
            .fullScreenCover(isPresented: $chatFullScreen) {
                GroupChatView(match: $groupChat, groupId:teamInfo.id,fromNotification: false)
            }
            .fullScreenCover(isPresented: $chatOtherFullScreen) {
                GroupChatView(match: $groupChats[chosenIndex],groupId:teamInfo.id,fromNotification: false)
            }
            .fullScreenCover(isPresented: $addChat) {
                
            }
            .fullScreenCover(isPresented: $newMessage) {
                NewGroupChatView(teamInfo:teamInfo,newGroupChats:$groupChats)
            }
            
            
        }
    }
    private func fillChosen(){
        self.chosenMessage = groupChat
        

        self.chatFullScreen = true
    }
    private func fillOtherChosen(chat:ChatModel,index:Int){
        self.chosenMessage = chat
        self.chosenIndex = index
        print("Chat id : \(chat.groupId)")
        self.chatOtherFullScreen = true
    }
    
    private func fetchOwnGroupChat(){

        profileViewModel.fetchGroupConvo(id: teamInfo.id, subPic:initialImage) { result in
                        switch result{
                        case .success(let fetchedGroupChat):
                            self.groupChat = fetchedGroupChat
                            profileViewModel.fetchGroupMainPicture(profileId: teamInfo.id) { result in
                                switch result{
                                case .success(let image):
                                    self.groupChat.picture = image
                                case .failure(let error):
                                    print("error fetching picture \(error)")
                                }
                            }
                            
                            loading = false
                        case .failure(let error):
                            print("error fetching groupChat \(error)")
                            return
                        }
                    }
 
        }
    private func fetchAllianceConvos(){
        
        profileViewModel.fetchAllianceConvos(groupId: teamInfo.id, ids: teamInfo.alliances, subPic:initialImage) { result in
            switch result{
            case .success(let allianceConvos):
                self.groupChats = allianceConvos
                self.loadingGroupChats = false
                
                for chat in groupChats.indices {
                    profileViewModel.fetchGroupMainPicture(profileId: groupChats[chat].groupId) { result in
                        switch result{
                        case .success(let image):
                            groupChats[chat].picture = image
                        case .failure(let error):
                            print("error fetching picture \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching alliance convos \(error)")
                return
            }
        }
        
    }
    private func onAppear(){
        profileViewModel.fetchTeamWithoutID { result in
            switch result{
            case .success(let team):
                self.teamInfo = team
                if teamInfo.id != "" {

                fetchOwnGroupChat()
                fetchAllianceConvos()
                }


            case .failure(let error):
                print("Error fetching team \(error)")
                return
            }
            
        }
    }

            
}

struct FrontChatView_Previews: PreviewProvider {
    static var previews: some View {
        FrontChatView()
    }
}
