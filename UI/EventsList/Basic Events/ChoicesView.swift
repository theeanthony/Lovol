//
//  ChoicesView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/16/22.
//

import SwiftUI

struct ChoicesView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(AppColor.lovolTan)
                  
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

    @State private var showSuggestionSheet : Bool = false
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                VStack{
                    
                    if loadingEvents {
                        ProgressView()
                    }
                    else{
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.4000000059604645)))
                                .frame(width: geo.size.width * 0.95, height: geo.size.height * 0.95)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                                .padding()
                            VStack{
                                HStack{
                                    Button {
                                        
                                    } label: {
                                        
                                        NavigationLink(destination: EventsView(templateEvents: homeEvents, events: homeEvents)) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(AppColor.lovolDarkPurple)
                                                .frame(width: geo.size.width * 0.45, height: geo.size.height * 0.46)
                                                .overlay(
                                                    VStack{
                                                        Text("H")
                                                        Text("O")
                                                        Text("M")
                                                        Text("E")
                                                        
                                                    }
                                                        .font(.custom("Rubik Regular", size: 26)).foregroundColor(AppColor.lovolTan).tracking(4.8).multilineTextAlignment(.center)
                                                )
                                        }
                                        
                                    }
                                    Button {
                                        
                                    } label: {
                                        NavigationLink(destination: EventsView(templateEvents: localEvents,events:localEvents)) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(AppColor.lovolPinkish)
                                                .frame(width: geo.size.width * 0.45, height: geo.size.height * 0.46)
                                                .overlay(
                                                    VStack{
                                                        Text("L")
                                                        Text("O")
                                                        Text("C")
                                                        Text("A")
                                                        Text("L")
                                                        
                                                        
                                                    }
                                                        .font(.custom("Rubik Regular", size: 26)).foregroundColor(AppColor.lovolTan).tracking(4.8).multilineTextAlignment(.center)
                                                )
                                        }
                                        
                                    }
                                    
                                }
                                HStack{
                                    Button {
                                        
                                    } label: {
                                        NavigationLink(destination: EventsView(templateEvents: virtualEvents,events:virtualEvents)) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(AppColor.lovolLightOrange)
                                                .frame(width: geo.size.width * 0.45, height: geo.size.height * 0.46)
                                                .overlay(
                                                    VStack{
                                                        Text("V")
                                                        Text("I")
                                                        Text("R")
                                                        Text("T")
                                                        Text("U")
                                                        Text("A")
                                                        Text("L")
                                                        
                                                        
                                                        
                                                    }
                                                        .font(.custom("Rubik Regular", size: 26)).foregroundColor(AppColor.lovolTan).tracking(4.8).multilineTextAlignment(.center)
                                                )
                                        }
                                        
                                    }
                                    Button {
                                        
                                    } label: {
                                        NavigationLink(destination: EventsView(templateEvents: adultEvents,events: adultEvents)) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(AppColor.lovolLightPurple)
                                                .frame(width: geo.size.width * 0.45, height: geo.size.height * 0.46)
                                                .overlay(
                                                    VStack{
                                                        Text("2")
                                                        Text("1")
                                                        Text("+")
                                                        
                                                    }
                                                        .font(.custom("Rubik Regular", size: 26)).foregroundColor(AppColor.lovolTan).tracking(4.8).multilineTextAlignment(.center)
                                                )
                                        }
                                        
                                    }
                                    
                                }
//                                Button {
//                                    showSuggestionSheet.toggle()
//                                } label: {
//                                    Text("Suggest Event")
//                                }
                                
                                
                            }
                            
                        }
                    }
                    
                    
                    
                    
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .sheet(isPresented: $showSuggestionSheet, content: {
                SuggestEventView(showSuggestionSheet: $showSuggestionSheet)
            })
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear(perform: perform)
            
            .alert("Failure loading events. Please try again.", isPresented: $showLoadingError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
        }

    }
    private func perform(){
//        eventViewModel.fetchEvents { result in
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
                        homeEvents.append(filteredEvent)
                         
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

        }

        }
        loadingEvents = false
        
        
    }
}

struct ChoicesView_Previews: PreviewProvider {
    static var previews: some View {
        ChoicesView()
    }
}
