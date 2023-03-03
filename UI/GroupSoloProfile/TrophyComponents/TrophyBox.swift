//
//  TrophyBox.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct TrophyBox: View {
    
  
    var trophy : FirebaseTrophyModel
    var body: some View {
        GeometryReader{ geo in
            HStack{
                Spacer()
            VStack(spacing:0){
        
                
                    ZStack{
                        Rectangle().fill(AppColor.lovolDarkerPurpleBackground).frame(width:geo.size.width * 0.7, height: geo.size.width * 0.7).cornerRadius(10, corners: [.topLeft,.topRight])
                        Image(uiImage: UIImage(named: trophy.trophy.image)!)
                            .resizable()
                            .centerCropped()
                            .frame(width:geo.size.width * 0.5, height: geo.size.width * 0.5)
                            .aspectRatio(contentMode: .fill)
                        
                        //                    .overlay(
                        ////                        RoundedRectangle(cornerRadius: 10).stroke(.black,lineWidth:2).frame(height:100)
                        //                        Rectangle().stroke(.black,lineWidth:2).frame(height:100).cornerRadius(10, corners: [.topLeft,.topRight])
                        //                    )
                        
                        
                        
                        
                        
                    }
                    Rectangle().fill(AppColor.lovolPinkPurple)
                        .frame(width:geo.size.width * 0.7, height: geo.size.width * 0.3)
                        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                        .overlay(
                            VStack{
                                Text(trophy.trophy.name)
                                    .font(.custom("Rubik Regular", size: 9)).foregroundColor(.white)
                                
                            }
                            
                            
                        )
                  
                    
                }
                Spacer()
                //            .frame(width:geo.size.width * 0.6,height:geo.size.height * 0.6)
            }
        }
    }
}

//struct TrophyBox_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack{
//            TrophyMain( trophyName: "I'm awesome")
//            TrophyBox( trophyName: "I'm awesome")
//        }
//    }
//}

struct TrophyMain : View {
    var trophy : FirebaseTrophyModel

    var body: some View {
        GeometryReader{ geo in
            HStack{
                Spacer()
            VStack(spacing:0){
             
                    ZStack{
                        
                        Rectangle().fill(AppColor.lovolDarkerPurpleBackground) .frame(width:geo.size.width * 0.85, height: geo.size.width * 0.85).cornerRadius( 10, corners:[.topRight,.topLeft])
                        Image(uiImage: UIImage(named: trophy.trophy.image)!)
                            .resizable()
                            .centerCropped()
                            .frame(width:geo.size.width * 0.65, height: geo.size.width * 0.65)
                            .aspectRatio(contentMode: .fill)
                        
                        //                        .background(Rectangle().fill(AppColor.lovolDarkPurple) .frame(width:geo.size.width * 0.25, height: geo.size.width * 0.25).cornerRadius( 10, corners:[.topRight,.topLeft]))
                        
                    }
                    Rectangle().fill(AppColor.lovolPinkPurple)
                    
                        .frame(width:geo.size.width * 0.85, height: geo.size.width * 0.3)
                        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                        .overlay(
                            VStack{
                                Text(trophy.trophy.name)
                                    .font(.custom("Rubik Regular", size: 11)).foregroundColor(.white)
                                
                            }
                            
                            
                        )
                   
                    
                }
                Spacer()
                //            .frame(width:geo.size.width * 0.8,height:geo.size.height * 0.8)
                
            }
        }
    }
}
