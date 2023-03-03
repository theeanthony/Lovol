//
//  FrontAddView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI
enum HostFlow{
    case EventName
    case EventDescription
    case EventDestination
    case EventRules
    case EventTips
    case EventOfferings
    case EventTimes
    case EventTags
    case EventExclusivity
    case EventFee
    case EventAge
    case EventPicture
    case EventEdit
    case EventPending
}
struct FrontAddView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var eventViewModel : EventViewModel
    
    let groupId : String
    @State private var note : String = ""
    @State private var eventName : String = ""
    @State private var address : String = ""
    @State private var eventDescription : String = ""
    @State private var eventRules : String = ""
    @State private var eventTips : String = ""
    @State private var eventOfferings : String = ""
    @State private var eventCityName : String = ""
    @State private var eventLongCoord : Double = 0
    @State private var eventLatCoord : Double = 0
    
    @State private var eventStartTime : Date = Date()
    @State private var eventEndTime : Date = Date()
    
    @State private var eventTags : [String] = []
    
    @State private var exclusivity : Int = 0
    
    @State private var eventFee : String = ""
    
    @State private var over21 : Bool = false
    
    @State private var uploadedImage : UIImage = UIImage()
    @State private var initialImage : UIImage = UIImage()
    
    @State private var incompletedQuestions : String = ""
    @State private var showIncompleteError : Bool = false
    @State private var listHeaders : [String] = ["Event Name", "Event Description", "Event Destination", "Event Rules","Event Tips", "Event Offerings","Event Times", "Event Tags", "Event Exclusivity", "Event Fee", "Event Age", "Event Picture", "",""]
    @State private var eventDescriptors : [String] = ["Name your event", "Describe your event/ activity", "Where will this event be located", "Are there any guidelines people coming to this event should follow? Is there a dress code? Should they bring anything? Should they prepared to do something? ","Is there any advice to make this event successful and enjoyable by all? Is your location in a weird spot and needs further explaination?", "Will your team be offering anything to those that come to your event? ","Event Times", "Choose 3 - 5 tags", "Who can come", "Will you be charging any fees? What should people coming expect to pay?", "Must they be over 21", "Upload a picture that relates to your event","",""]
    @State private var index : Int = 0
    
    @State private var hostStage : HostFlow = .EventName
    @State private var uploadingEvent : Bool = false
    @State private var hostIndex : [HostFlow] = [.EventName,.EventDescription,.EventDestination,.EventRules,.EventTips,.EventOfferings,.EventTimes,.EventTags,.EventExclusivity,.EventFee,.EventAge,.EventPicture,.EventEdit,.EventPending]
    
    @State private var errorUploadingEvent : Bool = false

    var body: some View {
        VStack{
            Spacer()
            Section(header:ListHeader(text:listHeaders[index])){
                ScrollView{
                    
                    Text(eventDescriptors[index])
                        .padding(.vertical)
                    
                    switch hostStage {
                    case .EventName:
                        EventNameView(eventName: $eventName)

                    case .EventDescription:
                        EventDescription(eventDescription: $eventDescription)

                    case .EventDestination:
                        EventDestination(cityName:$eventCityName,long: $eventLongCoord,lat:$eventLatCoord, eventAddress: $address)

                    case .EventRules:
                       EventRules(eventRules: $eventRules)

                    case .EventTips:

                        EventTips(eventTips: $eventTips)
                    case .EventOfferings:
                        EventOfferings(eventOfferings: $eventOfferings)
                    case .EventTimes:
                       EventTimes(startTime: $eventStartTime, endTime: $eventEndTime)

                    case .EventTags:
                        EventTags(tags:$eventTags)

                    case .EventExclusivity:
                        EventExclusivity(exclusivity: $exclusivity)

                    case .EventFee:
                        EventFee(eventFee:$eventFee)

                    case .EventAge:
                        EventAge(over21:$over21)

                    case .EventPicture:
                       EventPicture(uploadedImage: $uploadedImage, initialImage: $initialImage)

                    case .EventEdit:
                        EventEditView(listHeaders: listHeaders, eventName: $eventName, eventDescription: $eventDescription, eventRules: $eventRules, eventTips: $eventTips, eventOfferings: $eventOfferings, cityName: $eventCityName, eventLong: $eventLongCoord, eventLat: $eventLatCoord, eventStartTime: $eventStartTime, eventEndTime: $eventEndTime, eventTags: $eventTags, exclusivity: $exclusivity, eventFee: $eventFee, over21: $over21, uploadedImage: $uploadedImage, initialImage: $initialImage,eventAddress: $address)

                    case .EventPending:
                        
                        VStack{
                            HStack{
                                Text("Congrats on submitting an event!")
                                    .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                                
                                Spacer()
                            }
                            HStack{
                                Text("Please give us sometime to verify the event. Feel free to check the pending events section to check if your event has been accepted.")
                                    .font(.custom("Rubik Regular", size: 13)).foregroundColor(.white)

                                Spacer()
                            }
                            .padding(.top,25)
                        }
                    }
//                    Spacer()
                    Button {
                        
                        if index < 12 {
                            index += 1
                            hostStage = hostIndex[index]
                        }
                        else if index == 12{
                            submit()

                        }
                        else {
                            presentationMode.wrappedValue.dismiss()
                        }
          
                    } label: {
                        
                        if index <= 12 {
                            Text( index < 12 ? "Next" : "Save")
                                .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                            
                                .padding()
                                .padding(.horizontal,30)
                                .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                        }
                        else{
                            Text("Done")
                                .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                            
                                .padding()
                                .padding(.horizontal,30)
                                .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                        }
                    }
                    .padding(.top,50)
//                    Spacer()

                    
                }
                
            }
            Spacer()
        }
        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

        .padding(.top,50)
        .padding()
        .overlay(
            VStack{
                HStack{
                    Button {
                        if index == 0 || index == hostIndex.count - 1 {
                            return
                        }else{
                            index -= 1
                            hostStage = hostIndex[index]

                            return
                        }
                        
                    } label: {
                        Image(systemName:"chevron.left").foregroundColor(.white)

                    }

                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"xmark").foregroundColor(.white)

                    }

                }
                Spacer()
            }
                .padding()
        )
        .background(
            BackgroundView()

           
        )
        .showLoading(uploadingEvent)
        .onAppear(perform: onAppear)
        .ignoresSafeArea(.keyboard)
        .alert("The following issues have occured: \(incompletedQuestions)", isPresented: $showIncompleteError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .alert("There has been an error uploading your event. It may most likely have something to do with your internet connection and your photo not being able to be uploaded properly.", isPresented: $errorUploadingEvent, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
    }
    func submit(){
        if checkComplete(){
            let randomId = UUID().uuidString
            eventViewModel.checkLiveStatus { result in
                switch result{
                case .success(let live):
                    let eventMonth = live.season
                    let eventModel : HostEvent = HostEvent(hostId:groupId,eventId: randomId, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules, eventTips: eventTips, eventOfferings: eventOfferings, eventAddress: address, eventCityName: address, eventLongCoord: eventLongCoord, eventLatCoord: eventLatCoord, eventStartTime: eventStartTime, eventEndTime: eventEndTime, eventTags: eventTags, exclusivity: exclusivity, eventFee: eventFee, over21: over21, photoURL: "",  note: note, isActive: false, isRejected:false,isCompleted: false, eventMonth: eventMonth)
                    self.uploadingEvent = true
                    eventViewModel.submitHostEvent(uploadedImage: uploadedImage, groupId: groupId, event: eventModel) { result in
                        switch result{
                        case .success(()):
                            self.uploadingEvent = false
                            
                            index += 1
                            hostStage = hostIndex[index]
                        case .failure(let error):
                            print("error submitting event, probably because of image \(error)")
                            self.errorUploadingEvent = true
                            self.uploadingEvent = false
                            return
                        }
                    }
                case .failure(let error):
                    print("error fetching season pass \(error)")
                    return
                }
            }
        }
        else{
            self.showIncompleteError = true
        }
            
            
            
        
    }
    func checkComplete()->Bool{
        
        self.incompletedQuestions = ""
        if eventName.isEmpty {
           incompletedQuestions += "Event Name is empty. "
        }
        if address.isEmpty{
            incompletedQuestions += "Event Address is empty. "

        }
        
        if eventDescription.isEmpty{
            incompletedQuestions += "Event Description is empty. "
        }
        if eventRules.isEmpty{
            incompletedQuestions += "Event Rules is empty. "

        }
        if eventTips.isEmpty{
            incompletedQuestions += "Event Tips is empty. "

        }
        if eventOfferings.isEmpty{
            incompletedQuestions += "Event Offerings is empty. "

        }
        if eventStartTime == eventEndTime || eventStartTime < Date(){
            incompletedQuestions += "Event Start Date is not valid. "

        }
        if uploadedImage == initialImage{
            incompletedQuestions +=  "Image is Empty. "

        }
        if incompletedQuestions.isEmpty{
            return true
        }
        return false

        
        
        
    }
    func onAppear(){
        self.initialImage = uploadedImage
    }
}

//struct FrontAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        FrontAddView()
//    }
//}
