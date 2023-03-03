//
//  MatchView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//

import SwiftUI

struct MatchView: View {
    let matchName: String
    let matchImage: UIImage
    let mainName : String
    let mainImage : UIImage
    let onSendMessageButtonClicked: () -> ()
    let onKeepSwipingClicked: () -> ()
    let checkOutQuestionsClicked: () -> ()
    var body: some View {
        
        VStack{
            ScrollView{
                Spacer()
                HStack{
                    Image(uiImage: mainImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(AppColor.lovolDarkPurple,lineWidth:2)
                        )
                    Text(mainName)
                    Spacer()
                    Text(matchName)
                    Image(uiImage: matchImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(AppColor.lovolDarkPurple,lineWidth:2)
                        )
                    
                    
                    
                }
                .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
                Image("its-a-match").resizable().scaledToFit()
               
                Text(String(format: NSLocalizedString("\(mainName) meet \(matchName)", comment: "Text for when two users match"), matchName))
                    .font(.custom("Rubik Bold", size: 18)).foregroundColor(AppColor.lovolTan).padding()
  
                Button(action: checkOutQuestionsClicked, label:{
                    Text("Questions Match Up").padding([.leading,.trailing], 25).padding([.top, .bottom], 15)
                }).background(AppColor.lovolTan).cornerRadius(25).padding(.top)
                    .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                Button(action: onSendMessageButtonClicked, label: {
                    Text("Send Message").padding([.leading,.trailing], 25).padding([.top, .bottom], 15)
                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                    
                }).background(AppColor.lovolTan).cornerRadius(25).padding(.top)
                
                Button(action: onKeepSwipingClicked, label: {
                    Text("Keep Swiping").foregroundColor(.white)
                }).padding(12)
                Spacer()
            }
        }
        .padding()
        .background(LinearGradient(colors: [AppColor.lovolDarkPurple.opacity(0.8), AppColor.lovolPrettyPurple.opacity(0.8),AppColor.lovolPinkish.opacity(0.8)], startPoint: .top, endPoint: .bottom))
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView(matchName: "Elon", matchImage: UIImage(named: "elon_musk")!,mainName: "Jeff", mainImage: UIImage(named: "elon_musk")!, onSendMessageButtonClicked: {}, onKeepSwipingClicked: {}, checkOutQuestionsClicked: {})
//        MatchView(matchName: "Elon", onSendMessageButtonClicked: {}, onKeepSwipingClicked: {}, checkOutQuestionsClicked: {})
    }
}
