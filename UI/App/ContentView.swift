//
//  ContentView.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var authState: AuthState? = .loading
    @EnvironmentObject var loginViewModel: AuthViewModel
    @EnvironmentObject var profileViewModel: ProfilesViewModel
    @EnvironmentObject var eventViewModel : EventViewModel
    

    init() {
        UITabBar.appearance().backgroundColor = UIColor(AppColor.lovolDark)
        UITabBar.appearance().unselectedItemTintColor = UIColor(.white)
//            UISegmentedControl.appearance().selectedSegmentTintColor =  UIColor(AppColor.lovolDarkPurple)
            UISegmentedControl.appearance().backgroundColor = UIColor(AppColor.lovolPinkish)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor :UIColor(AppColor.lovolTan)], for: .normal)

    }
//    @Environment(\.scenePhase) private var scenePhase

//
//    @Binding var localUser: [LocalUser]
//    let saveAction: ()->Void

    
    @ViewBuilder
    func contentBuilder() -> some View {
        switch(loginViewModel.authState){
        case .loading:
            ProgressView()
        case .logged:
            MainTabView()
//                .onAppear {
//
//                    let events = loadJson()
//                    eventViewModel.uploadEvents(events: events)
////                    print(loadJson())
//
//                }
        case .unlogged:
            LoginAndSignUpView()
        case .pendingInformation:
            Over21View()
            //            CreateProfileView()
        }
    }
    
    var body: some View {
        contentBuilder()
            .onAppear(perform: {
                loginViewModel.updateAuthState()
                
            })
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView( localUser: <#Binding<[LocalUser]>#>)
//    }
//}
