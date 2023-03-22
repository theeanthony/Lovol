//
//  EventNameView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct EventNameView: View {
    
    @Binding var eventName : String
    
    @State private var charLimit : Int = 25
    var body: some View {
        TextField("", text: $eventName, axis:.horizontal)
            .padding()
            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.6))
            .padding()
//                                .fixedSize()
            .placeholder(when: eventName.isEmpty) {
            Text("Add Event Name").opacity(0.5).font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                    .padding()
                    .padding()
        }
            .onChange(of: eventName, perform: {newValue in
            if(newValue.count >= charLimit){
                eventName = String(newValue.prefix(charLimit))
            }
        })
        
    }
}

//struct EventNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventNameView()
//    }
//}
