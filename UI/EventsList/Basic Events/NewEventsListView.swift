//
//  NewEventsListView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/14/23.
//

import SwiftUI

struct NewEventsListView: View {
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
    @State private var events : [EventModel] = []
    @State private var searchFilter : String = ""
    let specificEvents : [EventModel]
    
    var searchResults: [EventModel] {
        
        if searchFilter.count == 0 {
            return specificEvents
        }

        return specificEvents.filter {$0.eventDescription.lowercased().contains(searchFilter.lowercased())}


    }
    @Binding var loadedEvents : Bool
//    var collegeList : [String] {
//        var college : [String] = []
//        for index in collegeModel {
//            college.append(index.institution)
//        }
//        return college
//    }
    @State private var isPresented = false
    
    @State private var chosenEvent : EventModel = EventModel()

    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                
                VStack{
                    HStack{
//                        Image(systemName:"magnifyingglass")
                        SearchBar(text: $searchFilter)
                            .frame(height:geo.size.height * 0.05)
                        
                    }
                    if loadedEvents {
                        ProgressView()
                    }
                    else{
                        ScrollView{
                            ForEach(specificEvents.indices, id:\.self){event in

                                    Button {
                                        fillEvent(event:specificEvents[event])
                                    } label: {
//                                        NavigationLink(destination: NewEventInformationView(event: specificEvents[event])) {
                                        NewEventsView(events: specificEvents[event])
                                            .frame(width:geo.size.width, height:geo.size.height * 0.35)
                                   

                                    }.fullScreenCover(isPresented: $isPresented) {
//                                       NewEventInformationView(event:$chosenEvent)
                                    }
                          

                              
                            }
                        }
                        .frame(height:geo.size.height * 0.9)
                    }
         
                }
                .frame(height:geo.size.height )
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
                    Text("Select Event")
                        .font(.custom("Rubik Regular", size: 20)).foregroundColor(.white)
                    
                }
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
//struct NewEventsListView_Previews: PreviewProvider {
//    static var specificEvents : [EventModel] = [EventModel(id: "1", eventName: "adfdsf", eventDescription: "daslkfj;sldkjf ad;slkfjas;dljf d;lkf adlksfj a;dl jf;asdjf ;ldsk;lajf ;lkadsjf ;dajsf;l kfjas;dlkj f;dls fj;lsaj fa;lskdjf ;alsdkj fl;", eventRules: "adsl;kjf", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: ""),EventModel(id: "1", eventName: "adfdsf", eventDescription: "daslkfj;sldkjf ad;slkfjas;dljf d;lkf adlksfj a;dl jf;asdjf ;ldsk;lajf ;lkadsjf ;dajsf;l kfjas;dlkj f;dls fj;lsaj fa;lskdjf ;alsdkj fl;", eventRules: "adsl;kjf", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: ""),EventModel(id: "2", eventName: "adfdsf", eventDescription: "daslkfj;sldkjf ad;slkfjas;dljf d;lkf adlksfj a;dl jf;asdjf ;ldsk;lajf ;lkadsjf ;dajsf;l kfjas;dlkj f;dls fj;lsaj fa;lskdjf ;alsdkj fl;", eventRules: "adsl;kjf", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: ""),EventModel(id: "3", eventName: "adfdsf", eventDescription: "daslkfj;sldkjf ad;slkfjas;dljf d;lkf adlksfj a;dl jf;asdjf ;ldsk;lajf ;lkadsjf ;dajsf;l kfjas;dlkj f;dls fj;lsaj fa;lskdjf ;alsdkj fl;", eventRules: "adsl;kjf", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0",  eventURL: ""),EventModel(id: "4", eventName: "adfdsf", eventDescription: "daslkfj;sldkjf ad;slkfjas;dljf d;lkf adlksfj a;dl jf;asdjf ;ldsk;lajf ;lkadsjf ;dajsf;l kfjas;dlkj f;dls fj;lsaj fa;lskdjf ;alsdkj fl;", eventRules: "adsl;kjf", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0",eventURL: ""),EventModel(id: "1", eventName: "adfdsf", eventDescription: "daslkfj;sldkjf ad;slkfjas;dljf d;lkf adlksfj a;dl jf;asdjf ;ldsk;lajf ;lkadsjf ;dajsf;l kfjas;dlkj f;dls fj;lsaj fa;lskdjf ;alsdkj fl;", eventRules: "adsl;kjf", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: ""),EventModel(id: "5", eventName: "adfdsf", eventDescription: "daslkfj;sldkjf ad;slkfjas;dljf d;lkf adlksfj a;dl jf;asdjf ;ldsk;lajf ;lkadsjf ;dajsf;l kfjas;dlkj f;dls fj;lsaj fa;lskdjf ;alsdkj fl;", eventRules: "adsl;kjf", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: "")]
//    @State static var loadedEvents : Bool = false
//
//    static var previews: some View {
//        NewEventsListView( specificEvents: specificEvents, loadedEvents: $loadedEvents)
//    }
//}
