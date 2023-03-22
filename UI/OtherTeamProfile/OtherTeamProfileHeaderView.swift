//
//  OtherTeamProfileHeaderView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/16/23.
//

import SwiftUI

struct OtherTeamProfileHeaderView: View {
    
    @State private var teamInfo : FirebaseTeam = FirebaseTeam()
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var loading : Bool = true
    @State private var teamPic : UIImage = UIImage()
    @State private var picLoading : Bool = true
    @Binding var totalEvents : Int
    let groupId : String
    var body: some View {
        VStack{
            
            if loading {
                ProgressView()
            }else{
                
                VStack{
                    HStack{
//                        GeometryReader{geo in

                        if !picLoading {
                            Image(uiImage: teamPic)
                                .resizable()
                                .centerCropped()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        } else {
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                        }

//                        }
                        Spacer()
                        HStack{
                            VStack{
                                Text("\(totalEvents)")
                                    .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                                
                                Text("Events")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                                
                            }
                            VStack{
                                Text("\(teamInfo.alliances.count)")
                                    .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                                
                                Text("Alliances")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                                
                            }

                            VStack{
                                Text("\(teamInfo.teamMemberIDS.count)")
                                    .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                                
                                Text("Members")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                                
                            }

                        }
                        .padding(.top,10)
//                        .padding(.leading,40)
                        Spacer()
                        

                    }
                    VStack{
                        HStack{
                            Text(teamInfo.teamName)
                                .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                            
                            Spacer()
                        }
                        HStack{
                            Text(teamInfo.teamDescription)
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                            
                            Spacer()
                        }
//                        HStack{
//                            Text("#"+teamInfo.id)
//                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
//                            
//                            Spacer()
//                        }
                    }
                    .offset(y:20)

                }
                .padding(.horizontal,15)
                .padding(.top,10)
                
            }
            
        }
        .onAppear(perform: onAppear)
        
    }
    private func onAppear(){
        profileViewModel.fetchTeam(id: groupId) { result in
            switch result {
            case .success(let team):
                self.teamInfo = team
                loading = false
                profileViewModel.fetchGroupMainPicture(profileId: groupId) { result in
                    switch result {
                    case .success( let image):
                        teamPic = image
                        self.picLoading = false
                    case .failure(let error):
                        print("error loading pic \(error)")
                    }
                }
            case .failure(let error):
                print("error fetching team in otherteamprofile header view \(error)")
            }
        }
    }
}

