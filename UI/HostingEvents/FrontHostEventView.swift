//
//  FrontHostEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct FrontHostEventView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let inGroupError:Bool
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.white)
                  
              }
          }
      }
    @EnvironmentObject private var eventViewModel : EventViewModel
    let groupId:String
    let hostName:String
    @State private var addEvent : Bool = false
    @State private var pendingEvent : Bool = false
    
    @State private var pendingEvents : [HostEvent] = []
    @State private var pastEvents : [HostEvent] = []
    @State private var activateDescriptionView : Bool = false
    @State private var chosenEvent : String = ""
    @State private var showTeamsGoing : Bool = false
    @State private var chosenSet : [String] = []
    @State private var submittedEvent : Bool = false
    var body: some View {
        HStack{
            Spacer()
            VStack{
                
//                Spacer()
                HStack{
                    Text("Events Coming Up...")
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                    Spacer()
                }
                .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)

                .padding(.leading,10)
                .padding(.top,10)
                ScrollView{
                    ForEach(pendingEvents.indices,id:\.self){
                        event in
                        
                        Button {
                            fillEventDescription(event: pendingEvents[event])
                        } label: {
                            PendingEventConfirmedLabel(event: pendingEvents[event], groupId: groupId, hostedEvents: $pendingEvents, index: event,showTeamsGoing:$showTeamsGoing,chosenEvent:$chosenEvent)

                        }

                    }
                }


                Spacer()
                HStack{
                    Text("Past Events...")
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)

                    Spacer()
                }
                .padding(.leading,10)
                ScrollView{
                    ForEach(pastEvents.indices, id:\.self){
                        event in
                        PastEventLabel(hostEvent: pastEvents[event], groupId: groupId, hostName: hostName)
                    }
                }
                Spacer()
                
            }
            Spacer()
        }
        .background(
            BackgroundView()
           
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $addEvent, content: {
            SingleSheetView(groupId: groupId,hostName:hostName, submittedEvent: $submittedEvent)
        })
        .fullScreenCover(isPresented: $pendingEvent, content: {
            FrontPendingEvent(groupId: groupId)
        })
        .fullScreenCover(isPresented: $activateDescriptionView, content: {
            SeeHostEventView(inGroupError:inGroupError,id: $chosenEvent)
        })
        .sheet(isPresented: $submittedEvent, content: {
            QuickSheet(text: "Your submitted event is now pending. Please give us some time to review your event.")
                .presentationDetents([.medium])
        })

        .toolbar{
            ToolbarItemGroup(placement:.navigationBarTrailing) {
                HStack{
                    Button {
                        self.pendingEvent = true
                    } label: {
                        Image(systemName:"clock.fill").foregroundColor(.white)
                    }
                    Button {
                        self.addEvent = true 
                    } label: {
                        Image(systemName:"plus.app").foregroundColor(.white)
                    }

                }
            }
        }
        .sheet(isPresented: $showTeamsGoing) {
            RSVPTeamsView(teamsAtteding: $chosenSet, inAddEventView: true, eventId: $chosenEvent )
                .presentationDetents([ .medium,.large])
                .presentationDragIndicator(.hidden)
                
            
        }
        .onAppear(perform: onAppear)
    }
    private func fillEventDescription(event:HostEvent){
        self.chosenEvent = event.eventId
        activateDescriptionView = true
    }
    private func onAppear(){
        eventViewModel.fetchPendingConfirmedEvents(groupId: groupId) { result in
            switch result {
            case .success(let confirmedEvents):
                self.pendingEvents = confirmedEvents
                
            case .failure(let error):
                print("error fetching confirmeed events \(error)")
                return
            }
            eventViewModel.fetchCompletedConfirmedEvents(groupId: groupId) { result in
                switch result{
                case .success(let completedEvents):
                    self.pastEvents = completedEvents
                    return
                case .failure(let error):
                    print("error fetching completed events \(error)")
                    return 
                }
            }
        }
    }
}

//struct FrontHostEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        FrontHostEventView()
//    }
//}
