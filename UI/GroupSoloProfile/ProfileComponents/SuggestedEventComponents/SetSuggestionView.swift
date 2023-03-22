//
//  SetSuggestionView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/16/23.
//

import SwiftUI

struct SetSuggestionView: View {
    @EnvironmentObject private var eventViewModel : EventViewModel
    let events : EventModel
    @State private var event : EventModel = EventModel()
    let groupId: String

    let note : String
    @Binding var chosen : Bool
    
    let setDate: Date
    @State private var isPresent : Bool = false
    var body: some View {
        GeometryReader{ geo in
            
            Button {
                isPresent.toggle()
            } label: {
                HStack{
                    Spacer()
                    VStack{
                        HStack{
                            Spacer()
                            Button {
                                unsetChosen()
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .resizable()
                                    .frame(width:geo.size.width * 0.04, height:geo.size.width * 0.04)
                                    .foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                
                            }
                        }
                        HStack{
                            
                            HStack{
                                Text(events.eventName)
                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(  LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolDarkerPurpleBackground]), startPoint: .top, endPoint: .bottom)))
                            
                            
                            //                    Spacer()
                            Text("\(events.eventPoints) LB")
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).fill( LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolDarkerPurpleBackground]), startPoint: .top, endPoint: .bottom)))
                            HStack{
                                Image(systemName:"clock.fill")
                                
                                Text("\(events.eventTime)")
                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).fill( LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolDarkerPurpleBackground]), startPoint: .top, endPoint: .bottom)))
                            
                            
                        }
                        .frame(width:geo.size.width * 0.9 )
                        
                        
                        Text("\(setDate.shortTime) \(setDate.fullDate)")
                            .frame(width:geo.size.width * 0.9 )
                        
         
                        
                    }

                    .frame(width:geo.size.width * 0.9)
                    .padding(.vertical)
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                    Spacer()
                }
//                    .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkerPurpleBackground))
        
                }
            .frame(height:geo.size.height * 0.3)
            .padding(.top,20)
            .fullScreenCover(isPresented: $isPresent) {
//                    NewEventInformationView(event: $event)
                 }
            
            

   
//                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
            .foregroundColor(.white)
            
        }
        .onAppear(perform: onAppear)
        
    }
    private func onAppear(){
        self.event = events
    }
    private func unsetChosen(){
        
        eventViewModel.unSetEvent(groupId: groupId, id: events.id) {
            self.chosen = false 
        }
        
    }
}


//struct SetSuggestionView_Previews: PreviewProvider {
//    static var events : EventModel = EventModel(id: "1", eventName: "SHepard", eventDescription: "You gotta catch some sheep and then eat themYou gotta catch some sheep and then eat them", eventRules: "there rre no rules all your gifts", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: "")
//    static var previews: some View {
//        SetSuggestionView(events: events, note:"Be there or be square")
//    }
//}
