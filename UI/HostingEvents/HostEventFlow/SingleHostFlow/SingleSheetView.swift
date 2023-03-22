//
//  FrontAddView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct SingleSheetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var eventViewModel : EventViewModel
    
    let groupId : String
    let hostName:String
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
    
    
    @State private var uploadedImage : UIImage = UIImage()
    @State private var initialImage : UIImage = UIImage()
    
    @State private var incompletedQuestions : String = ""
    @State private var showIncompleteError : Bool = false
 
//    @State private var eventDescriptors : [String] = ["Name your event", "Describe your event/ activity", "Where will this event be located", "Are there any guidelines people coming to this event should follow? Is there a dress code? Should they bring anything? Should they prepared to do something? ","Is there any advice to make this event successful and enjoyable by all? Is your location in a weird spot and needs further explaination?", "Will your team be offering anything to those that come to your event? ","Event Times", "Choose 3 - 5 tags", "Who can come", "Will you be charging any fees? What should people coming expect to pay?", "Must they be over 21", "Upload a picture that relates to your event","",""]
    @State private var index : Int = 0
    
    @State private var uploadingEvent : Bool = false

    
    @State private var errorUploadingEvent : Bool = false
    @State private var isOptionalInfoVisible = false
    
    @State private var showQuickSheet : Bool = false
    
    @State private var quickSheetText : String = ""
    @Binding var submittedEvent : Bool

    var body: some View {
        VStack{
            Spacer()
                ScrollView{
                    Group{
                        VStack(spacing:0){
                       
                            EventPicture(uploadedImage: $uploadedImage, initialImage: $initialImage)
                            HStack{
                                Spacer()
                                Text("Add a cover photo")
                                Spacer()
                            }
                        }
                        .padding(.bottom,5)
                        
                        VStack(spacing:0){
                            HStack{
                                Text("Event Name *")
                                Spacer()
                            }
                            EventNameView(eventName: $eventName)
                        }
                        
                        EventTimes(startTime: $eventStartTime, endTime: $eventEndTime)
                        VStack(spacing:0){
                            HStack{
                                Text("Address *")
                                Spacer()
                            }
                            EventDestination(cityName:$eventCityName,long: $eventLongCoord,lat:$eventLatCoord, eventAddress: $address)
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Cost *")
                                Spacer()
                            }
                            EventFee(eventFee:$eventFee)
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Who can come? *")
                                Spacer()
                            }
                            EventExclusivity(exclusivity: $exclusivity)
                        }
                    }
                    Group{
                        VStack(spacing:0){
                            HStack{
                                Text("Description *")
                                Spacer()
                            }
                            
                            EventDescription(eventDescription: $eventDescription)
                        
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Event Rules")
                                Button {
                                    quickSheetText = "How can participants take pictures at this event to show that they were there?"
                                    showQuickSheet = true
                               
                                } label: {
                                    Image(systemName:"questionmark.circle.fill").foregroundColor(.white)
                                }

                                Spacer()
                            }
                            EventRules(eventRules: $eventRules)
                        }
                        
                        
                        Button(action: {
                            withAnimation {
                                isOptionalInfoVisible.toggle()
                            }
                        }, label: {
                            Text("Optional Information")
                                .font(.custom("Rubik Bold", size: 14))
                                .foregroundColor(.white)
                        })
                        .padding(.bottom, 20)
                        
                        if isOptionalInfoVisible{
                            VStack{
                       
                                HStack{
                                    Text("Event Tips")
                                    Button {
                                        self.quickSheetText = "Is there any advice to make this event successful and enjoyable by all? Is your location in a weird spot and needs further explaination?"
                                        showQuickSheet = true
                                    } label: {
                                        Image(systemName:"questionmark.circle.fill").foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                EventTips(eventTips: $eventTips)
                                HStack{
                                    Text("Event Offerings")
                                    Button {
                                        quickSheetText = "Will your team be offering anything to those that come to your event?"
                                        showQuickSheet = true
                                    } label: {
                                        Image(systemName:"questionmark.circle.fill").foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                EventOfferings(eventOfferings: $eventOfferings)
                                HStack{
                                    Text("Event Tags")
                                    Button {
                                        quickSheetText = "Choose 3 - 5 tags to filter your event from others."
                                        showQuickSheet = true
                                    } label: {
                                        Image(systemName:"questionmark.circle.fill").foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                EventTags(tags:$eventTags)
                            }
                        }
                       
                    }
                        
//                    }



                   

                        
//                        VStack{
//                            HStack{
//                                Text("Congrats on submitting an event!")
//                                    .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
//
//                                Spacer()
//                            }
//                            HStack{
//                                Text("Please give us sometime to verify the event. Feel free to check the pending events section to check if your event has been accepted.")
//                                    .font(.custom("Rubik Regular", size: 13)).foregroundColor(.white)
//
//                                Spacer()
//                            }
//                            .padding(.top,25)
//                        }
//                    }
//                    Spacer()
                    Button {
                        
                        submit()
          
                    } label: {
                        

                            Text("Done")
                                .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                            
                                .padding()
                                .padding(.horizontal,10)
                                .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                    }
                    .padding(.top,50)
//                    Spacer()

                    
                
                
            }
            Spacer()
        }
        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
        .onTapGesture { // add gesture to dismiss keyboard when clicked outside the keyboard view
                       UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                   }
        .padding(.top,30)
        .padding()
        .overlay(
            VStack{
                HStack{

                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"xmark").foregroundColor(.white)

                    }
                    Spacer()


                }
                Spacer()
            }
                .padding()
        )
        .background(
            BackgroundView()

           
        )
        .sheet(isPresented: $showQuickSheet, content: {
            QuickSheet(text: quickSheetText)
                .presentationDetents([.medium])
        })
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
                    let eventModel : HostEvent = HostEvent(hostId:groupId, hostName: hostName,eventId: randomId, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules, eventTips: eventTips, eventOfferings: eventOfferings, eventAddress: address, eventCityName: address, eventLongCoord: eventLongCoord, eventLatCoord: eventLatCoord, eventStartTime: eventStartTime, eventEndTime: eventEndTime, eventTags: eventTags, exclusivity: exclusivity, eventFee: eventFee, photoURL: "",  note: note, isActive: false, isRejected:false,isCompleted: false, eventMonth: eventMonth)
                    self.uploadingEvent = true
                    eventViewModel.submitHostEvent(uploadedImage: uploadedImage, groupId: groupId, event: eventModel) { result in
                        switch result{
                        case .success(()):
                            self.uploadingEvent = false
                            self.submittedEvent = true 
                            presentationMode.wrappedValue.dismiss()
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
