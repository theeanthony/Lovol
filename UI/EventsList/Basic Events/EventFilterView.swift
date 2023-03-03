//
//  EventFilterView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/16/22.
//

import SwiftUI

struct EventFilterView: View {
    var price = ["Price","Free", "$1 - 20$", "$20 - $50", "$50 >"]
    var time = ["Time","<1 hour", "1 - 2 hours", "2 - 4 hours", "All Day"]

    @Binding var selectedPrice : String
    @Binding var selectedTime : String
    
    let templateEvents : [EventModel]
    @Binding var events: [EventModel]
    @Binding var loading : Bool


    var body: some View {
        GeometryReader{ geo in
       
                VStack{
                    
                    Text("Preferences")
                        .offset(x:-80)
                        .font(.custom("Rubik Regular", size: 14))
                        .foregroundColor(AppColor.lovolDarkPurple)
                    HStack{
                        Spacer()
                        Picker("Price", selection: $selectedPrice) {
                            ForEach(price, id: \.self) {
                                Text($0)
                                    .font(.custom("Rubik Regular", size: 12))
                                
                            }
                        }
                        .onReceive([self.selectedPrice].publisher.first()) { (value) in
                            filterEvents()
                        }
                        
                        .frame(width:geo.size.width * 0.46)
                        .accentColor(AppColor.lovolTan)
                        .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple))
                        Spacer()
                        Picker("Time", selection: $selectedTime) {
                            ForEach(time, id: \.self) {
                                Text($0)
                                    .font(.custom("Rubik Regular", size: 12))
                                
                            }
                        }
                        //                    .onTapGesture(perform: filterEvents)
                        .onReceive([self.selectedTime].publisher.first()) { (value) in
                            filterEvents()
                        }
                        
                        .frame(width:geo.size.width * 0.46)
                        .accentColor(AppColor.lovolTan)
                        .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple))
                        Spacer()
                        
                        
                    }
                    .font(.custom("Rubik Regular", size: 14))
                    .foregroundColor(AppColor.lovolDarkPurple)
                    //                .frame(width: 300, height: 20)
                }
                .padding(.vertical,5)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolTan)
//                    .frame(width:geo.size.width * 0.9)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                
            
        }
    }
    private func clear(){
        selectedPrice = "Price"
        selectedTime = "Time"
    }
    private func filterEvents(){
//        var price = ["Price","Free", "$0 - 20$", "$20 - $50", "$50 >"]
//        var time = ["Time","<1 hour", "1 - 2 hours", "2 - 4 hours", "All Day"]
        loading = true
        if selectedPrice == "Price" && selectedTime == "Time"{
            events = templateEvents
            return
        }
        var filteredEvents = templateEvents
        if selectedPrice == "Free" {
            filteredEvents = filteredEvents.filter{$0.eventAverageCost == 0 }
        }
        else if selectedPrice == "$1 - 20$"{
            filteredEvents = filteredEvents.filter{$0.eventAverageCost > 0}
            filteredEvents = filteredEvents.filter{$0.eventAverageCost < 21}
        }

        else if selectedPrice == "$20 - $50"{
            filteredEvents = filteredEvents.filter{$0.eventAverageCost > 20}
            filteredEvents = filteredEvents.filter{$0.eventAverageCost < 51}
        }
        else if selectedPrice == "$50 >"{
            filteredEvents = filteredEvents.filter{$0.eventAverageCost > 50}

        }
        if selectedTime == "<1 hour" {
            filteredEvents = filteredEvents.filter{$0.eventTime < 61 }

        }
        else if selectedTime == "1 - 2 hours"{
            filteredEvents = filteredEvents.filter{$0.eventTime > 60 }
            filteredEvents = filteredEvents.filter{$0.eventTime < 121 }

        }
        else if selectedTime == "2 - 4 hours"{
            filteredEvents = filteredEvents.filter{$0.eventTime > 120 }
            filteredEvents = filteredEvents.filter{$0.eventTime < 241 }

        }
        else if selectedTime == "All Day"{
            filteredEvents = filteredEvents.filter{$0.eventTime > 240 }

        }
        events = filteredEvents
        loading = false 
         
     }
 

}

//struct EventFilterView_Previews: PreviewProvider {
//    @State static var selectedPrice : String = "$20 - $50"
//    @State static var selectedTime : String = "2 - 4 hours"
//    @State static var events : [EventModel] = [EventModel(id: "0", eventName: "Ant", eventDescription: "BIGEIALKAJSKJLFKJLDKFJLDKJF LOREMALKJL FDKJFLEKJELKRLJ DFJLKSDJFLKJDF ", eventRules: "DJDLFJDLSKJ DLKJSFLKSDJF DSLJF LDSKJLKFJDSLJFKLDSJFLDSJ ", eventLocation: "None", eventAverageCost: 10, eventTime: 10, eventPoints: 10, eventType: "Home", eventMonth: 0, eventCompleted: true),EventModel(id: "1", eventName: "Ant", eventDescription: "BIGEIALKAJSKJLFKJLDKFJLDKJF LOREMALKJL FDKJFLEKJELKRLJ DFJLKSDJFLKJDF ", eventRules: "DJDLFJDLSKJ DLKJSFLKSDJF DSLJF LDSKJLKFJDSLJFKLDSJFLDSJ ", eventLocation: "None", eventAverageCost: 10, eventTime: 10, eventPoints: 10, eventType: "Home", eventMonth: 0, eventCompleted: false)]
//    @State static var loading : Bool = false
//    static var previews: some View {
//        EventFilterView(selectedPrice: $selectedPrice, selectedTime: $selectedTime, templateEvents: events, events: $events, loading: $loading)
//    }
//}
