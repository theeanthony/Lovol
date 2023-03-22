//
//  AddEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/21/23.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var eventViewModel : EventViewModel
    @State private var listHeaders : [String] = ["Event Name", "Event Description", "Event Destination", "Event Rules","Event Tips", "Event Offerings","Event Times", "Event Tags", "Event Exclusivity", "Event Fee", "Event Age", "Event Picture", "",""]
    let groupId:String
    let hostName:String

    let hostEvent : HostEvent
    @State private var eventName : String = ""
    @State var eventDescription : String = ""
    @State private var eventRules : String = ""
    @State private var eventTips : String = ""
    @State private var eventOfferings : String = ""
    @State private var cityName : String = ""
    @State private var eventLong : Double = 0
    @State private var eventLat : Double = 0
    @State private var eventStartTime : Date = Date()
    @State private var eventEndTime : Date = Date()
    @State private var eventTags : [String] = []
    @State private var exclusivity : Int = 0
    @State private var eventFee : String = ""
    @State private var over21 : Bool = false
    @State private var uploadedImage : UIImage = UIImage()
    @State private var initialImage : UIImage = UIImage()
    @State private var eventAddress : String = ""
    @State private var incompletedQuestions : String = ""
    @State private var showIncompleteError : Bool = false
    @State private var uploadingEvent : Bool = false
    @State private var errorUploadingEvent : Bool = false
    
    var body: some View {
        
        VStack{
            ScrollView{
                Text("Please make sure this is as accurate as possible, you will not be able to edit once submitted.")
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                
                Group{
                    Section(header:ListHeader(text: listHeaders[0])){
                        EventNameView(eventName: $eventName)
                            .padding(.vertical)
                        
                    }
                    
                    Section(header:ListHeader(text: listHeaders[1])){
                        EventDescription(eventDescription: $eventDescription)
                            .padding(.vertical)
                        
                    }
                    Section(header:ListHeader(text: listHeaders[2])){
                        EventDestination(cityName:$cityName,long: $eventLong,lat:$eventLat, eventAddress:$eventAddress)
                            .padding(.vertical)
                        
                    }
                    Section(header:ListHeader(text: listHeaders[3])){
                        EventRules(eventRules: $eventRules)
                            .padding(.vertical)
                        
                    }
                    Section(header:ListHeader(text: listHeaders[4])){
                        EventTips(eventTips: $eventTips)
                            .padding(.vertical)
                        
                    }
                    Section(header:ListHeader(text: listHeaders[5])){
                        EventOfferings(eventOfferings: $eventOfferings)
                            .padding(.vertical)
                        
                    }
                    Section(header:ListHeader(text:listHeaders[6])){
                        EventTimes(startTime: $eventStartTime, endTime: $eventEndTime)
                            .padding(.vertical)
                        
                    }
                    Section(header:ListHeader(text: listHeaders[7])){
                        EventTags(tags:$eventTags)
                            .padding(.vertical)
                        
                    }
                }
                Section(header:ListHeader(text: listHeaders[8])){
                    EventExclusivity(exclusivity: $exclusivity)
                        .padding(.vertical)
                    
                }
                Section(header:ListHeader(text: listHeaders[9])){
                    EventFee(eventFee:$eventFee)
                        .padding(.vertical)
                    
                }
                Section(header:ListHeader(text: listHeaders[10])){
                    EventAge(over21:$over21)
                        .padding(.vertical)
                    
                }
                Section(header:ListHeader(text: listHeaders[11])){
                    EventPicture(uploadedImage: $uploadedImage, initialImage: $initialImage)
                        .padding(.vertical)
                    
                }
                Button {
                    submit()
                } label: {
                    Text("Submit")
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(RoundedRectangle(cornerRadius:30).fill(AppColor.lovolDarkerPurpleBackground))
                }

                
                
                
            }
            .padding()
        }
        .overlay(
            VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"xmark").foregroundColor(.white)
                            .padding(4)
                            .background(Circle().fill(AppColor.lovolDarkerPurpleBackground.opacity(0.4)))
                    }

                    Spacer()
                }
                .padding()
                Spacer()
            }
            
            
        
        )
        .ignoresSafeArea(.keyboard)
        .showLoading(uploadingEvent)
        .background(
            AppColor.lovolDark
         
           
        )
        .onAppear(perform: onAppear)
        .alert("The following issues have occured: \(incompletedQuestions)", isPresented: $showIncompleteError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .alert("There has been an error uploading your event. It may most likely have something to do with your internet connection and your photo not being able to be uploaded properly.", isPresented: $errorUploadingEvent, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
    }
    private func onAppear(){

        
        self.eventName = hostEvent.eventName
        self.eventDescription = hostEvent.eventDescription
        self.eventRules = hostEvent.eventRules
        self.eventTips = hostEvent.eventTips
        self.eventOfferings = hostEvent.eventOfferings
        self.cityName = hostEvent.eventCityName
        self.eventLong = hostEvent.eventLongCoord
        self.eventLat = hostEvent.eventLatCoord
        self.eventStartTime = hostEvent.eventStartTime
        self.eventEndTime = hostEvent.eventEndTime
        self.eventTags = hostEvent.eventTags
        self.exclusivity = hostEvent.exclusivity
        self.eventFee = hostEvent.eventFee
//        self.over21 = hostEvent.over21
        self.eventAddress = hostEvent.eventAddress
        
        
        eventViewModel.fetchPicture(groupId: groupId, event: hostEvent) { result in
            switch result{
            case .success(let image):
                print("success retrieving image")
                self.uploadedImage = image
//                self.initialImage = image
                return 
                
            case .failure(let error):
                print("error loading pics \(error)")
                self.initialImage = uploadedImage
                return
            }
        }
    }
    func submit(){
        if checkComplete(){
            let randomId = UUID().uuidString
            eventViewModel.checkLiveStatus { result in
                switch result{
                case .success(let live):
                    let eventMonth = live.season
                    let eventModel : HostEvent = HostEvent(hostId:groupId, hostName: hostName,eventId: hostEvent.eventId, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules, eventTips: eventTips, eventOfferings: eventOfferings, eventAddress: eventAddress, eventCityName: eventAddress, eventLongCoord: eventLong, eventLatCoord: eventLat, eventStartTime: eventStartTime, eventEndTime: eventEndTime, eventTags: eventTags, exclusivity: exclusivity, eventFee: eventFee, photoURL: "",  note: "", isActive: false, isRejected:false,isCompleted: false, eventMonth: eventMonth)
                    self.uploadingEvent = true
                    eventViewModel.submitHostEvent(uploadedImage: uploadedImage, groupId: groupId, event: eventModel) { result in
                        switch result{
                        case .success(()):
                            
                            self.uploadingEvent = false
                            presentationMode.wrappedValue.dismiss()

                        case .failure(let error):
                            print("error submitting event, probably because of image \(error)")
                            self.errorUploadingEvent = true
                            self.uploadingEvent = false
                            return
                        }
                    }
                case .failure(let error):
                    print("error fetching live event status try again \(error)")
                    return
                }
            }

            
            
        }else{
            self.showIncompleteError = true
        }
    }
    func checkComplete()->Bool{
        
        self.incompletedQuestions = ""
        if eventName.isEmpty {
           incompletedQuestions += "Event Name is empty. "
        }
        if eventAddress.isEmpty{
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
                    
}
//
//struct AddEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEventView()
//    }
//}
