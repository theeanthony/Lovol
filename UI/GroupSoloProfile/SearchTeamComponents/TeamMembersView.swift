//
//  TeamMembersView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/16/23.
//

import SwiftUI

struct TeamMembersView: View {
    
    let groupId: String
    let teamMembers : [MemberModel]
    @Binding var requestSent : Bool
    @Binding var duplicateRequest : Bool
    @Binding var waitingTeamName : String
    let teamName : String
    
    let description: String
    let profilePic : UIImage
    
    @Binding var showTeam : Bool
    @Binding var initialSearch : Bool
    var body: some View {
        
        GeometryReader { geo in
            VStack{
                VStack(spacing:0){
                    HStack{
                        Spacer()

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
                            .font(.custom("Rubik Bold", size: 18)).foregroundColor(.white).multilineTextAlignment(.center)
                            .frame(minHeight:40, maxHeight: 300)

                        Spacer()
                    }
//                    .frame(width:geo.size.width * 0.9)

                    HStack{
                        Text(description)
                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white).multilineTextAlignment(.center)
                            .frame(minHeight:50, maxHeight: 200)

                            .padding()

    //                    Spacer()
                    }
                    .frame(width:geo.size.width * 0.7)

//                    .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
//                    .padding(.bottom,20)
//    //                .frame(height:geo.size.height)
                           
                            

             
                }
//                .frame(width: geo.size.width * 0.9)
                HStack{
                    ForEach(0...2, id:\.self){ index in
                        if index < teamMembers.count {
                            TeamMemberView(member: teamMembers[index])
                                .padding()

//                                .frame(width:geo.size.width * 0.4 , height:geo.size.height * 0.5)
//                                .frame(width:geo.size.width * 0.15 , height:geo.size.height * 0.2)

                            
                        }else{
                            EmptyMemberView(groupId: groupId, requestSent: $requestSent, duplicateRequest: $duplicateRequest, teamName: teamName, waitingTeamName: $waitingTeamName)
                                .padding()

                        }
                        
                    }
                    
                }
                .frame(height:geo.size.height * 0.125)
//                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                HStack{
                    ForEach(3...5, id:\.self){ index in
                        if index < teamMembers.count {
                            TeamMemberView(member: teamMembers[index])                                .padding()

                        }else{
                            EmptyMemberView(groupId: groupId, requestSent: $requestSent, duplicateRequest: $duplicateRequest, teamName: teamName, waitingTeamName: $waitingTeamName)
                                .padding()

                        }
                        
                    }
                    
                }
                .padding(.vertical, 30)
//                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)


                
                
                
            }
            .frame(width:geo.size.width * 0.73 , height:geo.size.height * 0.4)
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2.5)

        }            
            
            
    }
}
//
//struct TeamMembersView_Previews: PreviewProvider {
//    
//    static let teamMembers : [MemberModel] = [MemberModel(name: "Anthony", role: "being Cute", pic: UIImage(named:"elon_musk")!),MemberModel(name: "Anthony", role: "being Cute", pic: UIImage(named:"elon_musk")!),MemberModel(name: "Anthony", role: "being Cute", pic: UIImage(named:"elon_musk")!),MemberModel(name: "Anthony", role: "being Cute", pic: UIImage(named:"elon_musk")!)]
//    @State static var requestSent : Bool = false
//    @State static var duplicateRequest : Bool = false
//    @State static var waitingTeamName : String = ""
//    @State static var showTeam : Bool = true
//    @State static var initialSearch : Bool = true
//
//    static var previews: some View {
//        TeamMembersView(groupId: "", teamMembers: teamMembers, requestSent: $requestSent, duplicateRequest: $duplicateRequest, waitingTeamName: $waitingTeamName, teamName: "Team 8", description:"e got so hard at the cripwe got so hard at the cri",profilePic: UIImage(named:"elon_musk")!, showTeam: $showTeam, initialSearch: $initialSearch)
//    }
//}
