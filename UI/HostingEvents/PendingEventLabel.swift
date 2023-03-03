//
//  PendingEventLabel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/21/23.
//

import SwiftUI

struct PendingEventLabel: View {
    
    @EnvironmentObject private var eventViewModel : EventViewModel
    let event : HostEvent
    let groupId : String
    
    @Binding var hostedEvents : [HostEvent]
    let index : Int 
    
//    let pendingOrCompletedOrPast : Int
    
    @State private var edit : Bool = false
    @State private var delete : Bool = false
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(event.eventName)
                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                Spacer()
//                Button {
//                    
//                } label: {
//                    Image(systemName:"pencil").foregroundColor(.white)
//                }
                Spacer()
                Button {
                    self.delete = true
                } label: {
                    Image(systemName:"xmark").foregroundColor(.white)

                }

            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
        .alert("Are you sure you want to delete this event?", isPresented: $delete, actions: {
            Button("Yes", role: .destructive, action: {
                deletePendingEvent()
            })
            Button("No",role:.cancel, action:{
                self.delete = false 
            })
        })
    }
    func deletePendingEvent(){
        eventViewModel.deletePendingEvent(id: event.eventId, groupId: groupId)
        self.hostedEvents.remove(at: index)
    }
}
//
//struct PendingEventLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        PendingEventLabel(eventName: "Practice Event Name")
//    }
//}
