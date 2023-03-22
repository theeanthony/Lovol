//
//  CommentView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/30/22.
//

import SwiftUI

struct CommentView: View {
    var comment : CommentModel
    @State private var groupId : String = ""
    var body: some View {
        
        VStack{
            
//            if comment.teamName != ""{
//                HStack{
//                    Spacer()
//                    Button {
//                        
//                    } label: {
//                        
//                            Text(comment.teamName)
//                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
//                        }
//               
//
//         
//                    
//                }
//                .padding(.trailing,10)
//
//            }

            HStack{
                Button {
                    
                } label: {
                    NavigationLink(destination: OtherTeamProfileView(groupId:$groupId)) {

                    Text(comment.name)
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
//                    Text(comment.role)
//                        .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white).opacity(0.6)
                    }

                }

                
                Spacer()
            }
            .padding(.leading,10)

            
            HStack{
                Text(comment.comment)
                    .font(.custom("Rubik Regular", size: 12 )).foregroundColor(.white)
                Spacer()
            }
            .padding(.leading,15)
            .padding(.top,2)
//            ExDivider(color: .white.opacity(0.6))

        }
        
//        .padding()
        .onAppear(perform:onAppear)
   

    }
    private func onAppear(){
        self.groupId = comment.teamId
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: CommentModel(name: "ANthony",role:"Chicken Nugget", teamId:"", comment: "This is my comment", teamName: "Autobots"))
    }
}
