//
//  EventTimes.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//

import SwiftUI

struct EventTimes: View {
    @Binding var startTime : Date
    @Binding var endTime : Date
    var body: some View {
        VStack{
            HStack{
                Text("Set a start time")
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white).multilineTextAlignment(.center)
                //Available in iOS 14 only
//                    .textCase(.uppercase)
                Spacer()
            }
//            .padding(.vertical)
            HStack{
                
                DatePicker("", selection: $startTime, displayedComponents: [.date,.hourAndMinute])
                    .datePickerStyle(CompactDatePickerStyle())
                    .colorScheme(.dark)
                    .padding()
            }
            HStack{
                Text("Set an end time")
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white).multilineTextAlignment(.center)
                //Available in iOS 14 only
//                    .textCase(.uppercase)
                Spacer()
            }
//            .padding(.vertical)
            HStack{
                
                DatePicker("", selection: $endTime, displayedComponents: [.date,.hourAndMinute])
                    .datePickerStyle(CompactDatePickerStyle())
                    .colorScheme(.dark)
                    .padding()
            }
            
        }
    }
}

//struct EventTimes_Previews: PreviewProvider {
//    static var previews: some View {
//        EventTimes()
//    }
//}
