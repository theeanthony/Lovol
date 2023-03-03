//
//  SuggestedFrame.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct SuggestedFrame: View {
    
    @EnvironmentObject private var eventViewModel : EventViewModel
   @Binding var date : Date 
    var calendar = Calendar.current
    @State private var isThereSetEvent : Bool = false
    let suggestedEvents : [EventModelWithLikes]
    @State private var displayEvents : [EventModelWithLikes] = []
    let chosenEvent : String
    @State private var isPresented : Bool = false
    let groupId : String
    @State private var popUpEvent : EventModel = EventModel()
    
    @State private var initialChosen : Bool = false
    @State private var chosenEventModel : EventModel = EventModel()
    
    @State private var unsavedEvents : String = ""
    
    let teamName: String
    var body: some View {
        
        GeometryReader{ geo in
            VStack{
         
//                HStack{
//                    Text("What's the move").font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).textCase(.uppercase)
//                    Spacer()
//                }
                if initialChosen{
                    
                    SetSuggestionView(events: chosenEventModel, groupId: groupId, note: "Be there or be square", chosen: $initialChosen, setDate: date)
                        .frame(height:geo.size.height * 0.3)
//                        .onDisappear(perform: whenDisappear)
                }else{
                    if displayEvents.count == 0 {
                        VStack{
                            HStack{
                                
                                Spacer()
                                Text("No Saved Events").font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                                Spacer()
                                
                            }
                            Button {
                                
                            } label: {
                                NavigationLink(destination: NewChoicesView()) {
                                    Text("Go")
                                        .padding()
                                        .frame(width:geo.size.width * 0.3)
                                        .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                                        .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolDarkerPurpleBackground))

                                }
                            }

                        }
                    }else{
                        ScrollView(.horizontal){
                            HStack{
                                
                                ForEach(displayEvents.indices, id:\.self) { event in
                                    Button {
                                        fillEvent(event:displayEvents[event].event)

                                    } label: {
                                        SuggestedEventView(teamName:teamName,groupId: groupId, event: displayEvents[event], initialChosen: $initialChosen, chosenEvent: $chosenEventModel, unsavedEvents: $unsavedEvents, date: $date)
                                                .frame(width:geo.size.width * 0.3)
                                                .onChange(of: unsavedEvents, perform: { newValue in
                                                    removeEvent(events: newValue)
                                                })
                                        .fullScreenCover(isPresented: $isPresented) {
                                           NewEventInformationView(event:$popUpEvent)
                                        }

                                    }

                               

                                }

                            }


                            //

                        }
                        .scrollIndicators(.hidden)
                        .frame(height:geo.size.height * 0.7)
                    }
    
                }
                                
               
                
                
                //                Text("\(calendar.dateComponents([.hour,.minute,.day,.month,.year], from: date))").font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
            }
            .padding()
//            .background(AppColor.lovolDarkPurple)
            .onAppear(perform:onAppear)
            
            
        }
    }
    private func removeEvent(events: String){
//        var indexes :  Int = 0
        print("unsaved events \(unsavedEvents)")
        for index in displayEvents.indices {
            if events == displayEvents[index].event.id {
//                indexes = index
                print("removing \(displayEvents[index].event.eventName)")

                self.displayEvents.remove(at: index)
                return
            }
        }
        
    }
    private func onAppear(){
 
        self.displayEvents = suggestedEvents
        print("chosen event \(chosenEvent)")
        if chosenEvent == "" {
            self.initialChosen = false
        }else{
            self.initialChosen = true
        }
//        self.initialChosen = chosenEvent != ""
        print("was the event chosen \(initialChosen)")
        if self.initialChosen {
            
            for event in suggestedEvents {
                if chosenEvent == event.event.id{
                    chosenEventModel = event.event

                }
            }
        }
    }
    private func fillEvent(event:EventModel){
        self.popUpEvent = event
        isPresented.toggle()
        return
    }
}

struct SuggestedFrame_Previews: PreviewProvider {
    
    @State static var date: Date = Date()
    static var previews: some View {
        SuggestedFrame(date: $date, suggestedEvents: [], chosenEvent: "",groupId:"", teamName: "")
    }
}
