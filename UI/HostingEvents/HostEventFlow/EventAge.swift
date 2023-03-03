//
//  EventAge.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//

import SwiftUI

struct EventAge: View {
    
    @Binding var over21 : Bool 
    @State private var initial : Bool = false
    var body: some View {
       
        HStack{
            Spacer()
            Button {
                self.initial = true
                self.over21 = true
            } label: {
                Text("Yes")
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                    .padding()
                    .padding(.horizontal,10)
                    .background(RoundedRectangle(cornerRadius: 30).fill(over21 && initial ? AppColor.lovolDarkerPurpleBackground : AppColor.lovolPinkish))
            }
            Spacer()

            Button {
                self.initial = true

                self.over21 = false
            } label: {
              Text("No")
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                    .padding()
                    .padding(.horizontal,10)
                    .background(RoundedRectangle(cornerRadius: 30).fill(!over21 && initial ? AppColor.lovolDarkerPurpleBackground : AppColor.lovolPinkish))
            }
            Spacer()

        }
        
    }
}

//struct EventAge_Previews: PreviewProvider {
//    static var previews: some View {
//        EventAge()
//    }
//}
