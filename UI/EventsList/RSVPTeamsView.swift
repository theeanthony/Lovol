//
//  RSVPTeamsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/22/23.
//

import SwiftUI

struct RSVPTeamsView: View {
    
    
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var eventViewModel : EventViewModel
   @Binding var teamsAtteding : [String]
    @State private var teamInfo : [AllianceModel] = []
    @State private var loading : Bool = true
    @State private var error : Bool = false
    
    @State private var teamsAttending : [[String]] = []
    let inAddEventView : Bool
    @Binding var eventId : String
    
    var body: some View {
        VStack{
            GeometryReader{geo in
                if loading{
                    Spacer()
                    HStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                else{
                    if teamInfo.isEmpty{
                        Spacer()
                        HStack{
                            Spacer()
                            Text("No teams have RSVP'd")
                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                                .padding(.top,20)
                        Spacer()
                        }
                        
                    }else{
                        Text("Teams Attending: \(teamsAtteding.count)")
                            .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                            .padding()

                        ScrollView{
                            ForEach(teamInfo,id:\.self){
                                team in
                                HStack{
                                    Image(uiImage: team.teamPic)
                                        .resizable()
                                        .centerCropped()
                                        .frame(width: geo.size.width * 0.15, height: geo.size.width * 0.15)
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                    Text(team.teamName).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                    Spacer()
        //                            Text("View Profile")
        //                                .padding(5)
        //                                .background(RoundedRectangle(cornerRadius: 30).fill(.white).opacity(0.6))
        //                                .font(.custom("Rubik Regular", size: 10)).foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                    
                                    
                                }
                            }
                            
                        }
                        .padding()
                        .padding(.top,30)
                    }
   
                }
                

            }
            Spacer()
        }
        .background(BackgroundView())
        .onAppear(perform: onAppear)
    }
    private func performInAddEventViewVersion(){
        eventViewModel.fetchRSVPSForHost(id: eventId) { result in
            switch result {
            case .success(let teamsGoing):
                self.teamsAtteding = teamsGoing
//                loading = false
                
                if teamsAtteding.isEmpty {
                    teamInfo.removeAll()
                    loading = false
                }
                fetchTeams()
            case .failure(let error):
                print("error fetching rsvps or rsvps dont exist \(error)")
                loading = false
                self.error = true
                
                return
            }
        }
    }
    
    private func fetchTeams(){

     

            profileViewModel.searchAllianceWithoutPictures(ids:teamsAtteding) { result in
                switch result{
                case .success(let teams):
                    print("Teams found \(teams)")
//                    self.teamsAttending.append(teams)
                    loading = false
                    self.teamInfo = teams
                    for team in teamInfo.indices {
                        profileViewModel.fetchGroupMainPicture(profileId: teamInfo[team].groupId) { result in
                            switch result{
                            case .success(let image):
                                print(" got the pic from rsvp it should be updating")
                                teamInfo[team].teamPic = image
                            case .failure(let error):
                                print("error fetching \(teamInfo[team].teamName) picture \(error)")
                            }
                        }
                    }
                    
                    
                case .failure(let error):
                    print("error fetching teams \(error)")
                    loading = false
                    self.error = true
                }
            }
    }
    private func performInLabelViewVersion(){
        teamInfo.removeAll()
        var count = 0
        
        var max = teamsAtteding.count
        
        if max == 0 {
            teamInfo.removeAll()
            loading = false
        }
        for team in teamsAtteding{
            if team == ""{
                continue
            }
            profileViewModel.searchAlliance(id:team) { result in
                switch result{
                case .success(let teams):
                    print("Teams found \(teams)")
                    self.teamInfo.append(teams)
                    count += 1
                    if teamInfo.count > 10 {
                        loading = false
                        return
                    }
                    if count == max {
                        loading = false
                        return
                    }
                    
                case .failure(let error):
                    print("error fetching teams \(error)")
                    self.error = true
                }
            }
        }
    }
    private func onAppear(){
        
        if inAddEventView{
            performInAddEventViewVersion()
        }else{
            performInLabelViewVersion()
        }

 
        

        
    }
}

//struct RSVPTeamsView_Previews: PreviewProvider {
//    static var previews: some View {
//        RSVPTeamsView()
//    }
//}
