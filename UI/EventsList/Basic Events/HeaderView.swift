//
//  HeaderView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/7/23.
//

import SwiftUI
 
struct HeaderView: View{
    let inGroupError:Bool
    @EnvironmentObject private var eventViewModel : EventViewModel
    let name : String
    @Binding var event : EventModel
    @State private var joinGroupFirstError : Bool = false
    @State private var eventSetAlreadyError : Bool = false
    @State private var showDownloadError : Bool = false

    @State private var eventSaved : Bool = false
    @State private var eventRSVP : Bool = false
    @State private var totalRSVP : Int = 0
    @State private var showHostInformation : Bool = false


    var body: some View{
        //        GeometryReader{geo in
        VStack{
            HStack{
                Text(name)
                    .padding(.trailing)
                    .font(.custom("Rubik Bold", size: 20))
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
                    saveEvent()
                } label: {
                    if event.didISave ?? false {
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
                        if event.lastReviewName != ""{
                            HStack{
                                Button {
                                    self.showHostInformation = true
                                } label: {
                                    Text("Hosted by \(event.lastReviewName)")
                                        .font(.custom("Rubik Regular", size: 12))
//                                    Text("\(event.lastReviewName)")
//                                        .font(.custom("Rubik Bold", size: 12))
                                    Image(systemName:"chevron.right")

                                }                                        .foregroundColor(.white)

                                Spacer()
                            }
                     

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

//                            .padding(.vertical,3)
                            
                        }
                        HStack{
                            Text("Total RSVPs (\(totalRSVP))") .font(.custom("Rubik Regular", size: 12))
                                .foregroundColor(.white)
                            
                            Button {
                                
                                RSVPEvent()
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
                    }
                    
    
                }
                else{
                    HStack{
                        Text(String(format: "%.1f%", event.eventTotalReviews != 0 ? event.eventReviewPercentage / Double(event.eventTotalReviews) : 0.0)).foregroundColor(.white)
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
                    .padding(.bottom,3)
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
                .padding(.bottom,3)
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
           .fullScreenCover(isPresented: $showHostInformation) {
               HostProfileDescription(inGroupError:inGroupError,hostId: event.lastReview,hostName:event.lastReviewName )
           }
            
//        }
    }
    private func onAppear(){
        eventSaved = event.didISave ?? false
        eventRSVP = event.didIRSVP ?? false
        totalRSVP = event.totalRSVP ?? 0
    }
    private func RSVPEvent (){
         
        self.eventRSVP.toggle()
        if eventRSVP{
            totalRSVP += 1
            event.totalRSVP! += 1
            
            print("true")
            event.didIRSVP = true
        }else{
            totalRSVP -= 1
            event.totalRSVP! -= 1

            if totalRSVP < 0 {

                totalRSVP = 0
                event.totalRSVP! = 0

            }
            print("false")

            event.didIRSVP = false

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
    private func saveEvent (){
        
        eventViewModel.saveEvent(id: event.id) { result in
            switch result {
                
//            case .success(0):
//                joinGroupFirstError = true
//                return
            case .success(true):
//                eventSetAlreadyError = true
                event.didISave = true
                eventSaved = true
                return

            case .success(false):
                event.didISave = false

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
