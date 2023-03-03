//
//  LeaderBoardTopThree.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/29/23.
//

import SwiftUI

struct LeaderBoardTopThree: View {
    
    @State private var leaders : [LeaderBoardModel] = []
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var loading : Bool = true
    var body: some View {
        
        GeometryReader{ geo in
            HStack{
                if loading{
                    ProgressView()
                        .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
                }else{
                    HStack{
                        Spacer()
                        VStack{
                            Image(uiImage: leaders[2].teamPic)
                                .resizable()
                                .centerCropped()
                                .frame(width: geo.size.width * 0.2, height: geo.size.width * 0.2)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(
                                    ZStack{
                                        Circle().stroke(AppColor.lovolDarkerPurpleBackground,lineWidth:4)
                                        VStack{
                                            Spacer()
                                            ZStack{
                                                Circle().fill(.orange)
                                                    .frame(width: geo.size.width * 0.1, height: geo.size.width * 0.1)
                                                Text("3").font(.custom("Rubik Bold", size: 14)).foregroundColor(AppColor.lovolDarkerPurpleBackground
                                                )
                                          
                                            }
                                            .offset(y:20)
                                        }
                                    }
                                    
                                    
                                )
                            VStack{
                                Text(leaders[2].teamName)
                                    .frame(width: geo.size.width * 0.25)
                                Text("\(leaders[2].teamPoints)")
                            }
                            .offset(y:20)
                            .font(.custom("Rubik Bold", size: 10))
                            .foregroundColor(.white)
                        }
                        Spacer()
                        VStack{
                            Image(uiImage: leaders[0].teamPic)
                                .resizable()
                                .centerCropped()
                                .frame(width: geo.size.width * 0.35, height: geo.size.width * 0.35)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(
                                    ZStack{
                                        Circle().stroke(AppColor.lovolDarkerPurpleBackground,lineWidth:4)
                                        VStack{
                                            Spacer()
                                            ZStack{
                                                Circle().fill(.yellow)
                                                    .frame(width: geo.size.width * 0.1, height: geo.size.width * 0.1)
                                                Text("1").font(.custom("Rubik Bold", size: 14)).foregroundColor(AppColor.lovolDarkerPurpleBackground
                                                )
                                           
                                            }
                                            .offset(y:20)
                                        }
                                    }
                                )
                            VStack{
                                Text(leaders[0].teamName)
                                    .frame(width: geo.size.width * 0.25)
                                Text("\(leaders[0].teamPoints)")
                            }
                            .offset(y:20)
                            .font(.custom("Rubik Bold", size: 10))
                            .foregroundColor(.white)
                        }
                        Spacer()
                        VStack{
                            Image(uiImage: leaders[1].teamPic)
                                .resizable()
                                .centerCropped()
                                .frame(width: geo.size.width * 0.2, height: geo.size.width * 0.2)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(
                                    ZStack{
                                        Circle().stroke(AppColor.lovolDarkerPurpleBackground,lineWidth:4)
                                        VStack{
                                            Spacer()
                                            ZStack{
                                                Circle().fill(.gray)
                                                    .frame(width: geo.size.width * 0.1, height: geo.size.width * 0.1)
                                                Text("2").font(.custom("Rubik Bold", size: 14)).foregroundColor(AppColor.lovolDarkerPurpleBackground
                                                )
                                          
                                            }
                                            .offset(y:20)
                                        }
                                    }
                                )
                            VStack{
                                Text(leaders[1].teamName)
                                    .frame(width: geo.size.width * 0.25)
                                Text("\(leaders[1].teamPoints)")
                            }
                            .offset(y:20)
                            .font(.custom("Rubik Bold", size: 10))
                            .foregroundColor(.white)
                        }
                        Spacer()

                    }
                }
            }
                
            
            
        }
        .onAppear(perform: onAppear)
    }
    private func onAppear(){
        profileViewModel.fetchLeaders { result in
            switch result {
            case .success(let newLeaders):
                var orderLeadersAgain = newLeaders
                    orderLeadersAgain.sort{
                    $0.teamPoints > $1.teamPoints
                }
                self.leaders = orderLeadersAgain
                loading = false
            case .failure(let error):
                print("error downloading leaders \(error)")
                //showError = true
            }
        }
    }
}

struct LeaderBoardTopThree_Previews: PreviewProvider {
    
//    static var leaders : [LeaderBoardModel] = [LeaderBoardModel(teamName: "Antyhony", teamPoints: 200, teamPic: UIImage(named: "elon_musk")!),LeaderBoardModel(teamName: "Antyhony", teamPoints: 200, teamPic: UIImage(named: "elon_musk")!),LeaderBoardModel(teamName: "Antyhony", teamPoints: 200, teamPic: UIImage(named: "elon_musk")!)]
    static var previews: some View {
        LeaderBoardTopThree()
    }
}
