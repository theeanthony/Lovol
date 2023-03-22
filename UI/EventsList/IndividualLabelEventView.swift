//
//  IndividualLabelEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/5/23.
//

import SwiftUI

struct IndividualLabelEventView: View {
    @EnvironmentObject private var eventViewModel : EventViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let inGroupError : Bool
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
    @Binding var events : [EventModel]
     var heder : String 
//    let eventDictionary : [String:EventModel]

//    @State private var enterEvents : [EventModel] = []
    
    @State private var chosenEvent : EventModel = EventModel()
    @State private var showTeamsGoing : Bool = false
    @State private var chosenSet : [String] = []
 
    let alreadyRSVP : Bool = false
    @State private var distance : Double = 0
    let locationSet : Bool
    let long : Double
    let lat : Double
    @State private var isPresented: Bool = false
    @State private var chosenIndex : Int = 0
    
    var body: some View {
        GeometryReader { geo in
            
            VStack{
                Spacer()
                ScrollView{
                    VStack{
                        ForEach(events.indices, id:\.self) { event in
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
                                                .frame(width:geo.size.width * 0.9, height: 150)
                                    
                                        },
                                                   placeholder: {
                                            ZStack{
                                                ProgressView()
                                                    .background(Rectangle().frame(width:geo.size.width * 0.9, height: 150)
                                            
                                                        .cornerRadius(10,corners:[.topLeft,.topRight]))
                                                                                    .aspectRatio(contentMode: .fit)
                                            }
                                            
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
//                                        Spacer()
                                        VStack{
                                            HStack{
                                                Text(events[event].eventName)
                                                Spacer()
                                                HStack{
                                                    Image("lovol.currency")
                                                    Text("\(events[event].eventTime)")
                                                }
                                                HStack{
                                                    Image(systemName:"clock.fill")
                                                    Text("\(events[event].eventPoints)")
                                                }
                                            }
                                            .padding(.vertical,0.8)
                                            .frame(width:geo.size.width * 0.85)
                                            if events[event].isTempEvent{
                                                VStack{
                                                    HStack{
                                                        Text("\(Date().shortTime) \(Date().fullDate)")
                                                        Spacer()
                                                    }
                                                    .frame(width:geo.size.width * 0.85)

                                                    HStack{
                                                        Button {
                                                            RSVPEvent(event:events[event])

                                                        } label: {
                                                            Text("RSVPS (\(events[event].totalRSVP!))")
                                                                .padding(5)
                                                                .background(RoundedRectangle(cornerRadius:10).fill( LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish,AppColor.lovolNamePink]), startPoint: .top, endPoint: .bottom)))
                                                            
                                                        }
//                                                        Text("(\(currentRSVPAmount))").opacity(0.8)
                                                        if events[event].didIRSVP ?? false{
                                                            Image(systemName:"checkmark")
                                                        }
                                                        Spacer()
            
                                                    }
                                                    .frame(width:geo.size.width * 0.85)

 
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
                                                        
                                                    }
                                                    .padding(.bottom,5)
                                                    .frame(width:geo.size.width * 0.85)

                                                    HStack{
                                                        Text(String(format: "%.1f%", events[event].eventTotalReviews != 0 ? events[event].eventReviewPercentage / Double(events[event].eventTotalReviews) : 0.0)).foregroundColor(.white)
                                                        Image(systemName: "star.fill")
                                                            .foregroundColor(.yellow)
                                                        Text("(\(events[event].eventTotalReviews))").opacity(0.7)
                                                        Spacer()
                                                    }
                                                    .frame(width:geo.size.width * 0.85)

                                                    Text("")
                                                }
                                                
                                            }
                                        }
//                                        Spacer()
                                    }
                                    .fullScreenCover(isPresented: $isPresented) {
                                        NewEventInformationView(inGroupError: inGroupError, event:$events[chosenIndex])
                                    }
                                }
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolPinkish))
//                                .padding(.horizontal,2)
                            }
                         
                            .padding()
                            
                            //                                }
                            
                        }
                    } //hstack above foreach
                    
                }
                .frame(height:geo.size.height * 0.9)
//                .padding(.leading,10)
                //                    .padding(.vertical)
                //                    .frame(height:200)
                .scrollIndicators(.hidden)
                
            }
            .frame(width:geo.size.width , height:geo.size.height * 0.99)

            
//            .onAppear(perform:onAppear)
            .onDisappear(perform: {
                presentationMode.wrappedValue.dismiss()
            })
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Text(heder)
                        .font(.custom("Rubik Regular", size: 20)).foregroundColor(.white)
                    
                }
            }
        }
        .background(BackgroundView())
        .sheet(isPresented: $showTeamsGoing) {
            RSVPTeamsView(teamsAtteding: $chosenSet, inAddEventView: false, eventId: $chosenEvent.id)
            .presentationDetents([ .medium])
                .presentationDragIndicator(.hidden)
                
            
        }
    }
    private func fillEvent(event:EventModel,index:Int){
        self.chosenEvent = event
        self.chosenIndex = index 
        isPresented.toggle()
        return
    }
//    private func onAppear(){
//        for (_,value) in eventDictionary {
//
//            events.append(value)
//
//        }
//    }
    private func RSVPEvent(event:EventModel){
        
        print("Event being chosen \(event)")
        print("specifc rou pid \(event.groupIDS ?? [])")
        self.chosenSet = event.groupIDS ?? []
        print("chosen set \(chosenSet)")
        showTeamsGoing = true

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

//struct IndividualLabelEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        IndividualLabelEventView()
//    }
//}
