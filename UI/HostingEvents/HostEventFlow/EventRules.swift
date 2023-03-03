//
//  EventRules.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct EventRules: View {
    @Binding var eventRules : String
    
    @State private var charLimit : Int = 200
    var body: some View {
        TextField("", text: $eventRules, axis:.vertical)
            .lineLimit(8)
            .padding()
            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.6))
            .padding()
//                                .fixedSize()
            .placeholder(when: eventRules.isEmpty) {
            Text("").opacity(0.5).font(.custom("Rubik Regular", size: 28)).foregroundColor(.white)
        }.onChange(of: eventRules, perform: {newValue in
            if(newValue.count >= charLimit){
                eventRules = String(newValue.prefix(charLimit))
            }
        })
        
    }
}

//struct EventRules_Previews: PreviewProvider {
//    static var previews: some View {
//        EventRules()
//    }
//}
