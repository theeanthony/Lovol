//
//  EventEditView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//

import SwiftUI

struct EventEditView: View {
    
    let listHeaders : [String]
    @Binding var eventName : String
    @Binding var eventDescription : String
    @Binding var eventRules : String
    @Binding var eventTips : String
    @Binding var eventOfferings : String
    @Binding var cityName : String
    @Binding var eventLong : Double
    @Binding var eventLat : Double
    @Binding var eventStartTime : Date
    @Binding var eventEndTime : Date
    @Binding var eventTags : [String]
    @Binding var exclusivity : Int
    @Binding var eventFee : String
    @Binding var over21 : Bool
    @Binding var uploadedImage : UIImage
    @Binding var initialImage : UIImage
    @Binding var eventAddress : String 
    
    var body: some View {
        
        VStack{
            Text("Please make sure this is as accurate as possible, you will not be able to edit once submitted.")
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

            Group{
                Section(header:ListHeader(text: listHeaders[0])){
                    EventNameView(eventName: $eventName)
                        .padding(.vertical)

                }
                
                Section(header:ListHeader(text: listHeaders[1])){
                    EventDescription(eventDescription: $eventDescription)
                        .padding(.vertical)

                }
                Section(header:ListHeader(text: listHeaders[2])){
                    EventDestination(cityName:$cityName,long: $eventLong,lat:$eventLat, eventAddress:$eventAddress)
                        .padding(.vertical)

                }
                Section(header:ListHeader(text: listHeaders[3])){
                    EventRules(eventRules: $eventRules)
                        .padding(.vertical)

                }
                Section(header:ListHeader(text: listHeaders[4])){
                    EventTips(eventTips: $eventTips)
                        .padding(.vertical)

                }
                Section(header:ListHeader(text: listHeaders[5])){
                    EventOfferings(eventOfferings: $eventOfferings)
                        .padding(.vertical)

                }
                Section(header:ListHeader(text:listHeaders[6])){
                    EventTimes(startTime: $eventStartTime, endTime: $eventEndTime)
                        .padding(.vertical)

                }
                Section(header:ListHeader(text: listHeaders[7])){
                    EventTags(tags:$eventTags)
                        .padding(.vertical)

                }
            }
            Section(header:ListHeader(text: listHeaders[8])){
                EventExclusivity(exclusivity: $exclusivity)
                    .padding(.vertical)

            }
            Section(header:ListHeader(text: listHeaders[9])){
                EventFee(eventFee:$eventFee)
                    .padding(.vertical)

            }
            Section(header:ListHeader(text: listHeaders[10])){
                EventAge(over21:$over21)
                    .padding(.vertical)

            }
            Section(header:ListHeader(text: listHeaders[11])){
                EventPicture(uploadedImage: $uploadedImage, initialImage: $initialImage)
                    .padding(.vertical)

            }
            

            
        }
        
    }
}

//struct EventEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventEditView()
//    }
//}
