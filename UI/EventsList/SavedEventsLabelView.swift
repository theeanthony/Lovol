//
//  LabelEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI
struct SavedEvent {
    var event : EventModel
    let teamName: String
    let note :String
    let date : Date
    let eventId : String
    
}
struct SavedEventsLabel: View {
    
    
//    @State private var enterEvents : [EventModel] = []
    @EnvironmentObject private var  eventViewModel : EventViewModel
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var chosenEvent : EventModel = EventModel()
    
//    @State private var events : [EventModel] = []
    
    @State private var events : [EventModel] = []
    
    @State private var savedEvents : [SavedEvent] = []
    
//    [SavedEvent] = [SavedEvent(event:EventModel(id: "", eventName: "Sunset", eventDescription: "Description for this event", eventRules: "", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "", eventURL: "", eventOfferings: "", eventTips: "", eventTags: [], isTemp: false, eventReviewPercentage: 0, eventTotalReviews: 0, eventLocation: false, long: 0, lat: 0),teamName:"Team Anthony",note:"Be there or be square",date:Date()),SavedEvent(event:EventModel(id: "", eventName: "Sunset", eventDescription: "Description for this event", eventRules: "", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "", eventURL: "", eventOfferings: "", eventTips: "", eventTags: [], isTemp: true, eventReviewPercentage: 0, eventTotalReviews: 0, eventLocation: true, long: 0, lat: 0,distance:3),teamName:"Team Anthony",note:"Be there or be square",date:Date())]
    
//    let heder : String
 
    let currentRSVPAmount : Int = 100
    let alreadyRSVP : Bool = false
    @State private var distance : Double = 0
//    let locationSet : Bool
//    let long : Double
//    let lat : Double
    @State private var isPresented: Bool = false
    
    @Binding  var showSaves : Bool 
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack{
//                HStack{
//                    Text(heder)
//                        .font(.custom("Rubik Regular", size: 22)).foregroundColor(.white).textCase(.uppercase)
////                        .padding()
//                    Spacer()
//                    Image(systemName:"chevron.right")
//                        .foregroundColor(.white)
//                        .padding(.trailing)
//                }
//                .frame(width:geo.size.width * 0.9)
////                .padding(.vertical)
              
                    ScrollView(.horizontal){
                      
                            HStack{
                                ForEach(savedEvents.indices, id:\.self) { event in
                                    HStack{
                                        //                                    if event.indices == 6 {
                                        //                                        Button {
                                        //
                                        //                                        } label: {
                                        //                                            VStack{
                                        //                                                Image(systemName:"chevron.right")
                                        //                                                Text("More Events")
                                        //                                            }
                                        //                                            .frame(width:geo.size.width * 0.2, height:geo.size.width * 0.2)
                                        //                                            .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolDarkerPurpleBackground).opacity(0.7))
                                        //                                        }
                                        //                                        break
                                        //
                                        //
                                        //                                    }
                                        //                                    else{
                                        
                                        
                                        Button {
                                            //                                        fillEvent(event: savedEvents.events[event])
                                        } label: {
                                            
                                            VStack{
                                                
                                                ZStack{
                                                    AsyncImage(url: URL(string: savedEvents[event].event.eventURL),
                                                               content: { image in
                                                        image.resizable()
                                                        
                                                            .centerCropped()
                                                            .clipShape(Rectangle())
                                                            .cornerRadius(10,corners:[.topLeft,.topRight])
                                                        //                                                                                        .aspectRatio(contentMode: .fit)
                                                            .frame(width:geo.size.width * 0.9, height: 150)
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    },
                                                               placeholder: {
                                                        ProgressView()
                                                        
                                                        Rectangle()
                                                            .frame(width:geo.size.width * 0.9, height: 150)
                                                        
                                                            .cornerRadius(10,corners:[.topLeft,.topRight])
                                                        //                                                                                        .aspectRatio(contentMode: .fit)
                                                        
                                                        
                                                    })
                                                    VStack{
                                                        HStack{
                                                            Spacer()
                                                            Button {
                                                                
                                                            } label: {
                                                                if savedEvents[event].event.didISave!{
                                                                    Image(systemName:"heart.fill")
                                                                        .foregroundColor(.red)
                                                                }else{
                                                                    Image(systemName:"heart")
                                                                }
                                                            }
                                                            
                                                            
                                                        }
                                                        Spacer()
                                                    }
                                                    .frame(width:geo.size.width * 0.82, height:130)
                                                }
                                                //                                        Spacer()
                                                HStack{
                                                    Spacer()
                                                    VStack{
                                                        HStack{
                                                            Text(savedEvents[event].event.eventName)
                                                            Spacer()
                                                            HStack{
                                                                Image("lovol.currency")
                                                                Text("\(savedEvents[event].event.eventPoints)")
                                                            }
                                                            HStack{
                                                                Image(systemName:"clock.fill")
                                                                Text("\(savedEvents[event].event.eventTime)")
                                                            }
                                                        }
                                                        .padding(.vertical,0.8)
//                                                        if savedEvents[event].event.isTempEvent{
//                                                            VStack{
//                                                                HStack{
//                                                                    Text("\(Date().shortTime) \(Date().fullDate)")
//                                                                    Spacer()
//                                                                }
//                                                                HStack{
//                                                                    Button {
//                                                                        
//                                                                    } label: {
//                                                                        Text("RSVP")
//                                                                            .padding(5)
//                                                                            .background(RoundedRectangle(cornerRadius:10).fill( LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish,AppColor.lovolNamePink]), startPoint: .top, endPoint: .bottom)))
//                                                                        
//                                                                    }
//                                                                    Text("(\(currentRSVPAmount))").opacity(0.8)
//                                                                    if alreadyRSVP{
//                                                                        Image(systemName:"checkmark")
//                                                                    }
//                                                                    Spacer()
//                                                                    
//                                                                }
//                                                                
//                                                                
//                                                            }
//                                                            .padding(.bottom,5)
//                                                            
//                                                            
//                                                            
//                                                        }
//                                                        else{
//                                                            VStack{
//                                                                HStack{
//                                                                    
//                                                                    if savedEvents[event].event.eventLocation {
//                                                                        Image(systemName:"mappin")
//                                                                            .foregroundColor(.white)
//                                                                        Text(" \(String(format: "%.1f%",savedEvents[event].event.distance!)) miles")
//                                                                        Spacer()
//                                                                        
//                                                                    }
//                                                                    else if savedEvents[event].event.eventType == "Home"{
//                                                                        Image(systemName:"house.fill")
//                                                                            .foregroundColor(.white)
//                                                                        
//                                                                        Text("Home")
//                                                                        Spacer()
//                                                                    }
//                                                                    
//                                                                }
//                                                                .padding(.bottom,5)
//                                                                HStack{
//                                                                    Text(String(format: "%.1f%", savedEvents[event].event.eventTotalReviews != 0 ? savedEvents[event].event.eventReviewPercentage / Double(savedEvents[event].event.eventTotalReviews) : 0.0))
//                                                                    Image(systemName: "star.fill")
//                                                                        .foregroundColor(.yellow)
//                                                                    Text("(\(savedEvents[event].event.eventTotalReviews))").opacity(0.7)
//                                                                    Spacer()
//                                                                }
//                                                                Text("")
//                                                            }
//                                                            
//                                                        }
                                                        VStack{
                                                            HStack{
                                                                Text(savedEvents[event].note)
                                                                Spacer()
                                                            }
                                                            HStack{
                                                                Text("Meet @ \(savedEvents[event].date)")
                                                                Spacer()
                                                            }
                                                        }
                                                        
                                                        //                                                Spacer()
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                }
                                                
                                            }
                                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolDarkerPurpleBackground))
                                            .padding(.horizontal,2)
                                        }
                                        .fullScreenCover(isPresented: $isPresented) {
                                            NewEventInformationView(event:$chosenEvent)
                                        }
                                        
                                        //                                }
                                        
                                    }
                                }.frame(width:geo.size.width * 0.9)
                        } //hstack above foreach
 
                }
                    .padding(.leading,10)
//                    .padding(.vertical)
//                    .frame(height:200)
                    .scrollIndicators(.hidden)


            }
            .onAppear(perform: onAppear)

            
            
            
            
            
        }
    }
    private func onAppear(){
        
        profileViewModel.fetchTeamWithoutID { result in
            switch result {
            case .success(let team):
                
                let groupId = team.id
                let alliances = team.alliances
                let locationSet = team.locationSet
                let teamLong = team.long
                let teamLat = team.lat
                
                eventViewModel.fetchSavedEvents(alliances: alliances, groupId: groupId) { result in
                    switch result{
                    case .success(let saves):
                        
                        eventViewModel.convertSavedEvents(locationSet: locationSet, long: teamLong, lat: teamLat, eventIds: saves) { result in
                
                        }
                        
                        eventViewModel.convertSavedEvents(locationSet: locationSet, long: teamLong, lat: teamLat, eventIds: saves) { result in
                            switch result{
                            case .success(let fetchedEvents):
                                self.savedEvents = fetchedEvents
                                self.showSaves = true
                            case .failure(_):
                                self.showSaves = false
                            }
                        }
                    case .failure(let error):
                        print("Error saving events \(error)")
                        
                        self.showSaves = false
                        
                    }
                }
            case .failure(let error):
                print("error fetching team \(error)")
                self.showSaves = false
            }
        }

    }
    private func fillEvent(event:EventModel){
        self.chosenEvent = event
        isPresented.toggle()
        return
    }
}
//
//struct SavedEventsLabel_Previews: PreviewProvider {
//    
  

//    static var previews: some View {
//        SavedEventsLabel(heder: "Saved Events", locationSet: true, long: 0, lat: 0)
//    }
//}

