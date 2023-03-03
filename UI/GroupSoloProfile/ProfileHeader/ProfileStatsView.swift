//
//  ProfileStatsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/30/23.
//

import SwiftUI

struct ProfileStatsView: View {
    
    let teamInfo: FirebaseTeam
    
    let level : Int

    var body: some View {
        GeometryReader{geo in
            
            HStack{
                Spacer()
                
                VStack{
                    Image(systemName:"arrow.up.forward")
                        .padding()
                        .foregroundColor(AppColor.trophyGreen)
                        .background(Circle().fill(AppColor.trophyGreen).opacity(0.4))
                    Text("\(level)").font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
                    Text("Power")
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.6)

                }
                .frame(width:geo.size.width * 0.3)
                Spacer()
                VStack{
                    Image(systemName:"number")
                        .padding()
                        .foregroundColor(AppColor.trophyPurple)
                        .background(Circle().fill(AppColor.trophyPurple).opacity(0.2))
                    Text("\(teamInfo.teamLovols)").font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
                    Text("Lovols")
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.6)



                }
                .frame(width:geo.size.width * 0.3)

                Spacer()
                VStack{
                    Image(systemName:"hand.thumbsup.fill")
                        .foregroundColor(AppColor.lovolPinkish)

                        .padding()
                        .background(Circle().fill(AppColor.trophyWarmPink).opacity(0.4))
                    Text("\(teamInfo.totalEventsCompleted)")
                        .font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
                    Text("Events")
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.6)


                }
                .frame(width:geo.size.width * 0.3)

                Spacer()
            } .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
            
            
        }
  
    }

        
}

//struct ProfileStatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileStatsView(teamInfo: FirebaseTeam(id: "", teamName: "Anthony", teamDescription: "", teamRule: false, teamPoints: 20, teamMemberNames: [], teamMemberRoles: [], teamMemberIDS: [], suggestedEvents: [], chosenEvent: "", requests: [], achievements: [], alliances: [], exists: false, setTimeForChosenEvent: "", teamLovols: 3, lifeTimeLovols: 5, city: "", long: 0, lat: 0, timeCreated: "", locationSet: false, address: "", lifetimeLovolBits: 100, totalEventsCompleted: 3), level: 2)
//    }
//}
