//
//  ChatView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//
 
import SwiftUI
import Firebase

struct ChatView: View {
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var profileViewModel: ProfilesViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let match: MatchModel
    let groupConvo : Bool
    @State private var groupId : String = ""
    @State private var typingMessage: String = ""
    @State private var messageList: [MessageModel] = []
    @State private var listener: ListenerRegistration? = nil
    @State private var isFirstMessageUpdate = true
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(AppColor.lovolTan)
                  
              }
          }
      }
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                ScrollViewReader{ value in
                    ScrollView{
                        LazyVStack{
                            ForEach(messageList){ message in
                                MessageView(message: message, match: match)
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
                HStack {
                    TextField("", text: $typingMessage).placeholder(when: typingMessage.isEmpty, placeholder: {
                        Text("Write Something...").foregroundColor(AppColor.lovolTan)
                    })
                        .padding(.vertical,10)
                        .padding(.leading,5)
                        .foregroundColor(AppColor.lovolTan)
                    //                      .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                        .background(RoundedRectangle(cornerRadius: 15).fill(AppColor.lovolPinkish))
                    if(!typingMessage.isEmpty){
                        Button(action: sendMessage) {
                            Image(systemName: "paperplane.fill")
                                .padding(8)
                                .foregroundColor(AppColor.lovolTan)
                                .background(Circle().fill(AppColor.lovolSendPink))
                        }
                    }
                    
                }
                .frame(minHeight: CGFloat(50)).padding([.trailing, .leading])
                .padding(.bottom,15)
                
            }
            .font(.custom("Rubik Regular", size: 14))
            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
            .padding(.bottom,10)
            .padding(.horizontal,10)
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            
//            .navigationTitle(match.name)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(match.name)
                        .font(.custom("Rubik Bold", size: 18))
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(AppColor.lovolTan)
                }
            }
//            .navigationBarTitleTextColor(AppColor.lovolTan)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)

            

        }
        
        .onAppear(perform: performOnAppear)
        .onDisappear(perform: performOnDisappear)
    }
    
    private func performOnDisappear(){
        listener?.remove()
    }
    
    private func performOnAppear(){
        //add grouplistenmessages
        if groupConvo {
            groupId = profileViewModel.fetchGroupId()
            listener = firestoreViewModel.listenToGroupMessages(groupId: groupId, onUpdate: {result in
                switch result{
                case .success(let messages):
                    messageList = messages
                    return
                case .failure(_): return
                }
            })
        }
        else{
            listener = firestoreViewModel.listenToMessages(matchId: match.id, onUpdate: {result in
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
        
        if groupConvo {
            firestoreViewModel.sendGroupMessage(groupId: groupId, message: typingMessage)
            typingMessage = ""
            
        }
        else{
            firestoreViewModel.sendMessage(matchId: match.id, message: typingMessage)
            typingMessage = ""
        }
       
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(match: MatchModel(id: "efefefeº", userId: "fregregreg",name: "Rob", birthDate: Date(), picture: UIImage(named: "elon_musk")!, lastMessage: "Sup bro", isGroup: true), groupConvo: false).environmentObject(FirestoreViewModel())
    }
}
