//
//  NewEventInformationView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct EventDescriptionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var eventViewModel : EventViewModel
    
    let id : String
     @State private var event : EventModel = EventModel()
    
    @State private var initialImage : UIImage = UIImage()
    @State private var uploadedImage : UIImage = UIImage()
    
    @State private var joinGroupFirstError : Bool = false
    @State private var eventSetAlreadyError : Bool = false
    @State private var showDownloadError : Bool = false
    
    @State private var alreadySubmittedEvent : Bool = false
    
    @State private var uploadError : Bool = false
    
    @State private var pictureSubmitted : Bool = false
    
    @State private var eventSaved : Bool = false
    @State private var isGlobal : Bool = false

    @State private var uploadPictureSheet : Bool = false
    @State private var showPermissionDenied : Bool = false
    @State private var showImagePicker : Bool = false
    @State private var selectedContentType: UIImagePickerController.SourceType =
        .camera
    @State private var showError : Bool = false

    @State private var reviewSheet : Bool = false
    @State private var dismissed : Bool = false
    
    @State private var loadingEvent : Bool = true
    var body: some View {
      
        
        GeometryReader { geo in
            VStack(spacing:0){
                if loadingEvent {
                    ProgressView()
                }else{

                    
                    ScrollView{
                        VStack{
                            NewEventDescriptionView(pic: event.eventURL)
                                .frame(height:geo.size.height * 0.3)
                            
                            VStack{
                                HStack{
                                    HeaderView(inGroupError: false, name: event.eventName,event:$event)
 
                                    
                                }
                      
                                
                                Section(header:ListHeader(text:"Description")){
                                    BodyView(description: event.eventDescription, tanOrNo: true)
                                        .frame(maxWidth: geo.size.width * 9, minHeight:100, maxHeight: 500)
                                }
                                .frame(width:geo.size.width * 0.9)
                     
                      
                                Section(header:ListHeader(text: "Rules")){
                                    BodyView(description: event.eventRules, tanOrNo: false)
                                        .frame(maxWidth: geo.size.width * 9, minHeight:100, maxHeight: 500)
                                        .padding(.vertical,10)
                                }
                                .frame(maxWidth: geo.size.width * 0.95)
                                
                                
                                //                                .frame(width:geo.size.width)
                         
                                
                                Section(header:ListHeader(text: "Tips")){
                                    BodyView(description: event.eventTips, tanOrNo: true)
                                        .frame(maxWidth: geo.size.width * 9, minHeight:100, maxHeight: 500)
                                        .padding(.vertical,10)
                                }
                                .frame(maxWidth: geo.size.width * 0.95)

                                //                                .frame(width:geo.size.width)
                        
                                
                                BigLabelView(time: event.eventTime, points: event.eventPoints)
                                    .frame(width:geo.size.width, height:geo.size.height * 0.3)
                                    .padding(.vertical,10)
                                
                                if !event.eventOfferings.isEmpty{
                                    Section(header:ListHeader(text: "Offerings")){
                                        BodyView(description: event.eventOfferings, tanOrNo: true)
                                            .frame(maxWidth: geo.size.width * 9, minHeight:100, maxHeight: 500)
                                            .padding(.vertical,10)
                                    }
                                    .frame(maxWidth: geo.size.width * 0.95)
                                }
                           

                                //                                .frame(width:geo.size.width)
                         
                                
                                Group{
                                    Section(header:ListHeader(text: "Tags")){
                                        TagsView(tags: event.eventTags)

                                    }
                                    .frame(maxWidth: geo.size.width * 0.95)

                                }
                                //                                .frame(width:geo.size.width)
                                .padding(.vertical,10)
                                .padding(.bottom,15)
                                
                            }
                            
                        }
                        
                    }
                    .frame(height:geo.size.height )
                    
                }
            }
                .overlay(
                    VStack{
                        HStack{
                            Button {
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "xmark") // set image here
//                                        .resizable()
//                                        .frame(width:geo.size.width * 0.07 , height:geo.size.width * 0.07)
//                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(AppColor.lovolDark)).opacity(0.6)
                                    
                                }
                                .padding(.leading,15)

                            }
                            Spacer()

                        }
                        Spacer()

                    }
//                        .frame(width: geo.size.width * 0.8, height: geo.size.height)

                
                )

//                .toolbar(.hidden,for:.tabBar)
                .frame(width:geo.size.width, height:geo.size.height)
                .background(BackgroundView())

  
            }
                         .alert("You must be in a group to save this event", isPresented: $joinGroupFirstError, actions: {
                    Button("OK", role: .cancel, action: {
    
                    })
                })
                .alert("This event has already been saved.", isPresented: $eventSetAlreadyError, actions: {
                    Button("OK", role: .cancel, action: {
    
                    })
                })
                .alert("There has been an error.", isPresented: $showDownloadError, actions: {
                    Button("OK", role: .cancel, action: {
    
                    })
                })

                .alert("There has been an error retrieving the event try again later.", isPresented: $showError, actions: {
                    Button("OK", role: .cancel, action: {
    
                    })
                })

                .onChange(of: dismissed, perform: { newvalue in
                    if dismissed{
                        presentationMode.wrappedValue.dismiss()
                    }
                })

                .onAppear(perform: onAppear)
        }
        


    
    private func submitPhoto(){
//        
//        pictureSubmitted = true
//        if uploadedImage == initialImage {
//            return
//        }
//        eventViewModel.submitEvent(useMultiplier: , isGlobal:isGlobal,event: event, photo: uploadedImage) { result in
//            switch result {
//            case .success(false):
//                
//                alreadySubmittedEvent = true
//                pictureSubmitted = false
//            case .success(true):
//                pictureSubmitted = false
//                reviewSheet = true
////                dismiss()
//            case .failure(let error):
//                pictureSubmitted = false
//                print("error submitting photo for event \(error)")
//
//                uploadError = true
//                return
//            }
//        }
        
    }
    private func onAppear(){
        
        print("id of fetching \(id)")
        eventViewModel.fetchSingleEvent(id: id) { result in
            
            switch result {
            case .success(let events):
                print("fetched")
                self.event = events
                self.loadingEvent = false
                return
            case .failure(let error):
                print("error retriving event \(error)")
                showError = true
                self.loadingEvent = false 
                return
            }
        }
    }
                    private func saveEvent (event: EventModel){
                        
//      
                    }

}
////
//struct NewEventInformationView_Previews: PreviewProvider {
//   @State static var event : EventModel = EventModel(id: "", eventName: "Anthonys event", eventDescription: "this is the description to the event please pay attention", eventRules: "these are the rules to the vent please follow them ", eventAverageCost: 30, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: "https://firebasestorage.googleapis.com/v0/b/mygameshow-63e93.appspot.com/o/event%2FeventWatchMovie.jpeg?alt=media&token=fabf2876-4915-49a4-9c19-9ca7d5ab5e31", eventOfferings: "These are the offerings for the event", eventTips: "THese are the tips for the event", eventTags: ["Home","Physical","Romance"], isTemp: false, eventReviewPercentage: 10, eventTotalReviews: 2, eventLocation: false, long: 0, lat: 0, distance: 0)
//    static var previews: some View {
//        NewEventInformationView(event:$event)
//    }
//}



