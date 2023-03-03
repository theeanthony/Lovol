//
//  FilterButtonsPointsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//

import SwiftUI

struct FilterButtonsPointsView: View {
    let buttons : [String] = ["Points","Points"]
    @State private var chosen : Int = 0
    
    @Binding var fetchedEvents : [CompletedEvent]

    var body: some View {
        GeometryReader{geo in
            
            VStack{
                HStack{
                    Spacer()
                    Button {
                        self.chosen = 0
                        filterEvents()
                    } label: {
                        HStack{
                            Text(buttons[0])
                            Image(systemName:"arrow.up")
                        }
                        .padding().background(RoundedRectangle(cornerRadius: 30).fill(chosen == 0 ? AppColor.lovolPinkish : AppColor.lovolDarkerPurpleBackground))
                    }

      
                    Spacer()
                    Button {
                        self.chosen = 1
                        filterEvents()

                    } label: {
                        HStack{
                            Text(buttons[1])
                            Image(systemName:"arrow.down")

                        }
                        .padding().background(RoundedRectangle(cornerRadius: 30).fill(chosen == 1 ? AppColor.lovolPinkish : AppColor.lovolDarkerPurpleBackground))
                    }
           
                    Spacer()
      

                    
                }.font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
        
            }
          
            
            
        }
        .onAppear(perform: filterEvents)
    }
    private func filterEvents(){
        
        if chosen == 0 {
            fetchedEvents.sort {
                $0.eventPoints > $1.eventPoints
            }
        }else{
            fetchedEvents.sort {
                $0.eventPoints < $1.eventPoints
            }
        }
   
    }
    
}

//struct FilterButtonsPointsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterButtonsPointsView()
//    }
//}
