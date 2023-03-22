//
//  LabelEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct LabelEventView: View {
    
    let inGroupError:Bool
    @Binding var events : [EventModel]
    
//    @State private var enterEvents : [EventModel] = []
    @EnvironmentObject private var eventViewModel : EventViewModel
    
    @State private var chosenEvent : EventModel = EventModel()
    
    let heder : String
 
    @State private var distance : Double = 0
    let locationSet : Bool 
    let long : Double
    let lat : Double
    @State private var isPresented: Bool = false
    
    @State private var isThereDate : Bool = false
    @State private var isThereTotal : Bool = false
    
    @State private var showTeamsGoing : Bool = false
    @State private var chosenSet : [String] = []
    
    @State private var chosenIndex : Int = 0
    
    @State private var eventSaved : Bool = false
    
    @State private var alterableEvents : [EventModel] = []
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack{
              
                    ScrollView(.horizontal){
                      
                            HStack{
                                ForEach(events.indices, id:\.self) { event in
                                    
                                    if event == 6 {
                                        Button {

                                        } label: {
                                            
                                            NavigationLink(destination:IndividualLabelEventView(inGroupError:inGroupError,events: $events , heder:heder,locationSet:locationSet,long:long,lat:lat) ) {
                                                VStack{
                                                    Image(systemName:"chevron.right")
                                                    Text("More Events")
                                                }
                                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                                .frame(width:geo.size.width * 0.2, height:geo.size.width * 0.2)
                                                .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolDarkerPurpleBackground).opacity(0.7))
                                                .padding(.trailing,5)
                                            }
                                 
                                        }
//

                                    }
                                    else if event < 6{
                                    
                                    
                                    Button {
                                        fillEvent(event: events[event],index:event)
                                    } label: {
                                            
                                            VStack{
                                            
                                                ZStack{
                                                    AsyncImage(url: URL(string: events[event].eventURL),
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
                                                                saveEvent(event: events[event], id: event)
                                                            } label: {
                                                                if events[event].didISave!{
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
                                                            Text(events[event].eventName)
                                                            Spacer()
                                                            HStack{
                                                                Image("lovol.currency")
                                                                Text("\(events[event].eventPoints)")
                                                            }
                                                            HStack{
                                                                Image(systemName:"clock.fill")
                                                                Text("\(events[event].eventTime)")
                                                            }
                                                        }
                                                        .padding(.vertical,0.8)
                                                        if events[event].isTempEvent{
                                                            VStack{
                                                                HStack{
                                                                    Text("\(events[event].startingTime!.shortTime) \(events[event].startingTime!.fullDate)")
                                                                    Spacer()
                                                                }
                                                                HStack{
                                                                    Button {
                                                                      
                                                                        RSVPEvent(event:events[event])
                                                                        
                                                                    } label: {
                                                                        Text("RSVPS (\(events[event].totalRSVP!))")
                                                                            .padding(5)
                                                                            .background(RoundedRectangle(cornerRadius:10).fill( LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish,AppColor.lovolNamePink]), startPoint: .top, endPoint: .bottom)))
                                                                        
                                                                    }
                                                                    if events[event].didIRSVP ?? false{
                                                                        Image(systemName:"checkmark")
                                                                    }
                                                                    
                                                          

                                                            
                                                                    Spacer()
                                                                    
                                                                }
                                                                
                                                                
                                                            }
                                                            .padding(.bottom,5)

                                                            
                                                            
                                                        }
                                                        else{
                                                            VStack{
                                                                HStack{
                                                                    
                                                                    if events[event].eventLocation {
                                                                        Image(systemName:"mappin")
                                                                            .foregroundColor(.white)
                                                                        Text(" \(String(format: "%.1f%",events[event].distance!)) miles")
                                                                        Spacer()

                                                                    }
                                                                    else if events[event].eventType == "Home"{
                                                                        Image(systemName:"house.fill")
                                                                            .foregroundColor(.white)

                                                                        Text("Home")
                                                                        Spacer()
                                                                    }
                                                                    else if events[event].eventType == "Local"{
                                                                        Image(systemName:"globe.americas").foregroundColor(.white)
                                                                        Text("Local")
                                                                        Spacer()
                                                                    }
                                                                    else if events[event].eventType == "Adult"{
                                                                        Image(systemName:"eyes.inverse").foregroundColor(.white)
                                                                        Text("Fun")
                                                                        Spacer()
                                                                    }
                                                                   
                                                                }
                                                                .padding(.bottom,5)
                                                                HStack{
                                                                    Text(String(format: "%.1f%", events[event].eventTotalReviews != 0 ? events[event].eventReviewPercentage / Double(events[event].eventTotalReviews) : 0.0)).foregroundColor(.white)
                                                                    Image(systemName: "star.fill")
                                                                        .foregroundColor(.yellow)
                                                                    Text("(\(events[event].eventTotalReviews))").opacity(0.7)
                                                                    Spacer()
                                                                }
                                                                Text("")
                                                            }
                                       
                                                        }

        //                                                Spacer()
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                }
                                                
                                            }
                                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolPinkish))
                                            .padding(.horizontal,5)
                                    }
//                                    .onChange(of: chosenEvent) { newValue in
                              //                                            print("change")
                              //                                            events[event] = newValue
                              //                                        }
                                    .fullScreenCover(isPresented: $isPresented) {
                                        NewEventInformationView(inGroupError:inGroupError,event:$events[chosenIndex])
                                    }
                             
                                  

                                }
                                   
                            }
                        } //hstack above foreach
 
                }
                    .padding(.leading,10)
//                    .padding(.vertical)
//                    .frame(height:200)
                    .scrollIndicators(.hidden)


            }
//            .onAppear(perform: onAppear)
            .sheet(isPresented: $showTeamsGoing) {
                RSVPTeamsView(teamsAtteding: $chosenSet, inAddEventView: false, eventId: $chosenEvent.id)
                .presentationDetents([ .medium])
                    .presentationDragIndicator(.hidden)
                    
                
            }
//            .onAppear(perform: onAppear)

            
            
            
            
            
        }
    }
//    private func onAppear(){
//        self.enterEvents = events
////    }
    ///
//    private func onAppear(){
//
//        self.alterableEvents = events
//    }
    private func RSVPEvent(event:EventModel){
        self.chosenSet = event.groupIDS ?? []
        print("chosen set \(chosenSet)")
        showTeamsGoing = true

    }
    private func fillEvent(event:EventModel,index:Int){
        self.chosenEvent = event
        self.chosenIndex = index

        isPresented.toggle()
        return
    }
    private func saveEvent(event:EventModel, id:Int){
        eventViewModel.saveEvent(id: event.id) { result in
            switch result {
                
//            case .success(0):
//                joinGroupFirstError = true
//                return
            case .success(true):
//                eventSetAlreadyError = true
                self.events[id].didISave = true
                return

            case .success(false):
                self.events[id].didISave = false
                return
            case .failure(_):
//                showDownloadError = true
                return

                
                
                
                
            }
        }
    }
}

//struct LabelEventView_Previews: PreviewProvider {
//    static var events : [EventModel] = [EventModel(id: "", eventName: "Anthony", eventDescription: "This is a cool", eventRules: "", eventAverageCost: 30, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "", eventURL: "", eventOfferings: "", eventTips: "", eventTags: [], isTemp: false,eventReviewPercentage: 39, eventTotalReviews: 3, eventLocation: false
//                                                  ),EventModel(id: "", eventName: "Anthony", eventDescription: "This is a cool", eventRules: "", eventAverageCost: 30, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "", eventURL: "", eventOfferings: "", eventTips: "", eventTags: [], isTemp: true,eventReviewPercentage: 39, eventTotalReviews: 3, eventLocation: false
//                                                              ),EventModel(id: "", eventName: "Anthony", eventDescription: "This is a cool", eventRules: "", eventAverageCost: 30, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "", eventURL: "", eventOfferings: "", eventTips: "", eventTags: [], isTemp: true,eventReviewPercentage: 39, eventTotalReviews: 3, eventLocation: true
//)  ]
//    static var previews: some View {
//        LabelEventView(events:events, heder:"Upcoming Events Hosted By People Near You", long:0,lat:0)
//    }
//}
//
