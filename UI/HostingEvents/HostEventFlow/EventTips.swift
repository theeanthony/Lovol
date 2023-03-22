//
//  EventTips.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct EventTips: View {
    @Binding var eventTips : String
    
    @State private var charLimit : Int = 200
    var body: some View {
        TextField("", text: $eventTips, axis:.vertical)
            .lineLimit(8)
            .padding()
            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.6))
            .padding()
//                                .fixedSize()
            .placeholder(when: eventTips.isEmpty) {
            Text("Add Event Tips").opacity(0.5).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                    .padding()
                    .padding()
        }.onChange(of: eventTips, perform: {newValue in
            if(newValue.count >= charLimit){
                eventTips = String(newValue.prefix(charLimit))
            }
        })
        
    }
}

//struct EventTips_Previews: PreviewProvider {
//    static var previews: some View {
//        EventTips()
//    }
//}
