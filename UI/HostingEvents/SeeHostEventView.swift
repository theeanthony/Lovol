//
//  SeeHostEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/27/23.
//

import SwiftUI

struct SeeHostEventView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var eventViewModel : EventViewModel
    
    @Binding var id : String
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
                                    HeaderView(name: event.eventName,event:event)
 
                                    
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


        private func onAppear(){
        
        print("id of fetching \(id)")
        eventViewModel.fetchSingleHostEvent(id: id) { result in
            
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
//                    private func saveEvent (event: EventModel){
//
////
//                    }

}

