//
//  PendingEventConfirmedLabel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/21/23.
//

import SwiftUI

struct PendingEventConfirmedLabel: View {
    @EnvironmentObject private var eventViewModel : EventViewModel
    let event : HostEvent
    let groupId : String
    
    @Binding var hostedEvents : [HostEvent]
    let index : Int
    
    @Binding var showTeamsGoing : Bool
    @Binding var chosenEvent : String

//    let pendingOrCompletedOrPast : Int
    
    @State private var add : Bool = false
    @State private var delete : Bool = false
    var body: some View {
        VStack{
            
            
            HStack{
                Text(event.eventName)
                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
              


                Spacer()
                Button {
                    self.delete = true
//                    self.add = true
                } label: {
                    Image(systemName:"xmark").foregroundColor(.white)

                }

            }
            HStack{
                Text("Starting: \(event.eventStartTime.shortTime) \(event.eventStartTime.fullDate)")

                Spacer()
            }.font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
            HStack{
                Text("Ending: \(event.eventEndTime.shortTime) \(event.eventEndTime.fullDate)")

                Spacer()
            }.font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
            
            Button {
                self.chosenEvent = event.eventId
                self.showTeamsGoing = true 
            } label: {
                Text("See who has RSVPD").font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)

            }
            .padding(.top)



        }                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

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

