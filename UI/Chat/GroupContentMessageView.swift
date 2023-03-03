//
//  GroupContentMessageView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/26/23.
//

import SwiftUI

struct GroupContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    let groupId:String
    let matchId:String
    
    var body: some View {
        
        VStack{
                
       
            
            if isCurrentUser{
                Text(contentMessage)
                    .padding(10)
                .foregroundColor( .white )
                .background( AppColor.lovolPinkish)
                .cornerRadius(10)
            }else if groupId == matchId {
                Text(contentMessage)
                    .padding(10)
                .foregroundColor(.white)
                .background( AppColor.trophyGreen)

                .cornerRadius(10)
            }else{
                Text(contentMessage)
                    .padding(10)
                    .foregroundColor(AppColor.lovolDark)
                .background( AppColor.chatBubbleGray)
                .cornerRadius(10)
            }
   
                
                
        }

    }
}

//struct GroupContentMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupContentMessageView()
//    }
//}
