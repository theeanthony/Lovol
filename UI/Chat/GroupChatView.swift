//
//  GroupChatView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/26/23.
//

import SwiftUI
import Firebase

struct GroupChatView: View {
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var profileViewModel: ProfilesViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    var btnBack : some View { Button(action: {
//          self.presentationMode.wrappedValue.dismiss()
//          }) {
//              HStack {
//                  Image(systemName: "chevron.left") // set image here
//                  .aspectRatio(contentMode: .fit)
//                  .foregroundColor(.white)
//
//              }
//          }
//      }
    @Binding var match: ChatModel
    let groupId : String
    
     var fromNotification : Bool 
    @State private var typingMessage: String = ""
    @State private var messageList: [MessageModel] = []
    @State private var listener: ListenerRegistration? = nil
    @State private var isFirstMessageUpdate = true
    
    
    @State private var pictureDictionary : [String:UIImage] = [:]
    @State var isPictureLoaded = false
    @State var totalProfilePicsToLoad : Int = 0
    
    @State var defaultPic: UIImage = UIImage()
    @State private var updateView: Bool = false


    var body: some View {
            VStack{
                Spacer()
                ScrollViewReader{ value in
                    ScrollView{
                        LazyVStack{
                            ForEach(messageList){ message in
                                GroupMessageView(message: message, groupId: groupId, group: match,isPictureLoaded:$isPictureLoaded, personalPFP: $pictureDictionary[message.senderId])
                                    .id(message.id)
                                
                            }
                        }
                    }
                    .padding([.leading, .trailing], 8)
                    .onChange(of: messageList, perform: { _ in
                        if isFirstMessageUpdate{
                            value.scrollTo(messageList.last?.id, anchor: .bottom)
                            isFirstMessageUpdate = false
                        } else{
                            withAnimation{
                                value.scrollTo(messageList.last?.id, anchor: .bottom)
                            }
                        }
                    })
           
           
                }
                .padding(.top,30)
                HStack {
                    TextField("", text: $typingMessage).placeholder(when: typingMessage.isEmpty, placeholder: {
                        Text("Write Something...").foregroundColor(.white).opacity(0.6)
                    })
                        .padding(.vertical,10)
                        .padding(.leading,5)
                        .foregroundColor(.white)
                    //                      .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                        .background(RoundedRectangle(cornerRadius: 15).stroke(AppColor.lovolNavyBlue,lineWidth:1))
                    if(!typingMessage.isEmpty){
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .padding(8)
                                .foregroundColor(.white)
                                .background(Circle().fill(AppColor.lovolNavyBlue))
                        }
                    }
                    
                }
                .frame(minHeight: CGFloat(50)).padding([.trailing, .leading])
                .padding(.bottom,15)
                
            }
            .overlay(VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left").foregroundColor(.white)
                    }
                    
                    Spacer()
                    Text(match.name)
                        .font(.custom("Rubik Bold", size: 12))


                    Spacer()
                }
                .padding()
                Spacer()
            })
            .font(.custom("Rubik Regular", size: 12))
//            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
            .padding(.bottom,10)
            .padding(.horizontal,10)
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(
                AppColor.lovolDark
            )

            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(match.name)
                        .font(.custom("Rubik Bold", size: 12))
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(.white)
                }
            }
        .onAppear(perform: performOnAppear)
        .onChange(of: isPictureLoaded) { _ in
               // Trigger a redraw of the view when isPictureLoaded changes
               updateView.toggle()
           }
        .background(
                Group {
                    if updateView {
                        Rectangle()
                            .fill(Color.clear)
                            .onAppear {
                                updateView.toggle()
                            }
                    }
                }
            )
        .onDisappear(perform: performOnDisappear)
    }
    
    private func performOnDisappear(){
        listener?.remove()
    }
    private func fetchProfilePic(){
        profileViewModel.fetchGroupMainPicture(profileId: match.groupId) { result in
            switch result{
            case .success(let image):
                match.picture = image
                defaultPic = image
            case .failure (let error):
                
                print ("error fetching iage \(error)")
            }
        }
    }
    
    private func fetchTeamIndividualPics(){
        profileViewModel.fetchTeam(id: groupId) { result in
            switch result{
            case .success(let team):
                
                let teamIds = team.teamMemberIDS
                
                self.totalProfilePicsToLoad += teamIds.count
//                print("teammates ids \(teamIds)")
                for id in teamIds {
                    profileViewModel.fetchMainPicture(profileId: id) { result in
                        switch result{
                        case .success(let image):
                            self.pictureDictionary[id] = image
                            print("ID OF picture \(id) and Image \(image)")

                            self.totalProfilePicsToLoad -= 1
                            
                            if totalProfilePicsToLoad == 0 {
                                print("switching picture loded")
                                self.isPictureLoaded = true
                            }
                        case .failure(let error):
                            print("error fetching my team picture \(error)")
                            self.pictureDictionary[id] = match.picture
                            return
                        }
                    }

                }
                
            case .failure(let error):
                print("error fetching team \(error)")

            }
        }
    }
    private func fetchBothSidePics(){
        profileViewModel.fetchTeam(id: match.groupId) { result in
            switch result{
            case .success(let team):
                
                let teamIds = team.teamMemberIDS
//                print("teammates other ids \(teamIds)")
                profileViewModel.fetchTeam(id: groupId) { result in
                    switch result{
                    case .success(let team):
                        
                        let otherTeamIds = team.teamMemberIDS
                        
        //                print("teammates ids \(teamIds)")
                        let bothTeamIds = teamIds + otherTeamIds
                        self.totalProfilePicsToLoad = bothTeamIds.count

                        print("total count \(totalProfilePicsToLoad)")

                        for id in bothTeamIds {
                            profileViewModel.fetchMainPicture(profileId: id) { result in
                                switch result{
                                case .success(let image):
                                    self.pictureDictionary[id] = image
                                    print("ID OF picture \(id) and Image \(image)")

                                    self.totalProfilePicsToLoad -= 1
                                    
                                    if totalProfilePicsToLoad == 0 {
                                        print("switching picture loded")
                                        self.isPictureLoaded = true
                                    }
                                case .failure(let error):
                                    print("error fetching my team picture \(error)")
                                    self.pictureDictionary[id] = match.picture
                                    return
                                }
                            }

                        }
                        
                    case .failure(let error):
                        print("error fetching team \(error)")

                    }
                }
 
                
            case .failure(let error):
                print("error fetching team \(error)")

            }
        }
    }
    private func fetchOtherTeamPics(){
        profileViewModel.fetchTeam(id: match.groupId) { result in
            switch result{
            case .success(let team):
                
                let teamIds = team.teamMemberIDS
//                print("teammates other ids \(teamIds)")
                self.totalProfilePicsToLoad += teamIds.count

                for id in teamIds {
                    profileViewModel.fetchMainPicture(profileId: id) { result in
                        switch result{
                        case .success(let image):
                            
                            self.pictureDictionary[id] = image
                            
                            print("ID OF picture \(id) and Image \(image)")
                            self.totalProfilePicsToLoad -= 1
                            
                            if totalProfilePicsToLoad == 0 {
                                print("switching picture loded")

                                self.isPictureLoaded = true
                            }
                        case .failure(let error):
                            print("error fetching other team picture \(error)")
                            self.pictureDictionary[id] = match.picture
                            return
                        }
                    }

                }
                
            case .failure(let error):
                print("error fetching team \(error)")

            }
        }
    }
    
    private func performOnAppear(){
        //add grouplistenmessages
        print("In group chat view \(match.groupId)")
        
        if fromNotification {
            fetchProfilePic()
        }
        
        if match.groupId == groupId {
            
            fetchTeamIndividualPics()
            listener = profileViewModel.listenToGroupMessages(groupId: match.groupId, onUpdate: {result in
                switch result{
                case .success(let messages):
                    
                    
                    messageList = messages
                    
                  
                    return
                case .failure(_): return
                }
            })
        }else{
      
            fetchBothSidePics()

            listener = profileViewModel.listenToAllianceMessages(chatId:match.groupId,groupId: groupId, onUpdate: {result in
                switch result{
                case .success(let messages):
                    messageList = messages
                    return
                case .failure(_): return
                }
            })
        }


    }
    
    private func sendMessage(){
        
        profileViewModel.sendGroupMessage(groupId: match.groupId, message: typingMessage, isOwn: match.groupId == groupId, teamNameTalkingTo: match.name)
        let lastMessage = typingMessage

            typingMessage = ""
        let newMatch = ChatModel(id: match.id, groupId: match.groupId, name: match.name, picture: match.picture, lastMessage: lastMessage)
        match = newMatch
//            firestoreViewModel.sendMessage(matchId: match.id, message: typingMessage)
//            typingMessage = ""
       
    }
}

//struct GroupChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupChatView()
//    }
//}
