//
//  AllianceBox.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct AllianceBox: View {
    let image : UIImage
    let name : String

    var body: some View {
        
        GeometryReader{ geo in
            VStack(spacing:0){
                ZStack{
                    
                    
//                    Rectangle().fill(AppColor.lovolLightPurple).frame(width:geo.size.width * 0.8,height:geo.size.width * 0.8).cornerRadius(10, corners: [.topLeft,.topRight])
                    Image(uiImage: image)
                        .resizable()
                        .centerCropped()
                        .frame(width:geo.size.width * 0.8, height: geo.size.width * 0.8)
                        .cornerRadius(10, corners: [.topLeft,.topRight])
                        .aspectRatio(contentMode: .fill)
                    
                    //                    .overlay(
                    ////                        RoundedRectangle(cornerRadius: 10).stroke(.black,lineWidth:2).frame(height:100)
                    //                        Rectangle().stroke(.black,lineWidth:2).frame(height:100).cornerRadius(10, corners: [.topLeft,.topRight])
                    //                    )
                    
                    
                    
                    
                    
                }
                Rectangle().fill(AppColor.lovolDarkerPurpleBackground)
                    .frame(width:geo.size.width * 0.8, height:geo.size.width * 0.2)
                    .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    .overlay(
                        VStack{
                            Text(name)
                                .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white)
                            
                        }
                        
                        
                    )
                
            }
        }
    }
}

struct AllianceBox_Previews: PreviewProvider {
    static var previews: some View {
        AllianceBox(image:  UIImage(named: "elon_musk")!, name:"Jabaryakeees")
    }
}
