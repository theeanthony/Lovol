//
//  GroupMessageView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/26/23.
//
 
import SwiftUI

struct GroupMessageView: View {
    
    let message : MessageModel
    let groupId: String 
    let group : ChatModel
    
    var body: some View {
        VStack(spacing: 0){
            if !message.isCurrentUser {
                Text(message.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading], 60)
                    .font(.custom("Rubik Regular", size: 13))
                    .foregroundColor(.white)

            }
            HStack(alignment: .bottom, spacing: 15) {
                if !message.isCurrentUser {
                    Image(uiImage: group.picture)
                        .centerCropped()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(20)
                } else {
                    Spacer()
                }
                GroupContentMessageView(contentMessage: message.message,
                                        isCurrentUser: message.isCurrentUser, groupId: groupId, matchId: group.groupId)
                if(!message.isCurrentUser){
                    Spacer()
                }
            }
            
        }
        .font(.custom("Rubik Regular", size: 12))
    }
}
//
//struct GroupMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupMessageView()
//    }
//}
