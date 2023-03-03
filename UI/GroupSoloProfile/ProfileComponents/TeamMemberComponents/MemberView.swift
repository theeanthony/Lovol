//
//  MemberView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/16/23.
//

import SwiftUI

struct MemberView: View {
    let name : String
    let role : String
    let profilePic : UIImage
    var body: some View {
        
        GeometryReader{ geo in
            HStack{
                Spacer()
                VStack(spacing:0){
                    ZStack{
                        
                        
                        
                        Image(uiImage: profilePic)
                            .resizable()
                            .centerCropped()
                            .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.5)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Rectangle())
                        
                            .cornerRadius(10, corners: [.topRight,.topLeft])

                    }
                    Rectangle().fill(AppColor.lovolDarkerPurpleBackground)
                        .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.1)
                        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                        .overlay(
                            VStack{
                                Text(name)
                                    .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white)
                                Text(role)
                                    .font(.custom("Rubik Regular", size: 8)).foregroundColor(AppColor.lovolLightGray)
                            }
                            
                            
                        )
                    
                }
                .background(RoundedRectangle(cornerRadius:10).stroke(.black,lineWidth:2))
          
               
                Spacer()
                
            }
        }
    }
}

//struct MemberView_Previews: PreviewProvider {
//    static var previews: some View {
//        FillMemberView()
//    }
//}

struct FillMemberView : View {
    var body: some View {
        
        GeometryReader { geo in
            HStack{
                Spacer()
                VStack(spacing:0){
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkerPurpleBackground) .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.6)
                            .overlay(
                                Button(action: {
                                    
                                }, label: {
                                    HStack{
                                        Text("Invite ")
                                        Image(systemName: "paperplane")
                                    }
                                    .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white)
                                })
                                
                            )
                    }
                    
                }
                Spacer()
            }
        }
    }
    
}
