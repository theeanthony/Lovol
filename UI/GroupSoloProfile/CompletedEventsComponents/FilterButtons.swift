//
//  FilterButtons.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//

import SwiftUI

struct FilterButtons: View {
    
    let buttons : [String] = ["All","Home","Local","Virtual","21+","Couples","Extreme","After Dark"]
    let allEvents : [FetchedEvent]
    @Binding var events : [FetchedEvent]
    @State private var chosen : Int = 0
    var body: some View {
        GeometryReader{geo in
            
            VStack{
                HStack{
                    Spacer()
                    ForEach(0...3,id:\.self){ index in
                        Button {
                            filter(index:index)
                        } label: {
                            Text(buttons[index])
                        }
                        .padding(10).background(RoundedRectangle(cornerRadius:30).fill(chosen == index ? AppColor.lovolPinkish : AppColor.lovolDarkerPurpleBackground))
                    }
                    Spacer()

      

                    
                }.font(.custom("Rubik Regular", size: 11)).foregroundColor(.white)
                HStack{                    Spacer()

                    ForEach(4...7,id:\.self){ index in
                        Button {
                            filter(index:index)

                        } label: {
                            Text(buttons[index])
                        }
                        .padding(10).background(RoundedRectangle(cornerRadius:30).fill(chosen == index ? AppColor.lovolPinkPurple : AppColor.lovolDarkerPurpleBackground))
                    }
                    Spacer()

                }.font(.custom("Rubik Regular", size: 11)).foregroundColor(.white)
            }
          
            
            
        }
    }
    private func filter(index: Int){
        self.chosen = index
        print(buttons[index])
        if buttons[index] == "All" {
            self.events = allEvents
        }else{
            self.events = allEvents.filter { $0.eventType == buttons[index] }
        }
        return
      
    }
}

//struct FilterButtons_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterButtons()
//    }
//}
