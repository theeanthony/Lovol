//
//  GroupOrSoloView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/24/22.
//

import SwiftUI

struct GroupOrSoloView: View {
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var typeOfProfile = 0
    @State var doneProfile : Bool = false
    @State var groupView : Bool = false

    
    @State private var groupBool : Bool = true
    
    @State private var fillGroupId : String = ""
    

     
    var body: some View {
        
        VStack{
            if typeOfProfile == 0 {
                ProfileView()
            }
            else{
                
                if groupBool {
                    ProgressView()
                        .onAppear(perform: retrieveGroup)
                }
                else{
                    if fillGroupId == "" {
                        NoGroupView()

                    }
                    else{
                        GroupProfileView(groupView: $groupView)
//                            .onAppear(perform: retrieveGroup)

                            .onDisappear(perform: erase)


                    }
                }

                
            }
            Spacer()
            Picker("", selection: $typeOfProfile) {
                Text("Profile").tag(0)
                    .foregroundColor(AppColor.lovolTan)

                Text("Team Profile").tag(1)
                    .foregroundColor(AppColor.lovolTan)
//                    .tint(AppColor.lovolTan)
//                    .accentColor(AppColor.lovolTan)

            }
            .foregroundColor(AppColor.lovolTan)

            .pickerStyle(SegmentedPickerStyle())
            .padding(5)
//            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPrettyPurple))

            
            .padding(.horizontal,30)
            .padding(.bottom,20)
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: retrieveGroup)
        
    }
    func erase(){
        print("erase")
        groupBool = true
        fillGroupId = ""
    }
    func retrieveGroup () {
        print("retrieving")
        profileViewModel.fetchUserWO { result in
            switch result {
            case .success(let user):
                let groupIds = user.groupId ?? ""
                print("GROUP ID IN GROUP OR SOLO VIEW \(groupIds) AND \(fillGroupId)")
                if groupIds != "" {
                    self.fillGroupId = groupIds
                    self.groupBool = false
                    return
                }else{
                    self.groupBool = false
                    return
                }
            case .failure(let error):
                print("error fetching groupid when checking grouporsoloview \(error)")
                self.groupBool = false
            }
        }
    }

    
}

//struct GroupOrSoloView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupOrSoloView()
//    }
//}
