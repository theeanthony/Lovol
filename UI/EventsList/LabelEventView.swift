//
//  LabelEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct LabelEventView: View {
    
    let events : [EventModel]
    
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
    
    @State private var eventSaved : Bool = false
    
    @State private var alterableEvents : [EventModel] = []
    
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack{
              
                    ScrollView(.horizontal){
                      
                            HStack{
                                ForEach(alterableEvents.indices, id:\.self) { event in
                                    
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
                                        fillEvent(event: alterableEvents[event])
                                    } label: {
                                            
                                            VStack{
                                            
                                                ZStack{
                                                    AsyncImage(url: URL(string: alterableEvents[event].eventURL),
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
                                                                saveEvent(event: alterableEvents[event], id: event)
                                                            } label: {
                                                                if alterableEvents[event].didISave!{
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
                                                            Text(alterableEvents[event].eventName)
                                                            Spacer()
                                                            HStack{
                                                                Image("lovol.currency")
                                                                Text("\(alterableEvents[event].eventPoints)")
                                                            }
                                                            HStack{
                                                                Image(systemName:"clock.fill")
                                                                Text("\(alterableEvents[event].eventTime)")
                                                            }
                                                        }
                                                        .padding(.vertical,0.8)
                                                        if alterableEvents[event].isTempEvent{
                                                            VStack{
                                                                HStack{
                                                                    Text("\(alterableEvents[event].startingTime!.shortTime) \(alterableEvents[event].startingTime!.fullDate)")
                                                                    Spacer()
                                                                }
                                                                HStack{
                                                                    Button {
                                                                      
                                                                        RSVPEvent(event:alterableEvents[event])
                                                                        
                                                                    } label: {
                                                                        Text("RSVPS (\(alterableEvents[event].totalRSVP!))")
                                                                            .padding(5)
                                                                            .background(RoundedRectangle(cornerRadius:10).fill( LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish,AppColor.lovolNamePink]), startPoint: .top, endPoint: .bottom)))
                                                                        
                                                                    }
                                                                    if alterableEvents[event].didIRSVP ?? false{
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
                                                                    
                                                                    if alterableEvents[event].eventLocation {
                                                                        Image(systemName:"mappin")
                                                                            .foregroundColor(.white)
                                                                        Text(" \(String(format: "%.1f%",alterableEvents[event].distance!)) miles")
                                                                        Spacer()

                                                                    }
                                                                    else if alterableEvents[event].eventType == "Home"{
                                                                        Image(systemName:"house.fill")
                                                                            .foregroundColor(.white)

                                                                        Text("Home")
                                                                        Spacer()
                                                                    }
                                                                   
                                                                }
                                                                .padding(.bottom,5)
                                                                HStack{
                                                                    Text(String(format: "%.1f%", alterableEvents[event].eventTotalReviews != 0 ? alterableEvents[event].eventReviewPercentage / Double(alterableEvents[event].eventTotalReviews) : 0.0))
                                                                    Image(systemName: "star.fill")
                                                                        .foregroundColor(.yellow)
                                                                    Text("(\(alterableEvents[event].eventTotalReviews))").opacity(0.7)
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
                                            .padding(.horizontal,2)
                                    }
                                    .fullScreenCover(isPresented: $isPresented) {
                                        NewEventInformationView(event:$chosenEvent)
                                    }

//                                }
                                   
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
            .onAppear(perform: onAppear)

            
            
            
            
            
        }
    }
//    private func onAppear(){
//        self.enterEvents = events
////    }
    ///
    private func onAppear(){
        
        self.alterableEvents = events
    }
    private func RSVPEvent(event:EventModel){
        self.chosenSet = event.groupIDS ?? []
        print("chosen set \(chosenSet)")
        showTeamsGoing = true

    }
    private func fillEvent(event:EventModel){
        self.chosenEvent = event
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
                self.alterableEvents[id].didISave = true
                return

            case .success(false):
                self.alterableEvents[id].didISave = false
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
