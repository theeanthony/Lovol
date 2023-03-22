//
//  SavedFrontView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/19/23.
//

import SwiftUI

struct SavedFrontView: View {
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
    @EnvironmentObject private var profileViewModel : ProfilesViewModel

    let groupId : String
    let saves : [String]
    let rsvps : [String]
    let long : Double
    let lat : Double
    let locationSet : Bool
    let alliances : [String]
    
    @State private var savedEvents : [EventModel] = []
    @State private var RSVPDEvents : [EventModel] = []
    @State private var allianceRSVPS : [RSVPEvents] = []
    @State private var loadingEvents : Bool = true
    @State private var loadingAllianceRSVP : Bool = true
    @State private var loadingRSVPEvents : Bool = true

//    let savedHosts : [String]
    var body: some View {
        GeometryReader{geo in
            VStack{
                Spacer()
                ScrollView{
                    if loadingRSVPEvents{
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }else{
                        VStack{
                            HStack{
                                Text("Our RSVPS")
                                    .font(.custom("Rubik Bold", size: 14))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.leading,5)
                            if RSVPDEvents.isEmpty{
                                Text("RSVP to some hosted events to let your alliances know what you are planning!")
                                    .font(.custom("Rubik Bold", size: 12))
                                    .padding(.leading,5)
                                    .padding(.vertical,30)

                            }else{
                                LabelEventView(inGroupError: false, events: $RSVPDEvents, heder: "Saved Events", locationSet: locationSet, long: long, lat: lat)
                                    .frame(height:geo.size.height * 0.40)
                                    .padding(.vertical, 15)
                            }
                        }
                        .padding(.vertical,20)

                    }
                    
                    if loadingEvents {
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }else{
                        VStack{
                            HStack{
                                Text("Our Favorites")
                                    .font(.custom("Rubik Bold", size: 14))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.leading,5)
                            if savedEvents.isEmpty{
                                Text("Check out the events page to find some favorites!")
                                    .font(.custom("Rubik Bold", size: 12))
                                    .padding(.vertical,30)


                            }else{
                                LabelEventView(inGroupError: false, events: $savedEvents, heder: "Saved Events", locationSet: locationSet, long: long, lat: lat)
                                    .frame(height:geo.size.height * 0.40)
                                    .padding(.vertical, 30)
                            }
                       
                        }
                        .padding(.vertical,20)

             
                    }
                    if loadingAllianceRSVP {
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }else{
                        VStack{
                            HStack{
                                Text("See where your alliances RSVP'd to!")
                                    .font(.custom("Rubik Bold", size: 14))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            .padding(.leading,5)
                            if allianceRSVPS.isEmpty{
                                Text("Your alliances haven't RSVP'd anywhere. Message them!")
                                    .font(.custom("Rubik Bold", size: 12))
                                    .padding(.vertical,30)
                         

                            }else{
                                RSVPLabelEventView(inGroupError: false, rsvpEvents: $allianceRSVPS, heder: "Saved Events", locationSet: locationSet, long: long, lat: lat)
                                    .frame(height:geo.size.height * 0.40)
                                    .padding(.bottom, 15)
                            }

                        }
                        .padding(.vertical,20)
                    }
                    
                }
                .frame(width:geo.size.width, height:geo.size.height * 0.95)
                .padding(.vertical,5)
            }
            .background(BackgroundView())
        }
        .onAppear(perform: onAppear)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
    }
    private func fetchRSVPS(){
        var count = 0
        let maxCount = rsvps.count
        var rsvpEvents : [EventModel] = []
        if rsvps.isEmpty{
            self.RSVPDEvents = []
            loadingRSVPEvents = false


        }
        for rsvp in rsvps {
            eventViewModel.fetchSingleHostEvent(id: rsvp) { result in
                switch result{
                case .success(var event):
                    event.didIRSVP = true
                    rsvpEvents.append(event)
                    count += 1
                    if count == maxCount {
                        
                       rsvpEvents.sort{
                            $0.startingTime! < $1.startingTime!
                        }
                        self.RSVPDEvents = rsvpEvents
                        
                        loadingRSVPEvents = false
                    }
                case .failure(_):
                    count += 1
                    if count == maxCount {
                        self.RSVPDEvents = rsvpEvents
                        loadingRSVPEvents = false
                    }
                }
            }

        }
  
    }
    private func onAppear(){
        fetchRSVPS()
        fetchAllianceRSVPS()
        eventViewModel.fetchTeamSavedEvents(teamId: groupId, saves: saves, lat: lat, long: long) { result in
            switch result {
            case .success(let events):
                self.savedEvents = events
                loadingEvents = false
                loadingAllianceRSVP = false
//                loadingRSVPEvents = false
            case .failure(let error):
                print("error fetching saved events \(error)")
                
            }
        }
       
    }
    private func fetchAllianceRSVPS(){
        
        profileViewModel.fetchAllianceRSVPS(alliances: alliances) { result in
            switch result {
            case .success(let teams):
                
                if teams.isEmpty{
                    loadingAllianceRSVP = false
                    return
                }
                var allEventsIds : [String] = []
                
                for team in teams {
                    allEventsIds.append(contentsOf: team.rsvps)
                }
                allEventsIds.removeDuplicates()
                
                var count = 0
                var maxCount = allEventsIds.count
                var rsvpEvent : [RSVPEvents] = []
                
                
                for allEventsId in allEventsIds {
                    eventViewModel.fetchSingleHostEvent(id: allEventsId) { result in
                        switch result{
                        case .success(var event):
                            count += 1
                            
                            var groupsGoing : [String] = []
                            for team in teams {
                                if team.rsvps.contains(event.id){
                                    groupsGoing.append(team.teamId)
                                }
                            }
                            rsvpEvent.append(RSVPEvents(groupIdsGoing: groupsGoing, event: event))
                            if count == maxCount {
                                
                               rsvpEvent.sort{
                                   $0.event.startingTime! < $1.event.startingTime!
                                }
                                self.allianceRSVPS = rsvpEvent
                                self.loadingAllianceRSVP = false
                                
                            }
                        case .failure(_):
                            count += 1
                            if count == maxCount {
                                rsvpEvent.sort{
                                    $0.event.startingTime! < $1.event.startingTime!
                                 }
                                 self.allianceRSVPS = rsvpEvent
                                 self.loadingAllianceRSVP = false
                            }
                        }
                    }
                }
                
                
                
                
            case .failure(_):
                print("error fetching allianceRSVPS")
            }
        }
        
    }
    
}

//struct SavedFrontView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedFrontView()
//    }
//}

struct RSVPEvents{
    let groupIdsGoing : [String]
    
    var event : EventModel
    
}
