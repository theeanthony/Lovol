//
//  ChooseEventsSubmitView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//

import SwiftUI

struct ChooseEventsSubmitView: View {
    
    let event : CompletedEvent
    @Binding var totalBits : Int
    @Binding var submittedEvents : [CompletedEvent]
    @State private var chosen: Bool = false
    var body: some View {
        GeometryReader{geo in
            HStack{
                Spacer()
                HStack{
                    //                Spacer()
                    //                VStack(spacing:0){
                    Text(event.eventName)
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                    Text("\(event.eventPoints) LB")
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius:15).fill(Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolDarkerPurpleBackground])))
                    //                        .background(Rectangle().fill(AppColor.lovolPinkPurple))
                    Spacer()
                    Button {
                        checkEvent()
                    } label: {
                        ZStack{
                            Circle()
                                .fill(chosen ? .green : .clear)
                                .frame(width:geo.size.width * 0.06, height:geo.size.width * 0.06)
                            Circle()
                                .stroke(chosen ? .black : .white, lineWidth: 2)
                                .frame(width:geo.size.width * 0.06, height:geo.size.width * 0.06)
                        }
                        
                    }
                    
                    Spacer()
                }.font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                    .frame(width:geo.size.width * 0.9, height:geo.size.height * 0.1)
            }
        }
        .onChange(of: event) { newValue in
            self.chosen = false 
        }
        Spacer()
//        .onDisappear(perform: clear)
       
    }
//    private func clear(){
//        self.chosen = false
//    }
    private func checkEvent(){
        self.chosen.toggle()
        if chosen {
            self.totalBits += event.eventPoints
            self.submittedEvents.append(event)
        }else{
            self.totalBits -= event.eventPoints
            for index in submittedEvents.indices {
                if event.id == submittedEvents[index].id{
                    submittedEvents.remove(at: index)
                    return
                }
            }

        }

    }
}

//struct ChooseEventsSubmitView_Previews: PreviewProvider {
//    
//    @State static var totalBits : Int = 0
//    @State static var submittedEvents : [CompletedEvent] = [CompletedEvent(photoURL: "", eventName: "Lets go", eventMonth: "", eventPoints: 30, id: "", submittedForPoints: false, eventType: "Home")]
//    static var previews: some View {
//        ChooseEventsSubmitView(event:CompletedEvent(photoURL: "", eventName: "Helloooo", eventMonth: "", eventPoints: 0, id: "", submittedForPoints: false, eventType: "Home"), totalBits : $totalBits, submittedEvents: $submittedEvents)
//    }
//}
