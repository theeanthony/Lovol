//
//  EventsButtonView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/16/22.
//

import SwiftUI

struct EventsButtonView: View {
    
    var event : EventModel
    var body: some View {
        GeometryReader{ geo in 
            ZStack{
                RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolTan)
//                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.2)
                HStack{
//                    Spacer()
                    Text(event.eventName)
                        .frame(width:geo.size.width * 0.6)
                    if event.eventCompleted ?? false {
                        Image(systemName: "checkmark")
                            .frame(width:geo.size.width * 0.2)

                            .padding(.trailing,10)
                            .foregroundColor(.green)
                    }
                    else{
                        Image(systemName: "chevron.right")
                            .frame(width:geo.size.width * 0.15)

                            .padding(.trailing,10)
                    }
                    Spacer()
                    
                    
                    
                    
                }
                .foregroundColor(AppColor.lovolDarkPurple)
                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolTan).tracking(4.8).multilineTextAlignment(.leading)
//                .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.18)
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                
            }
        }
    }
}

//struct EventsButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsButtonView(event: EventModel(id: "0", eventName: "chees", eventDescription: "cheesiest", eventRules: "eventRules,", eventLocation: "home",  eventAverageCost: 10 , eventTime: 100, eventPoints: 10, eventType:"Home", eventMonth: "1", eventCompleted: true, eventURL: ""))
//    }
//}
