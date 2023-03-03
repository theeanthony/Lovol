//
//  SuggestedEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/16/23.
//

import SwiftUI

struct SuggestedEventView: View {
    @EnvironmentObject private var eventViewModel : EventViewModel
    let teamName: String
    let groupId: String 
    let event : EventModelWithLikes
    
    @State private var fillHeart : Bool = false
    @State private var likes : Int = 0
    @Binding var initialChosen : Bool
    @Binding var chosenEvent : EventModel
    
    @Binding var unsavedEvents : String
    
    @State private var setTimeSheet : Bool = false
    
    @Binding  var date : Date 
    var body: some View {
        
        GeometryReader { geo in
            HStack{
                Spacer()
                VStack(spacing:5){
                    
      
                    
                    Text(event.event.eventName)
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                    VStack(spacing:5){
                        Button(action: {
                            likeEvent()
                        }, label: {

                            if fillHeart {
                                Image(systemName:"heart.fill")
                                    .resizable()
                                    .foregroundColor(.red)

                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                    .padding(.vertical,5)
                            }else{
                                Image(systemName:"heart")
                                    .resizable()
                                    .foregroundColor(.red)

                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                    .padding(.vertical,5)
                            }



                        })
                        Text("\(likes)").font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                    }
   
                    
                    
                    
   
//                        .overlay(

//
//                        )
//                    Rectangle().fill(AppColor.lovolDarkerPurpleBackground).frame(width:geo.size.width * 0.7 , height:geo.size.width * 0.3).cornerRadius(10, corners: [.bottomLeft,.bottomRight])
//                        .overlay(

//                        )
                }
                .frame(width:geo.size.width ,height:geo.size.width * 0.95)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white).opacity(0.2)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                .overlay(
                    VStack{
                       
                            HStack{
                                Spacer()
                                
                                Button {
                                    unsaveEvent()
                                } label: {
                                    Image(systemName:"xmark.circle.fill")
                                        .resizable()
                                    //                                    .padding(.trailing,10)
                                        .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                        .foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                }
                            }
                            .padding(.top,10)
                        
                        Spacer()
                        Button(action: {
                            setTimeSheet.toggle()
                        }, label: {
                            Image(systemName:"chevron.right")
                                .resizable()
                                .frame(width:geo.size.width * 0.07, height:geo.size.width * 0.07)
                                .foregroundColor(.white)

                           
                                .padding(5)
                                .background(Circle().fill(AppColor.lovolDarkerPurpleBackground)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                        })
                        
                    }
                        .frame(width:geo.size.width,height:geo.size.width * 1.1)
                )
              

                     
////                .overlay(
//                    VStack{
//                        HStack{
//                            Spacer()
//                            Button {
//                                unsaveEvent()
//                            } label: {
//                                Image(systemName:"xmark")
//                                    .foregroundColor(.white)
//                                    .offset(x:8, y: -3)
//
//
//                            }
//
//                        }
//                        Spacer()
//                    }
//                )
                Spacer()
                
            }
        }
        .onAppear(perform:onAppear)
        .sheet(isPresented: $setTimeSheet) {
            SetSuggestionSheet(setDate: $date, groupId: groupId, id: event.event.id, teamName: teamName, chosenEvent: $chosenEvent, initialChosen : $initialChosen , event:event.event)
                .presentationDetents([ .medium])
                        .presentationDragIndicator(.hidden)


        }
    }
    private func setEventAsMain(){
        
        
    
//        eventViewModel.setEvent(groupId: groupId, id: event.event.id) {
//            self.chosenEvent = event.event
//            self.initialChosen = true
//        }
        
        
    }
    private func unsaveEvent(){
        eventViewModel.unsaveSuggestedEvent(groupId: groupId, id: event.event.id) { result in
            switch result {
            case .success(_):
                self.unsavedEvents = event.event.id
                return 
            case .failure(let error):
                print("error unsaving event \(error)")
                return
            }
        }
    }
    private func onAppear(){
        self.fillHeart = event.chosen
        self.likes = event.likes
        
      

//        self.initialChosen = event.
    }
    private func likeEvent(){
        eventViewModel.likeSuggestedEvent(groupId: groupId, id: event.event.id) { result in
            switch result{
            case .success(_):
                self.fillHeart.toggle()
                if fillHeart {
                    self.likes += 1
                }else{
                    self.likes -= 1
                }
            case .failure(let error):
                print("error liking \(error)")
            }
        }
     
        
    }
}

//struct SuggestedEventView_Previews: PreviewProvider {
//    @State static var initialChosen : Bool = false
//    @State static var unsaved : String = ""
//    @State static var chosenEvent : EventModel = EventModel(id: "", eventName: "", eventDescription: "", eventRules: "", eventLocation: "", eventAverageCost: 0, eventTime: 0, eventPoints: 0, eventType: "", eventMonth: "", eventCompleted: false, eventURL: "")
//    @State static var date : Date = Date()
//                                                            

//    static var previews: some View {
//
//        SuggestedEventView(groupId: "", event: EventModelWithLikes(event: EventModel(id: "", eventName: "Sunset", eventDescription: "Watch the sunset with your team yo and make sure you have lots of fun", eventRules: "", eventLocation: "", eventAverageCost: 30, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "", eventURL: ""), likes:3, chosen:false), initialChosen: $initialChosen, chosenEvent: $chosenEvent, unsavedEvents:$unsaved, date: $date)
//        
//        
//    }
//}
