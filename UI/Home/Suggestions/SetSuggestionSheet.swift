//
//  SetSuggestionSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/16/23.
//

import SwiftUI

struct SetSuggestionSheet: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject private var eventViewModel : EventViewModel
    @State private var charLimit : Int = 50
    @State private var note : String = ""
    @Binding var setDate : Date
    let groupId: String
    let id : String
    let teamName:String
    @Binding var chosenEvent : EventModel
    @Binding var initialChosen : Bool
    
    @State private var openToAlliances : Bool = false
    let event : EventModel
    var body: some View {
        
        GeometryReader {geo in
            VStack{
                Spacer()
                ScrollView{
                    
                    HStack{
                        Text("Set a Meeting Time")
                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white).multilineTextAlignment(.center)
                        //Available in iOS 14 only
                            .textCase(.uppercase)
                        Spacer()
                    }
                    .frame(width:geo.size.width * 0.9)
                    .padding(.vertical)
                    HStack{
                        
                        DatePicker("", selection: $setDate, displayedComponents: [.date,.hourAndMinute])
                            .datePickerStyle(CompactDatePickerStyle())
                            .colorScheme(.dark)
                            .padding()
                    }
                    .frame(width:geo.size.width * 0.5)
                    
                    Toggle("Open this event to alliances?", isOn: $openToAlliances)
                        .frame(width:geo.size.width * 0.7)
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white).multilineTextAlignment(.center)

                    if openToAlliances {
                        HStack{
                            Text("Add a note")
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white).multilineTextAlignment(.center)
                            //Available in iOS 14 only
                                .textCase(.uppercase)
                            Spacer()
    
                        }
                        .frame(width:geo.size.width * 0.9)
                        .padding(.vertical)
                        HStack{
                            VStack{
                                TextField("", text: $note, axis:.vertical).placeholder(when: note.isEmpty) {
                                    Text("Write Something").opacity(0.5)
                                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                }.onChange(of: note, perform: {newValue in
                                    if(newValue.count >= charLimit){
                                        note = String(newValue.prefix(charLimit))
                                    }
                                })
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                .lineLimit(1)
                               
                            } .frame(width:geo.size.width * 0.7)
                            Text("\(charLimit - note.count)").foregroundColor(.white).font(.headline).bold()
                                .padding(.trailing,5)
                    
                        }
                        .frame(maxWidth:geo.size.width * 0.9)
                        .padding(.vertical,10)
                        .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolPrettyPurple))
                    }

                    


                    
                }
                .frame(width:geo.size.width, height:geo.size.height * 0.8)
                
                Button {
                    setEventAsMain()
                } label: {
                    Rectangle().fill(AppColor.lovolLightPurple).frame(width:geo.size.width,height:100)
                        .overlay(
                        Text("Set")
                            .font(.custom("Rubik Regular", size: 24)).foregroundColor(.white).multilineTextAlignment(.center)
                        )

                }

            }
//            .frame(width:.infinity, height:.infinity)
            .background(AppColor.lovolDarkPurple)
        
            
        }
       
    }
    private func setEventAsMain(){
        
        
    
        eventViewModel.setEvent(teamName: teamName, groupId: groupId, id: event.id, date: setDate, openEvent:openToAlliances, note: note) {
            self.chosenEvent = event
            self.initialChosen = true
            dismiss()
        }
        
        
    }
}

//struct SetSuggestionSheet_Previews:
//    PreviewProvider {
//    @State static var chosenEvent : EventModel = EventModel()
//    @State static var initialChosen : Bool = false
//    @State static var setDate : Date = Date()
//    static var previews: some View {
//        SetSuggestionSheet(setDate: $setDate, groupId: "", id: "", teamName: "", chosenEvent: $chosenEvent, initialChosen: $initialChosen, event: EventModel(id: "", eventName: "", eventDescription: "", eventRules: "", eventAverageCost: 0, eventTime: 0, eventPoints: 0, eventType: "Home", eventMonth: "", eventURL: "", eventOfferings: "", eventTips: "", eventTags: [], isTemp: false , eventReviewPercentage: 0, eventTotalReviews: 0, eventLocation: false, long:0,lat:0) )
//    }
//}
