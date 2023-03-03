//
//  ChatItemView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/26/23.
//

import SwiftUI

struct ChatItemView: View {
    let model: ChatModel

    var body: some View {
        HStack{
            Image(uiImage: model.picture).centerCropped().frame(width: 50, height: 50).cornerRadius(25)
                .padding([.leading,.top,.bottom], 8)
                .padding(.trailing,3)
            VStack(alignment: .leading){
                HStack{
                    Text(model.name)
                        .font(.custom("Rubik Bold", size: 12))

      
                    
                }
                Text(model.lastMessage ?? "Initiate a stream of words...")
                    .font(.custom("Rubik Regular", size: 12)).opacity(0.6)

                    .fontWeight(.light)
            }.padding(.leading, 6)
            Spacer()

           
        }

            .padding(.horizontal,10)
            .foregroundColor(.white)
    }
}

//struct ChatItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatItemView()
//    }
//}
