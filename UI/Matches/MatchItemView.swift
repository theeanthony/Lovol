//
//  MatchItemView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//

import SwiftUI

struct MatchItemView: View {
    let model: MatchModel
    var body: some View {
        HStack{
            Image(uiImage: model.picture).centerCropped().frame(width: 50, height: 50).cornerRadius(25)
                .padding([.leading,.top,.bottom], 8)
                .padding(.trailing,3)
            VStack(alignment: .leading){
                HStack{
                    Text(model.name).bold()
                    if !model.isGroup{
                        Text("\(model.age)").fontWeight(.light)
                    }
                    
                }
                Text(model.lastMessage ?? "Say something nice!")
                    .fontWeight(.light)
            }.padding(.leading, 6)
            Spacer()
            
            if model.isGroup{
                VStack{
                    Image(systemName: "face.smiling.fill")
                    HStack{
                        Image(systemName: "face.smiling.fill")
                        Image(systemName: "face.smiling.fill")
                    }
                }.padding(.trailing,10)
                
            }else{
                Image(systemName: "face.smiling.fill")
                    .padding(.trailing,20)
                
                
            }
           
        }
            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
            .padding(.horizontal,10)
            .font(.custom("Rubik Regular", size: 14))
            .foregroundColor(AppColor.lovolTan)
             

    }
}

struct MatchChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MatchItemView(model: MatchModel(id: "fefregergerger",userId: "efwerfgregrger",name: "Elon", birthDate: Date(), picture: UIImage(named:"elon_musk")!, lastMessage: "", isGroup: false))
        }.navigationTitle("Messages")
    }
}
