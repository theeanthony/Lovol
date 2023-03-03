//
//  ContentMessageView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//

import SwiftUI

struct ContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool

    
    var body: some View {
        
        VStack{
                
            Text(contentMessage)
                .padding(10)
                .foregroundColor(isCurrentUser ? AppColor.lovolTan : AppColor.lovolDarkPurple)
                .background(isCurrentUser ? AppColor.lovolPinkish : AppColor.lovolReceiveMessageColor)
                .cornerRadius(10)
                
        }

    }
}

struct ContentMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMessageView(contentMessage: "Hey this is a sample message." , isCurrentUser: false)
    }
}
