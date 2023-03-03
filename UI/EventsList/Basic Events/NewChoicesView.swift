//
//  NewChoicesView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/14/23.
//

import SwiftUI

struct NewChoicesView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
    
    @State private var homeEvents: [EventModel] = []
    @State private var localEvents: [EventModel] = []
    @State private var virtualEvents: [EventModel] = []
    @State private var adultEvents: [EventModel] = []
    
    @State private var loadingEvents : Bool = true
    
    @State private var showLoadingError : Bool = false
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                HStack{
                    VStack{
                        
                        Button {
                            
                        } label: {
                            
                            NavigationLink(destination: NewEventsListView(specificEvents:homeEvents, loadedEvents: $loadingEvents)) {
                                VStack{
                                    Image(systemName: "house.fill")
                                        .resizable()
                                        .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                    Text("Home")
                                }
                                .frame(width:geo.size.width * 0.475, height: geo.size.height * 0.35)
                                .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple))
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                            }
                   
                            
                        }

                        Button {
                            
                        } label: {
                            VStack{
                                Image(systemName: "car.fill")
                                    .resizable()
                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                Text("Local")
                            }
                            .frame(width:geo.size.width * 0.475, height: geo.size.height * 0.25)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolSunOrange))
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        }

                        Button {
                            
                        } label: {
                            VStack{
                                Image(systemName: "network")
                                    .resizable()
                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                Text("Virtual")
                            }
                            .frame(width:geo.size.width * 0.475, height: geo.size.height * 0.35)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolCollectionPink))
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        }

     
                    }
                    VStack{
                        Button {
                            
                        } label: {
                            VStack{
                                Image(systemName: "flame.fill")
                                    .resizable()
                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                Text("21+")
                            }
                            .frame(width:geo.size.width * 0.475, height: geo.size.height * 0.234)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolCollectionPink))
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        }

                        Button {
                            
                        } label: {
                            
                            VStack{
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                Text("Couples")
                            }
                            .frame(width:geo.size.width * 0.475, height: geo.size.height * 0.234)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolLightPurple))
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        }
                        Button {
                            
                        } label: {
                            VStack{
                                Image(systemName: "moon")
                                    .resizable()
                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                Text("After Dark")
                            }
                            .frame(width:geo.size.width * 0.475, height: geo.size.height * 0.234)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple))
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
           
                        }

                        Button {
                            
                        } label: {
                            VStack{
                                Image(systemName: "exclamationmark.circle.fill")
                                    .resizable()
                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                Text("Extreme")
                            }
                            .frame(width:geo.size.width * 0.475, height: geo.size.height * 0.234)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        }

           
                    }
                    
                   
                }
                .foregroundColor(.white)
                .font(.custom("Rubik Regular", size: 25))
          
                
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Select Type of Event")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(.white)

               }
            }
            .alert("Failure loading events. Please try again.", isPresented: $showLoadingError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .onAppear(perform:perform)
        }

  
    }
    private func perform(){
//        eventViewModel.fetchEvents(locationSet: false, long:0,lat:0) { result in
//            switch result {
//            case .success(let events):
//                filterEvents(events: events)
//
//            case .failure(let error):
//                print("error fetching events \(error)")
//                showLoadingError = true
//                presentationMode.wrappedValue.dismiss()
//                
//                
//            }
//        }
    }
    private func filterEvents(events: [EventModel]){
        print("In here ")

        eventViewModel.fetchCompletedEvents { result in

            switch result {
            case .success(let completedEvents):
                homeEvents = []
                virtualEvents = []
                localEvents = []
                adultEvents = []
                for event in events.indices {
                    
                    var filteredEvent = events[event]
                    for complete in completedEvents {
                        if events[event].id == complete[0] && complete[1] == events[event].eventMonth {
                           filteredEvent = events[event]
                            filteredEvent.eventCompleted = true
                            
                        }
                    }
                    if filteredEvent.eventType == "Home" {
                        self.homeEvents.append(filteredEvent)
                        
                         
                    }
                    if filteredEvent.eventType == "Virtual" {
                        virtualEvents.append(filteredEvent)

                    }
                    if filteredEvent.eventType == "Local" {
                        localEvents.append(filteredEvent)

                    }
                    if filteredEvent.eventType == "Adult" {
                        adultEvents.append(filteredEvent)

                    }
                    
            }
                loadingEvents = false

            case .failure(let error):
                print("error retrieiving completed information \(error)")
                for event in events {
                    if event.eventType == "Home" {
                        homeEvents.insert(event, at: 0)
                         
                    }
                    if event.eventType == "Virtual" {
                        virtualEvents.insert(event, at: 0)

                    }
                    if event.eventType == "Local" {
                        localEvents.insert(event, at: 0)

                    }
                    if event.eventType == "Adult" {
                        adultEvents.insert(event, at: 0)

                    }
                }
                loadingEvents = false


        }

        }
        
        
    }
    
}

struct NewChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        NewChoicesView()
    }
}
