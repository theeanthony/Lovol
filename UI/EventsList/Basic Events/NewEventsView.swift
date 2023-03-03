//
//  NewEventsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/14/23.
//

import SwiftUI

struct NewEventsView: View {
    let events : EventModel
    var body: some View {
        GeometryReader{ geo in
            VStack{
                HStack{
                    
                    Text(events.eventName)
                        .padding(10)
//                        .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolLightPurple))
                    Spacer()
                    HStack{
                        Image("lovol.currency")
                            

                        Text("\(events.eventPoints)")

                    }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 5).fill(AppColor.lovolPinkish).opacity(0.8).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                    HStack{
                        Image(systemName:"clock.fill")
                        
                        Text("\(events.eventTime)")
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 5).fill(AppColor.lovolPinkish).opacity(0.8).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                    
                    
                }
                .frame(width:geo.size.width * 0.9 )
                
                .padding(.bottom,10)
                Text(events.eventDescription)
                    .padding(10)
                    .frame(width:geo.size.width * 0.9 )

//                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolLightPurple))
            }
            .frame(width:geo.size.width)
            .padding(.vertical)
            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
            
            .background(RoundedRectangle(cornerRadius: 0).fill(  LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkerPurpleBackground, AppColor.lovolPinkish]), startPoint: .top, endPoint: .bottom)).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
            .foregroundColor(.white)
        }
        
    }
}
 
//struct NewEventsView_Previews: PreviewProvider {
//    static var events : EventModel = EventModel(id: "1", eventName: "SHepard", eventDescription: "You gotta catch some sheep and then eat themYou gotta catch some sheep and then eat them", eventRules: "there rre no rules all your gifts", eventLocation: "Home", eventAverageCost: 0, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: "")
//    static var previews: some View {
//        NewEventsView(events: events)
//    }
//}
