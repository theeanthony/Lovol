//
//  EventOfferings.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct EventOfferings: View {
    @Binding var eventOfferings : String
    
    @State private var charLimit : Int = 200
    var body: some View {
        TextField("", text: $eventOfferings, axis:.vertical)
            .lineLimit(8)
            .padding()
            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.6))
            .padding()
//                                .fixedSize()
            .placeholder(when: eventOfferings.isEmpty) {
            Text("").opacity(0.5).font(.custom("Rubik Regular", size: 28)).foregroundColor(.white)
        }.onChange(of: eventOfferings, perform: {newValue in
            if(newValue.count >= charLimit){
                eventOfferings = String(newValue.prefix(charLimit))
            }
        })
        
    }
}

//struct EventOfferings_Previews: PreviewProvider {
//    static var previews: some View {
//        EventOfferings()
//    }
//}
