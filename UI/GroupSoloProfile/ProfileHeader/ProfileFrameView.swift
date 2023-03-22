//
//  ProfileFrameView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//

import SwiftUI

struct ProfileFrameView: View {
    
    let teamInfo : FirebaseTeam
    let image : UIImage
    @State private var level : Int = 0
    @State private var progress : Float = 0.0
    @State private var nextLevel : Int = 1
    @Binding var teamPicLoaded : Bool

    var body: some View {
        GeometryReader { geo in
            
            VStack{
                
                
                VStack{
//                    Text("\(progress)")
//                    Text("\(level)")
                    Text("\(teamInfo.lifetimeLovolBits)/\(nextLevel)")
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                        .padding(.bottom,5)

                    ZStack{
                        
                        if teamPicLoaded {
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
                        }else{
                            Circle().stroke(.white, lineWidth: 5)
                                .frame(width:geo.size.width * 0.35, height: geo.size.width * 0.35)

                        }
             
                        CircleLevelView(progress: progress)
                            .frame(width:geo.size.width * 0.45, height: geo.size.width * 0.45)

                    }
 
                }
                .padding(.vertical,5)
                HStack{
                    
                    Text(teamInfo.teamName)
                        .font(.custom("Rubik Regular", size: 20)).foregroundColor(.white).textCase(.uppercase)
//                        .padding(.top,10)
//                    Button {
//
//                    } label: {
//                        NavigationLink(destination: EditGroupProfileView( groupId: teamInfo.id)) {
//                            Image(systemName: "pencil.circle.fill").foregroundColor(.white)
//
//                        }
//                    }
                    
                }
                .frame(width:geo.size.width * 0.9)
                HStack{
                    Text("Team ID Code: ").foregroundColor(.white).opacity(0.6)
                        .font(.custom("Rubik Regular", size: 12))
                    Text("\(teamInfo.id)").foregroundColor(.white)
                        .font(.custom("Rubik Regular", size: 14))
                    Button {
                        UIPasteboard.general.string = teamInfo.id

                    } label: {
                        Image(systemName:"doc.on.clipboard.fill").foregroundColor(.white)
                    }

                   
                }
                .padding(10)

    
                ProfileStatsView(teamInfo:teamInfo, level: level)
                    .frame(height:geo.size.height * 0.3)
                    .padding(.bottom,5)
                
//                Text(teamDescription)
//                    .padding()
//                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white).multilineTextAlignment(.center)
//                    .frame(width:geo.size.width * 0.85, height: geo.size.height * 0.3)
//                    .foregroundColor(.white)
                
            }
            .padding(.top,20)
            .onAppear(perform:levels)
            
        }
    }
    private func levels(){

        if teamInfo.lifetimeLovolBits < 50 {
            self.level = 1
            self.nextLevel = 50
            let totalBits : Float = Float(teamInfo.lifetimeLovolBits)
            let floatLevel : Float = Float(level)

            self.progress = totalBits / ((floatLevel+1) * 50)
            return
        }
        
        self.level = (teamInfo.lifetimeLovolBits + 50) / 50
        
        let totalBits : Float = Float(teamInfo.lifetimeLovolBits)
        let floatLevel : Float = Float(level)
        self.nextLevel = (level+1) * 50
        self.progress = totalBits / ((floatLevel+1) * 50)
        
        
       
        
    }
}

//struct ProfileFrameView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileFrameView(teamInfo: FirebaseTeam(id: "", teamName: "Anthony", teamDescription: "", teamRule: false, teamPoints: 40, teamMemberNames: [], teamMemberRoles: [], teamMemberIDS: [], suggestedEvents: [], chosenEvent: "", requests: [], achievements: [], alliances: [], exists: false, setTimeForChosenEvent: "", teamLovols: 4, lifeTimeLovols: 4, city: "", long: 0, lat: 0, timeCreated: "", locationSet: false, address: "", lifetimeLovolBits: 210, totalEventsCompleted: 3), image: UIImage(named:"elon_musk")!)
//    }
//}
struct CircleLevelView: View {
    
     var progress: Float
//    let model : NewUserProfile
    var body: some View {
        
        ZStack {
//            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
//                .font(.largeTitle)
//                .bold()
//                .foregroundColor(AppColor.lovolDarkPurple)
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(AppColor.lovolPinkish)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                   .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                   .foregroundColor(AppColor.lovolRedPyramid)
                   .rotationEffect(Angle(degrees: 270.0))
                   .animation(.linear, value: progress)

        }
    }
}
