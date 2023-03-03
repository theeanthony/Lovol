//
//  ProfilePicWithStatsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//
 
import SwiftUI

struct ProfilePicWithStatsView: View {
    let teamInfo: FirebaseTeam
 
    let image : UIImage

    var body: some View {
        GeometryReader{geo in
            
            HStack{
                Spacer()
                ZStack(alignment: .leadingFirstTextBaseline){
                    VStack(spacing:0){
                        
                            Rectangle().fill(AppColor.lovolTop).cornerRadius(30, corners: [.topRight,.bottomRight,.bottomLeft])
                            
                                .frame(width:geo.size.width * 0.7,height:geo.size.width * 0.120)
                                .offset(x:-20)
                                .overlay(
                                    ZStack{
//                                        Rectangle().stroke(.white,lineWidth:1).cornerRadius(30, corners: [.topRight,.bottomRight,.bottomLeft]).offset(x:-20)
                                        HStack{
                                            Spacer()
                                            Text("Level")
                                                .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white)
                                            Text("\(2)")
                                                .font(.custom("Rubik Regular", size: 20)).foregroundColor(.white)                                        }
                                        .frame(width:geo.size.width * 0.4)

                                    }
                                )

                            


                        Rectangle().fill(AppColor.lovolMid).cornerRadius(30, corners: [.topRight,.bottomRight])
                            .frame(width:geo.size.width * 0.7,height:geo.size.width * 0.120)
                            .offset(x:15)
                            .overlay(       ZStack{
//                                Rectangle().stroke(.white,lineWidth:1).cornerRadius(30, corners: [.topRight,.bottomRight,.bottomLeft]).offset(x:15)
                                HStack{
                                    Spacer()
                                    Text("Leader Board")
                                        .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white)
                                    Text("#\(2)")
                                        .font(.custom("Rubik Regular", size: 20)).foregroundColor(.white)

                                }
                                .frame(width:geo.size.width * 0.65)

                            }
                            )
                        Rectangle().fill(AppColor.lovolDarkerPurpleBackground).cornerRadius(30, corners: [.topRight,.topLeft,.bottomLeft])
                            .frame(width:geo.size.width * 0.7,height:geo.size.width * 0.120)
                            .offset(x:35)
                            .overlay(        ZStack{
//                                Rectangle().stroke(.white,lineWidth:1).cornerRadius(30, corners: [.topRight,.bottomRight,.bottomLeft]).offset(x:35)
                                HStack{
                                    Spacer()
                                    Text("\(2000) LB - ")
                                        .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white)
                                    Text("\(2) Lovols")
                                        .font(.custom("Rubik Regular", size: 20)).foregroundColor(.white)
                                }
                                .frame(width:geo.size.width * 0.85)
                            }
                                             
                            )

                        
                    }
                    Image(uiImage: image)
                        .resizable()
                        .centerCropped()
//                        .frame(width:geo.size.width * 0.29, height: geo.size.width * 0.29)
                        .frame(width:geo.size.width * 0.35, height: geo.size.width * 0.35)

                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(.white, lineWidth: 5)
                            )
                    
              

                }
                Spacer()
            } .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
            
            
        }
  
    }
}

//struct ProfilePicWithStatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePicWithStatsView(teamInfo: FirebaseTeam(id: "", teamName: "Anthony", teamDescription: "", teamRule: false, teamPoints: 20, teamMemberNames: [], teamMemberRoles: [], teamMemberIDS: [], suggestedEvents: [], chosenEvent: "", requests: [], achievements: [], alliances: [], exists: false, setTimeForChosenEvent: "", teamLovols: 3, lifeTimeLovols: 5, city: "", long: 0, lat: 0, timeCreated: "", locationSet: false, address: "", lifetimeLovolBits: 100, totalEventsCompleted: 10), image:UIImage(named:"elon_musk")!)
//    }
//}
