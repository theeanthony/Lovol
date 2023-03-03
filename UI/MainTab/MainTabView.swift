//
//  MainTabView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/20/22.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @State private var selection = 0


    
    @State var doneProfile : Bool = false
    @State var groupView : Bool = false
    @State private var groupId : String = ""
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var eventViewModel : EventViewModel

    var body: some View {
        TabView(selection: $selection) {
                NavigationStack {
                    SingleEventView()
                }
                
                .tabItem {
//                    Label("Home", systemImage: "logo")
                    Image(systemName:"house.fill")
//                    Image("logoTab")
//                        .resizable()
//                        .frame(width: 56, height: 56)
//                        .clipped()
//                        .frame(width: 56, height: 56)

                }.accentColor(AppColor.lovolDarkPurple)
                    .tag(0)
//                NavigationView {
//                    MatchListView()
//
//                }
//                .tabItem {
////                    Label("Messages", systemImage: "bubble.left.and.bubble.right.fill")
//                    Image(systemName: "bubble.left.and.bubble.right.fill")
//
//                }.accentColor(AppColor.lovolDarkPurple)
//                    .tag(1)

                NavigationStack {
//                    GroupOrSoloView(groupId: groupId)
                    FeedView()

                }
                .tabItem {
//                    Label("Group", systemImage: "person.3.sequence")
                    Image(systemName:"tv.inset.filled")
                     
                }.accentColor(AppColor.lovolDarkPurple)
                    .tag(3)
                NavigationStack{
                    MainProfileView()
                }
                .tabItem {
//                    Label("Profile", systemImage: "face.smiling.fill")
                    Image(systemName: "face.smiling.fill")
//
                }.accentColor(AppColor.lovolDarkPurple)
                    .tag(4)
        }
//        .toolbarColorScheme(AppColor.lovolPinkish, for: .tabBar)
    }
    private func clearQuery(){
        eventViewModel.clearDocQuery()
//        completedEvents = []
    }
    private func retrieveGroupId(){
        profileViewModel.fetchUserWO { result in
            switch result {
            case .success(let user):
                groupId = user.groupId ?? ""
            case .failure(let error):
                print("error retrieving group id in maintab \(error)")
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
//            .environmentObject(ViewModelFactory.preview)
    }
}
