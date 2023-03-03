//
//  TrophyFrame.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct TrophyFrame: View {
    
    let trophies : [FirebaseTrophyModel]
    @State var index : Int = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                
                HStack{
                    Rectangle().fill(.white).frame(width:geo.size.width , height:1.5).opacity(0.5)
                }
                HStack{
                    Text("Achievements").font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).textCase(.uppercase)
                    Spacer()
//                    Image(systemName:"arrow.up.left.and.arrow.down.right")
//                        .foregroundColor(.white)
                }
//                .frame(height:geo.size.height * 0.2)
//                .padding(.top,10)
                .frame(width:geo.size.width * 0.9)

                HStack{
                    Button {
                        moveLeft()
                    } label: {
                        Image(systemName:"chevron.left").foregroundColor(.white)

                    }
                    Spacer()
                    TrophyBox(trophy: trophies[(index)])
//                        .frame(height:geo.size.height * 0.5)
                    Spacer()

                    TrophyMain(trophy: trophies[((index + 1 ) % trophies.count) ])

                    Spacer()

                    TrophyBox(trophy: trophies[((index + 2 ) % trophies.count)])


                    Spacer()

                    Button {
                        moveRight()
                    } label: {
                        Image(systemName:"chevron.right").foregroundColor(.white)

                    }
                }
                .frame(width:geo.size.width * 0.9, height:geo.size.height * 0.8)
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
                

            }
//            .frame(width:geo.size.width, height:geo.size.height * 4)
//            .frame(width:.infinity)

//            .padding()
//            .background(AppColor.lovolDarkPurple)
            
            
        }
    }
    private func moveLeft(){
        
        var newIndex = index - 1
        if newIndex < 0 {
            newIndex = trophies.count - 1
        }
        self.index = newIndex
    }
    private func moveRight(){
        var newIndex = index + 1
        if newIndex > trophies.count - 1  {
            newIndex = 0
        }
        self.index = newIndex
    }
    
}
//
//struct TrophyFrame_Previews: PreviewProvider {
//    static var previews: some View {
//        TrophyFrame()
//    }
//}
