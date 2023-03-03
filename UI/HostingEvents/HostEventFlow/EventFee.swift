//
//  EventFee.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct EventFee: View {
    @Binding var eventFee : String
    
    @State private var charLimit : Int = 200
    var body: some View {
        TextField("", text: $eventFee, axis:.vertical)
            .lineLimit(8)
            .padding()
            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.6))
            .padding()
//                                .fixedSize()
            .placeholder(when: eventFee.isEmpty) {
            Text("").opacity(0.5).font(.custom("Rubik Regular", size: 28)).foregroundColor(.white)
        }.onChange(of: eventFee, perform: {newValue in
            if(newValue.count >= charLimit){
                eventFee = String(newValue.prefix(charLimit))
            }
        })
        
    }
}

//struct EventFee_Previews: PreviewProvider {
//    static var previews: some View {
//        EventFee()
//    }
//}
