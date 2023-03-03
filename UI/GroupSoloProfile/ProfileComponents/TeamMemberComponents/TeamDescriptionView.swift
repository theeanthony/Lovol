//
//  TeamDescriptionView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/16/23.
//

import SwiftUI

struct TeamDescriptionView: View {
    let description : String
    var body: some View {
            VStack(spacing: 0){
                HStack{
                    Spacer()
                    Text(description)
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                        .padding()
                        .background(Rectangle().fill(AppColor.lovolPinkPurple).cornerRadius(10, corners: [.topLeft,.bottomRight]))
                        .multilineTextAlignment(.center)
                    Spacer()

                }
                .padding()
//                Rectangle().fill(AppColor.lovolPrettyPurple).frame( height:20).cornerRadius(10, corners: [.bottomLeft,.bottomRight])
                    
                
            }
//                                    .position(x:UIScreen.main.bounds.width/2)

      
    }
}

struct TeamDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        TeamDescriptionView(description: "HEy this is our team we're pretty cool")
    }
}
