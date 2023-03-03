//
//  TeamBioAndPic.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct TeamBioAndPic: View {
    let description: String
    let teamName : String
    let profilePic : UIImage
    
 
    var body: some View {
        GeometryReader{geo in
            VStack(spacing:0){
                HStack{
                    Image(uiImage: profilePic)
                        .resizable()
                        .centerCropped()
                        .frame(width:80, height: 80)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(.black,lineWidth:2)
                        )

                        .padding()
                    Text(teamName)
                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolDarkPurple).multilineTextAlignment(.center)
                    Spacer()
                }
                .frame(width:geo.size.width * 0.9)

                .padding()
                HStack{
                    Text(description)
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkPurple).multilineTextAlignment(.center)
//                    Spacer()
                }
                .frame(width:geo.size.width * 0.8)
//                .frame(height:geo.size.height)
                       
                        

         
            }
            .frame(width: geo.size.width * 0.9)

                      }
    }
}

struct TeamBioAndPic_Previews: PreviewProvider {
    static var previews: some View {
        TeamBioAndPic(description: "We like to have fun and do cool things you should our group just for that reason you’ll find out why we’re called crazy", teamName: "Crazy Eights", profilePic: UIImage(named:"elon_musk")!)
    }
}
