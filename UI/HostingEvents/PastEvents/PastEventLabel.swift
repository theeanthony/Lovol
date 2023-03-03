//
//  PastEventLabel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/21/23.
//

import SwiftUI

struct PastEventLabel: View {
    
    let hostEvent : HostEvent
    
    let groupId : String
    
    @State private var addEvent : Bool = false
    
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(hostEvent.eventName)
                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                Spacer()
//                Button {
//
//                } label: {
//                    Image(systemName:"pencil").foregroundColor(.white)
//                }
                Spacer()
                Button {
                    self.addEvent = true
                } label: {
                    Image(systemName:"plus").foregroundColor(.white)

                }

            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
        .fullScreenCover(isPresented: $addEvent, content: {
            AddEventView(groupId: groupId, hostEvent:hostEvent)
        })
    }
    private func add(){
        
    }
}


