//
//  MessageView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//

import SwiftUI

struct MessageView: View {
    let message: MessageModel
    let match: MatchModel
    
    var body: some View {
        
        VStack(spacing: 0){
            if !message.isCurrentUser {
                Text(message.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading], 60)
                    .font(.custom("Rubik Regular", size: 13))
                    .foregroundColor(AppColor.lovolDarkPurple)

            }
            HStack(alignment: .bottom, spacing: 15) {
                if !message.isCurrentUser {
                    Image(uiImage: match.picture)
                        .centerCropped()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(20)
                } else {
                    Spacer()
                }
                ContentMessageView(contentMessage: message.message,
                                   isCurrentUser: message.isCurrentUser)
                if(!message.isCurrentUser){
                    Spacer()
                }
            }
            
        }
        .font(.custom("Rubik Regular", size: 14))


        
        
    }
    
    
}

//struct MessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageView(message: MessageModel(id: "efefefefe", isCurrentUser: false, timestamp: Date(), message: "sfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdrefsfrffrdref", name: "MUSK"), match: MatchModel(id: "fefefe", userId: "ededefd", name: "Elon", birthDate: Date(), picture: UIImage(), lastMessage: nil, isGroup: true))
//    }
//}
