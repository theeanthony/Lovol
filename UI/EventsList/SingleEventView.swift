//
//  SingleEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct SingleEventView: View {


    @EnvironmentObject private var eventViewModel: EventViewModel
    @EnvironmentObject private var profileViewModel: ProfilesViewModel
    
    

    @State private var allEvents : [String:EventModel] = [:]
    
    @State private var homeEvents : [String:EventModel] = [:]
    @State private var localEvents : [String:EventModel] = [:]
    @State private var virtualEvents : [String:EventModel] = [:]
    @State private var adultEvents : [String:EventModel] = [:]
    @State private var couplesEvents : [String:EventModel] = [:]
    @State private var afterDarkEvents : [String:EventModel] = [:]
    
    @State private var monthSeason : String = "0"
    
    
    @State private var distanceEvents : [String:EventModel] = [:] 
    
    @State private var savedEvents : [String] = []
    @State private var locationSet : Bool = false
    
    @State private var eventDictionary : [String:[String:EventModel]] = [:]
    
    @State private var headLiners : [HeadLiners] = []
    
    @State private var loading : Bool = false
    
    @State private var showLoadingError : Bool = false
    
    @State private var long : Double = 0
    @State private var lat : Double = 0
    
    @State private var locationSheet : Bool = false
    
    @State private var address : String = ""
    
    @State private var updadtedLocation : Bool = false
    
    @State private var filterChosen : Bool = false
    
    @State private var filterLoading : Bool = false
    
    @State private var reset : Bool = false
    
    @State private var filteredEvents : [String:EventModel] = [:]

    @State private var eventsWaitingToBeFiltered : [EventModel] = []
    @State private var eventsFiltered : [EventModel] = []
    
    @State private var chosenFilter : String = ""
    
    @State private var showSaves : Bool = false
    
    @State private var notInGroupError : Bool = false
    
    
    

    var body: some View {
        
        
        GeometryReader { geo in
            NavigationStack{
                if loading{
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        Spacer()

                    }
                }else{
                    VStack{
//                        Spacer()
                        
                        if notInGroupError{
                            HStack{
                                Spacer()
                                Text("Join or create a group to see what events are available!")
                                    .font(.custom("Rubik Regular", size: 22)).foregroundColor(.white)
                                    .padding()
                                Spacer()
                            }
                        }
                        ScrollView{
                            
                  

                            
                            CollectionHeaderView(eventDictionary: eventDictionary,locationSet:locationSet,long:long,lat:lat)
                                .frame(height:geo.size.height * 0.17)
                            ExDivider(color: .white.opacity(0.4))
                                .padding(.top,20)
                            TagsHeaderView(chosenTag: $chosenFilter, filterChosen: $filterChosen)
                                .frame(height:geo.size.height * 0.12)
                            FilterEventView(reset: $reset, filterChosen: $filterChosen)
                                .frame(height:geo.size.height * 0.09)
                                .padding(.vertical,15)
//                            HStack{
                                ScrollView(.horizontal){
                                    HStack{
                                        GameShowLabelView()
                                            .frame(width:geo.size.width * 0.85)
                                            .padding(.leading,10)
                                        
                                            .padding(.trailing,10)
//                                        Spacer()
                                        BonusRoundView()
                                            .frame(width:geo.size.width * 0.85)
                                            .padding(.leading,10)
//                                        Spacer()
                                            .padding(.trailing,30)
                                        
                                    }
                                    
                                }
                                .frame(height:geo.size.height * 0.2)
                                .scrollIndicators(.hidden)

//                            }
                            
                            //saved events and alliances saved events
//                            if showSaves{
//                                SavedEventsLabel(showSaves:$showSaves)
//                                    .frame(height:geo.size.height * 0.55)

//                            }
                            // nearby hosted events , only if setlocation is true
                            
                            //add 

                
                            
                            
                            if filterLoading {
                                ProgressView()
                            }
                            else{
                                
                                if filterChosen{
                                    
                                    if eventsFiltered.isEmpty {
                                        LabelEventView(events:eventsFiltered  , heder: "No Results",locationSet:locationSet, long:long,lat:lat  )
                                            .frame(height:geo.size.height * 0.40)
                                            .padding(.bottom, 15)
                                    }else{
                                        LabelEventView(events:eventsFiltered  , heder: "Nearby Events",locationSet:locationSet, long:long,lat:lat  )
                                            .frame(height:geo.size.height * 0.40)
                                            .padding(.bottom, 15)
                                    }
                                    
                                }else{
                                    ForEach(headLiners.indices, id:\.self){ index in
                                        
                                        if !headLiners[index].events.isEmpty {
                                            
                                            HStack{
                                                Text(headLiners[index].header )
                                                    .font(.custom("Rubik Regular", size: 22)).foregroundColor(.white).textCase(.uppercase)
                            //                        .padding()
                                                Spacer()
                                                Image(systemName:"chevron.right")
                                                    .foregroundColor(.white)
                                                    .padding(.trailing)
                                            }
                                            .frame(width:geo.size.width * 0.9)
                            //                .padding(.vertical)
                                            
                                            LabelEventView(events: headLiners[index].events, heder: headLiners[index].header,locationSet:locationSet, long:long,lat:lat  )
                                                .frame(height:geo.size.height * 0.40)
                                                .padding(.bottom, 15)
                                        }
               
                                    }
                                }

                            }
                            
                            
                        }
                        .frame(width:geo.size.width, height:geo.size.height * 0.95)
                    
                        
                    } .frame(width:geo.size.width, height:geo.size.height)
                      
                }
  
                    
            }
            .background(BackgroundView())
            .onAppear(perform:onAppear)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItemGroup(placement: .principal) {
                    HStack{
                        Button {
                            locationSheet = true
                        } label: {
                            HStack{
                                Image(systemName:"mappin")
                                Text(locationSet ? address : "Set Team Meeting Point")
                                Image(systemName:"chevron.down")
                            }
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                        }
                    }


                }
            }
            .sheet(isPresented: $locationSheet) {
                LocationPreferenceView(updatedLocation: $updadtedLocation)
            }
 
            .onChange(of: updadtedLocation) { newResult in
                if updadtedLocation {
                    loading = true
                    filterChosen = false
                    onAppear()
                    self.updadtedLocation = false
                }
                
            }
            .onChange(of: chosenFilter) { newValue in
//                if filterChosen {
                    
                    self.filterLoading = true
                    
                    filterTagEvents()
                    
//                }
            }
            
        
            
            
        }
    }
//    private func headLinerEvents(headLiners:[HeadLiners]){
//
//        for header in headLiners {
//
//        }
//
//    }
    private func filterTagEvents(){
        
  
        
        self.filteredEvents = allEvents.filter({
            
            $0.value.eventTags.contains(chosenFilter)
            
            
        })
        self.eventsFiltered = eventsWaitingToBeFiltered.filter({
            
            $0.eventTags.contains(chosenFilter)
  
        })
        
        
        self.filterLoading = false
        
    }
    private func filterSavedEvents(){
        
        profileViewModel.fetchTeamWithoutID { result in
            switch result {
                
            case .success(let team):
                self.savedEvents = team.suggestedEvents
                self.locationSet = team.locationSet
                self.address = team.address
                
                
                if locationSet {
                    print("location is set")
                    self.long = team.long
                    self.lat = team.lat
                }else{
                    print("location not sest")
                }
                return
            case .failure(.parsingError):
                print("not a part of a group")
                self.notInGroupError = true
                return
                
            case .failure(.downloadError):
                print("could not fetch documents")
                return
            case .failure(.uploadError):
                return
            case .failure(.localSavingError):
                return
            case .failure(.localfetchingError):
                return
            }
        }
        
    }
    private func onAppear(){
        
        eventViewModel.fetchHeadLiners { result in
            switch result {
  
            case .success(let headLiners):

                self.headLiners = headLiners
                
                
                profileViewModel.fetchTeamWithoutID { result in
                    switch result {
                        
                    case .success(let team):
                        self.savedEvents = team.suggestedEvents
                        self.locationSet = team.locationSet
                        self.address = team.address
                        
                        eventsWaitingToBeFiltered.removeAll()
                        allEvents.removeAll()
                        if locationSet {
                            print("location is set")
                            self.long = team.long
                            self.lat = team.lat
                            eventViewModel.fetchHostedEvents(groupId: team.id, locationSet: locationSet, long: long, lat: lat, alliances: team.alliances) { result in
                                switch result{
                                case .success(let hostEvents):
                                    print("success fetching test event \(hostEvents)")
                                    for hostEvent in hostEvents{
                                        self.allEvents[hostEvent.id] = hostEvent
                                        if ((hostEvent.groupIDS?.contains(team.id)) != nil){
                                            if hostEvent.groupIDS!.contains(team.id){
                                                self.allEvents[hostEvent.id]?.didIRSVP = true

                                            }
                                        }
                                    }
                                case .failure(let error):
                                    print("Error fetchinga nd parsing hosted event data \(error)")
                                    
                                }
                            }
                        }else{
                            print("location not sest")
                        }
                        eventViewModel.fetchEvents(groupId:team.id,locationSet: locationSet, long:long,lat:lat) { result in
                            switch result {
                            case .success(let events ):
                                
                                filterEvents(events:events,headLiner: headLiners)

                            case .failure(let error):
                                print("error downloading information \(error)")
                                showLoadingError = true
                                return
                            }
                        }
//                        return
                    case .failure(.parsingError):
                        print("not a part of a group")
                        return
                        
                    case .failure(.downloadError):
                        print("could not fetch documents")
                        return
                    case .failure(.uploadError):
                        return
                    case .failure(.localSavingError):
                        return
                    case .failure(.localfetchingError):
                        return
                    }
                }
                


            case .failure(let error):
                print("error fetching events \(error)")
                showLoadingError = true
//                presentationMode.wrappedValue.dismiss()
                
                
            }
        }
    }

    private func filterEvents( events:[EventModel],headLiner: [HeadLiners]){
        
        for event in events {
            self.allEvents[event.id] = event
        }
        eventViewModel.fetchEventsCompleted(season:monthSeason) { result in
            switch result {
            case .success(let completedEvents):
                for event in completedEvents.indices {
                    self.allEvents[completedEvents[event].id]?.eventCompleted = true
                    
                    
                    if completedEvents[event].eventType == "Home" {
                        homeEvents[completedEvents[event].id]?.eventCompleted = true
                    }
                    if completedEvents[event].eventType == "Local" {
                        localEvents[completedEvents[event].id]?.eventCompleted = true
                    }
                    if completedEvents[event].eventType == "Virtual" {
                        virtualEvents[completedEvents[event].id]?.eventCompleted = true
                    }
                    if completedEvents[event].eventType == "21+" {
                        adultEvents[completedEvents[event].id]?.eventCompleted = true
                    }
                    if completedEvents[event].eventType == "Couples" {
                        couplesEvents[completedEvents[event].id]?.eventCompleted = true
                    }
                    if completedEvents[event].eventType == "After Dark" {
                        afterDarkEvents[completedEvents[event].id]?.eventCompleted = true
                    }
                }
                for event in savedEvents {
                    
                    self.allEvents[event]?.didISave = true
       

                }
                for (_,value) in allEvents {
                    self.eventsWaitingToBeFiltered.append(value)
                    if value.eventType == "Home" {
                        homeEvents[value.id] = value
                       
                    }
                    if  value.eventType == "Local" {
                        localEvents[value.id] = value
                    }
                    if value.eventType == "Virtual" {
                        virtualEvents[value.id] = value
                    }
                    if  value.eventType == "Adult" {
                        adultEvents[value.id] = value
                    }
                    if value.eventType == "Couples" {
                        couplesEvents[value.id] = value
                    }
                    if  value.eventType == "After Dark" {
                        afterDarkEvents[value.id] = value
                    }
                }
                var eventsModel : [EventModel] = []

                for index in headLiner.indices {
                     eventsModel = eventsWaitingToBeFiltered.filter({
                        
                        $0.eventTags.contains(headLiners[index].tags)
                        
                    })
                    
//                    self.headLiners[index].events.removeAll()
                    self.headLiners[index].events = eventsModel
                    print(self.headLiners[index].events.count)
                    
                   
                }
                self.eventDictionary["Home"] = homeEvents
                self.eventDictionary["Local"] = localEvents
                self.eventDictionary["Virtual"] = virtualEvents
                self.eventDictionary["Adult"] = adultEvents
                self.eventDictionary["Couples"] = couplesEvents
                self.eventDictionary["AfterDark"] = afterDarkEvents
                loading = false

            case .failure(let error):
                print("error retrieiving completed information \(error)")
                loading = false



        }

        }
        
        
    }
            
            
}

struct SingleEventView_Previews: PreviewProvider {
    static var previews: some View {
        SingleEventView()
    }
}

//[EventModel(id: "", eventName: "Chimmiganggas night", eventDescription: "This is going to be the best place to get chimmichangas yall better come", eventRules: "", eventLocation: "", eventAverageCost: 30, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventCompleted: false, eventURL: ""),EventModel(id: "", eventName: "Chimmiganggas night", eventDescription: "This is going to be the best place to get chimmichangas yall better come", eventRules: "", eventLocation: "", eventAverageCost: 30, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventCompleted: false, eventURL: "")]
