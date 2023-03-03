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
    @State private var typingMessage: String = ""
    @State private var messageList: [MessageModel] = []
    @State private var listener: ListenerRegistration? = nil
    @State private var isFirstMessageUpdate = true

    var body: some View {
            VStack{
                Spacer()
                ScrollViewReader{ value in
                    ScrollView{
                        LazyVStack{
                            ForEach(messageList){ message in
                                GroupMessageView(message: message, groupId: groupId, group: match)
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
        .onDisappear(perform: performOnDisappear)
    }
    
    private func performOnDisappear(){
        listener?.remove()
    }
    
    private func performOnAppear(){
        //add grouplistenmessages
        print("In group chat view \(match.groupId)")
        if match.groupId == groupId {
            listener = profileViewModel.listenToGroupMessages(groupId: match.groupId, onUpdate: {result in
                switch result{
                case .success(let messages):
                    messageList = messages
                    return
                case .failure(_): return
                }
            })
        }else{
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
        
        profileViewModel.sendGroupMessage(groupId: match.groupId, message: typingMessage, isOwn: match.groupId == groupId )
            typingMessage = ""
            
//            firestoreViewModel.sendMessage(matchId: match.id, message: typingMessage)
//            typingMessage = ""
       
    }
}

//struct GroupChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupChatView()
//    }
//}
