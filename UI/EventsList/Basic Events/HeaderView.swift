//
//  HeaderView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/7/23.
//

import SwiftUI

struct HeaderView: View{
     
    @EnvironmentObject private var eventViewModel : EventViewModel
    let name : String
    let event : EventModel
    @State private var joinGroupFirstError : Bool = false
    @State private var eventSetAlreadyError : Bool = false
    @State private var showDownloadError : Bool = false

    @State private var eventSaved : Bool = false
    @State private var eventRSVP : Bool = false
    @State private var totalRSVP : Int = 0
    

    var body: some View{
        //        GeometryReader{geo in
        VStack{
            HStack{
                Text(name)
                    .padding(.trailing)
                    .font(.custom("Rubik Bold", size: 22))
                    .foregroundColor(.white).multilineTextAlignment(.center).frame( height: 20, alignment:.leading)
                    .padding(.leading, 15)
                //                .frame(width:geo.size.width * 0.5)
                Spacer()
                if event.eventCompleted ?? false {
                    Button {

                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width:25,height:25)
                            .padding(.trailing, 20)
                    }
                }
     
                Button {
                    saveEvent(event: event)
                } label: {
                    if eventSaved {
                        Image( systemName: "bookmark.fill")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width:20,height:25)
                            .padding(.trailing, 20)
                    }else{
                        Image( systemName: "bookmark")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width:20,height:25)
                            .padding(.trailing, 20)
                    }
//
                }

            }
            VStack{
                
                if event.isTempEvent{
                    VStack{
                        HStack{
                            Text("Total RSVPs (\(totalRSVP))") .font(.custom("Rubik Regular", size: 12))
                                .foregroundColor(.white)
                            
                            Button {
                                
                                RSVPEvent(event: event)
                            } label: {
                                Text("RSVP")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius:10).fill( LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish,AppColor.lovolNamePink]), startPoint: .top, endPoint: .bottom)))
                            }
                            if eventRSVP{
                                Image(systemName:"checkmark").foregroundColor(.white)
                            }
                           

                            Spacer()
                        }
                        
                        if event.startingTime != nil{
                            VStack{
                                HStack{
                                    Text("Starting: \(event.startingTime!.shortTime) \(event.startingTime!.fullDate)")
                                        .padding(.vertical,3)
                                    Spacer()
                                }
                                HStack{
                                    Text("Ending: \(event.endingTime!.shortTime) \(event.endingTime!.fullDate)")
                                        .padding(.vertical,3)
                                    Spacer()
                                }
                                Spacer()
                            }
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                            .padding(.vertical,3)
                            
                        }
                    }
                    
    
                }
                else{
                    HStack{
                        Text(String(format: "%.1f%", event.eventTotalReviews != 0 ? event.eventReviewPercentage / Double(event.eventTotalReviews) : 0.0))
                        Image(systemName:"star.fill")
                            .foregroundColor(.yellow)
                        Text("(\(event.eventTotalReviews))").opacity(0.5)
                        Spacer()
                    }
                }
            }
            .font(.custom("Rubik Regular", size: 12))

            .padding(.leading, 15)

            if event.eventLocation && event.distance != nil {
                VStack{
                    HStack{
                        Text("\(event.address)")
                            .font(.custom("Rubik Regular", size: 12))
                                .foregroundColor(.white)
                        Spacer()
                    }
                    HStack{
                        //                    Image(systemName:"mappin")
                        //                        .foregroundColor(.red)
                        Text("\(String(format: "%.1f%",event.distance!)) miles")
                            .font(.custom("Rubik Regular", size: 12))
                                .foregroundColor(.white)
                        Spacer()
                    }
           
                }
                .padding(.leading, 15)
                .padding(.top,3)
                .font(.custom("Rubik Regular", size: 12))


            }

        }
        .alert("You must be in a group to save this event", isPresented: $joinGroupFirstError, actions: {
               Button("OK", role: .cancel, action: {

               })
           })
           .alert("This event has already been saved.", isPresented: $eventSetAlreadyError, actions: {
               Button("OK", role: .cancel, action: {

               })
           })
           .onAppear(perform:onAppear)
            
//        }
    }
    private func onAppear(){
        eventSaved = event.didISave ?? false
        eventRSVP = event.didIRSVP ?? false
        totalRSVP = event.totalRSVP ?? 0
    }
    private func RSVPEvent (event:EventModel){
         
        self.eventRSVP.toggle()
        if eventRSVP{
            totalRSVP += 1
        }else{
            totalRSVP -= 1
            if totalRSVP < 0 {
                totalRSVP = 0
            }
        }
        eventViewModel.rsvpToEvent(RSVP: eventRSVP,  event: event) { result in
            switch result{
            case .success(()):
                print("rsvp event")
                
            case .failure(let error):
                print("failure rsvping to event \(error)")
                return
            }
        }
    }
    private func saveEvent (event: EventModel){
        
        eventViewModel.saveEvent(id: event.id) { result in
            switch result {
                
//            case .success(0):
//                joinGroupFirstError = true
//                return
            case .success(true):
//                eventSetAlreadyError = true
                eventSaved = true
                return

            case .success(false):
                eventSaved = false
                return
            case .failure(_):
                showDownloadError = true
                return

                
                
                
                
            }
        }
        
    }
}

//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView(name:"Event of the header")
//    }
//}
