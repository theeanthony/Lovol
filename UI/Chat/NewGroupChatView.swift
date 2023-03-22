//
//  NewGroupChatView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/17/23.
//

import SwiftUI

struct NewGroupChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    let teamInfo : FirebaseTeam
    
    @Binding var newGroupChats : [ChatModel]
    @State private var groupChats : [ChatModel] = []
    @State private var groupChat : ChatModel = ChatModel(id: "", groupId: "", name: "", picture: UIImage(), lastMessage: "")
    @State private var initialImage : UIImage = UIImage()
    @State private var loadingGroupChats : Bool = true
    @State private var chatFullScreen : Bool = false
    @State private var chatOtherFullScreen : Bool = false
    @State private var chosenMessage : ChatModel = ChatModel(id: "", groupId: "", name: "", picture: UIImage(), lastMessage: "")
    var body: some View {
        GeometryReader{geo in
            VStack{
                Spacer()
                ScrollView{
                    if loadingGroupChats{
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }else{
                        if groupChats.isEmpty{
                            VStack{
                                Spacer()
                                HStack{
                                    Spacer()

                                    Text("Add new alliances to start new chats.")
                                        .font(.custom("Rubik Regular", size: 12))
                                        .foregroundColor(.white)
                                    Spacer()

                                }
                                Spacer()

                            }
                        }else{
                            ForEach(groupChats.indices,id:\.self){
                                chat in
                                
                                Button {
                                    fillOtherChosen(chat:groupChats[chat])
                                } label: {
                                    ChatItemView(model: groupChats[chat])
                                }
                                
                            }
                        }
                    }
                }
                .frame(height:geo.size.height * 0.9)
            }
            .background(BackgroundView())

        }
        .onAppear(perform:fetchAllianceConvos)
        .fullScreenCover(isPresented: $chatOtherFullScreen) {
            GroupChatView(match: $chosenMessage,groupId:teamInfo.id,fromNotification: false)
                .onChange(of: chosenMessage.lastMessage, perform: { newValue in
                    if newValue != nil {
                        print("NEw value \(chosenMessage)")
                        print("newValue \(newValue)")
                              newGroupChats.append(chosenMessage)
                    }
                })
        }
   
        .overlay(VStack{
            HStack{
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName:"chevron.left").foregroundColor(.white)

                }
                Spacer()
                Text("New Chat")
                    .font(.custom("Rubik Bold", size: 12))
                        .foregroundColor(.white)
                Spacer()

            }
            .padding()
            Spacer()
        }
           
        )

    }
    private func fillOtherChosen(chat:ChatModel){
        self.chosenMessage = chat

        print("Chat id : \(chat.groupId)")
        self.chatOtherFullScreen = true
    }

    private func fetchAllianceConvos(){
        
        profileViewModel.fetchAllianceEmptyConvos(groupId: teamInfo.id, ids: teamInfo.alliances, subPic:initialImage) { result in
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
}

