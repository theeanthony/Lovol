//
//  NewChatView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/26/23.
//

import SwiftUI

struct NewChatView: View {
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    var body: some View {
        VStack{
            
        }
        .onAppear(perform: onAppear)
        .background(BackgroundView())
        
    }
    private func onAppear(){
        
    }
    
    
}

//struct NewChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewChatView()
//    }
//}
