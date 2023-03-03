//
//  BonusChoicesView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import SwiftUI

struct BonusChoicesView: View {
    var musicEvent : BonusMusicVideo
    var choices : [String]
    @State private var chosenCategory : String = "Top Hits"
    @State private var startingIndex : Int = 0
    var body: some View {
        ZStack{
            VStack(spacing:10){
                HStack(spacing:35){
                    Button {
                        
                        chooseCategory(category: "Top Hits", index: 0)
                        
                    } label: {
                        Text("Top Hits")
                            .padding(.bottom,10)
                            .background(RoundedRectangle(cornerRadius: 20).fill("Top Hits" != chosenCategory ? AppColor.lovolTan : AppColor.lovolPrettyPurple).frame(width:80, height:35))
                            .foregroundColor("Top Hits" != chosenCategory ? AppColor.lovolPinkish : AppColor.lovolTan)
                           
                    }
                  
                    Button {
                        chooseCategory(category: "Random", index:2)

                    } label: {
                        Text("Random")
                            .padding(.bottom,10)
                            .background(RoundedRectangle(cornerRadius: 20).fill("Random" != chosenCategory ? AppColor.lovolTan : AppColor.lovolPrettyPurple).frame(width:80, height:35))
                            .foregroundColor("Random" != chosenCategory ? AppColor.lovolPinkish : AppColor.lovolTan)

                    }
                   

                    Button {
                        chooseCategory(category: "Plug", index:4)

                    } label: {
                        Text("Plug")
                            .padding(.bottom,10)
                            .background(RoundedRectangle(cornerRadius: 20).fill("Plug" != chosenCategory ? AppColor.lovolTan : AppColor.lovolPrettyPurple).frame(width:80, height:35))
                            .padding(.leading,10)
                            .foregroundColor("Plug" != chosenCategory ? AppColor.lovolPinkish : AppColor.lovolTan)

                    }
                    Spacer()

                }
                .frame(width:260)
                .font(.custom("Rubik Regular", size: 14))
                VStack(spacing:30){
                    Button {
                        
                    } label: {
                        HStack{
                            NavigationLink(destination: SubmitMusicVideoView(musicEvent: musicEvent, index: 0+startingIndex)) {
                                Text(choices[0+startingIndex])
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                   
                        }
                        .frame(width:250)
                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple).frame(width:280,height:35))
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                    }
                    Button {
                        
                    } label: {
                        HStack{
                            NavigationLink(destination: SubmitMusicVideoView(musicEvent: musicEvent, index: 2+startingIndex)) {
                                Text(choices[2+startingIndex])
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .frame(width:250)

                     
                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple).frame(width:280,height:35))
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                    }
                    Button {
                        
                    } label: {
                        HStack{
                            NavigationLink(destination: SubmitMusicVideoView(musicEvent: musicEvent, index: 4+startingIndex)) {
                                Text(choices[4+startingIndex])
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .frame(width:250)

                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple).frame(width:280,height:35))
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolPinkish).frame(width:300,height:150))

            }
        }
    }
    private func chooseCategory(category: String,index: Int){
        chosenCategory = category
        startingIndex = index
        
    }
}

//struct BonusChoicesView_Previews: PreviewProvider {
//    static var previews: some View {
//        BonusChoicesView(choices: ["A this is a coool song by Anthony","B","C","D","E","F","G","H","I"])
//    }
//}
