//
//  GroupMembers.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/27/22.
//

import SwiftUI

struct GroupMembers: View {
    @EnvironmentObject private var profilesViewModel : ProfilesViewModel
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @State private var model : [NameAndProfilePic] = [] 
    var groupId: String
    @State private var loading = true
    var body: some View {
        VStack{
        if loading{
            ProgressView()
        }
            else{
                VStack(alignment: .leading){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum:100),spacing: 5),GridItem(.adaptive(minimum: 50, maximum:100),spacing: 5),GridItem(.adaptive(minimum: 50, maximum:100),spacing: 5)], spacing: 10) {
                        ForEach(model.indices, id: \.self){ index in
                            //                    HStack{
                            Image(uiImage: model[index].pictures)
                                .centerCropped()
                                .clipShape(Circle())
                                .frame(width: 45, height: 45)
                                .overlay(
                                    Circle().stroke(AppColor.lovolTan,lineWidth: 2)
                                    
                                )
                            Text(model[index].names)
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                            //                    }
                            
                        }
                    }
                    
                    
                    
                }
            }
          

        }
        .onAppear(perform:fetchUsersAndProfilePics)

    }
    private func fetchUsersAndProfilePics(){
        profilesViewModel.fetchGroup(id: groupId) { result in
            switch result {
            case .success(let group):
                let team = group.usersInGroup
                firestoreViewModel.fetchNamesAndProfilePics(members: team) { result in
                    switch result {
                    case .success(let members):
                        self.model = members
                        loading = false
                    case .failure(let error):
                        print("error fetching names and profile pics of team \(error)")
                    }
                }
            case .failure(let error):
                print("error fetching group \(error)")
                
            }
        }
        
    }
}
//
//struct GroupMembers_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupMembers(groupId: "")
//    }
//}
