//
//  EventFeedBackSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/8/23.
//

import SwiftUI

struct EventFeedBackSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var eventViewModel : EventViewModel

    @State private var chosenNumber : Int = 0
    @Binding var points : Int
    let event: EventModel
    @State private var clickedOnStar : Bool = false
    @Binding var dismissed: Bool
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Your team earned")
                     
                     Text("\(points)")
                    .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)

                     Text("Lovol Bits.")
            }
        
                .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)

            Text("How did your team enjoy this event?")
                .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
            Spacer()
            HStack{
                Spacer()
                ForEach(0...4, id:\.self){index in
                    
                    Button {
                        clickedOnStar = true
                        chosenNumber = index
                        submitReview()
                    } label: {
                        Image(systemName:"star")
                            .foregroundColor(.white)
                    }
                    .padding()

                  
                    
                }
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius:10).stroke(.white,lineWidth: 1))
            .padding(.horizontal,10)
            Spacer()
        }
        .overlay(
            ZStack{
//                if isCelebrationPresent{
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                        .modifier(ParticlesModifier())
                        .offset(x: -100, y : -50)

                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                        .modifier(ParticlesModifier())
                        .offset(x: 60, y : 70)

//                }
            }
        )
        .background(
//            LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            AppColor.lovolDarkerPurpleBackground
        )
        .onDisappear(perform:dismiss)
    }
    private func dismiss(){
        self.dismissed = true 
    }
    private func submitReview(){
        eventViewModel.reviewEvent(id: event.id, star: Double(chosenNumber)) { result in
            switch result {
            case .success(()):
                dismissed = true
                presentationMode.wrappedValue.dismiss()
                return
            case .failure(let error):
                print("error submitting review \(error)")
                presentationMode.wrappedValue.dismiss()
return
            }
        }
    }
}

//struct EventFeedBackSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        EventFeedBackSheet()
//    }
//}
