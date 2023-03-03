//
//  ProfileHeaderProfilePicView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/30/23.
//

import SwiftUI

struct ProfileHeaderProfilePicView: View {
    let levels : String = "LEvel 4"
    let leaderBoard : String = "LEader board # 4"
    
    let totalPoints : String = "20000 LB 2 lovols c"
    let image : UIImage

    var body: some View {
        GeometryReader{geo in
            
            VStack{
                    Image(uiImage: image)
                        .resizable()
                        .centerCropped()
                        .aspectRatio(contentMode: .fit)

//                        .frame(width:geo.size.width * 0.29, height: geo.size.width * 0.29)
                        .frame(width:geo.size.width * 0.35, height: geo.size.width * 0.35)

//                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(.white, lineWidth: 5)
                            )
                    
              

                }
                Spacer()
            } .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
            
            
        }
  
    }


struct ProfileHeaderProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderProfilePicView(image: UIImage(named:"elon_musk")!)
    }
}
