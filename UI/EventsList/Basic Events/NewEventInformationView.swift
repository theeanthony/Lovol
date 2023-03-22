//
//  NewEventInformationView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
// 

import SwiftUI

struct NewEventInformationView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var eventViewModel : EventViewModel
    
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    let inGroupError: Bool
     @Binding var event : EventModel
    
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

    @State private var reviewSheet : Bool = false
    @State private var dismissed : Bool = false
    
    @State private var useDoubler : Bool = false
    
    @State private var totalPointsEarned: Int = 0
    
    @State private var isCelebrationPresent : Bool = false
    
    @State private var submitPhotoButtonPressed : Bool = false
     
  @State private var takenPhotos: [UIImage] = []
    
    @State private var cannotSubmitError : Bool = false
    
    @State private var cannotSubmit : Bool = true
    
    @State private var showInGroupError : Bool = false

    
    var body: some View {
       
        
        GeometryReader { geo in

            VStack(spacing:0){
                ZStack{
                    ScrollView{
                        VStack{
                            NewEventDescriptionView(pic: event.eventURL)
                                .frame(height:geo.size.height * 0.3)
                            
                            VStack{
                                HStack{
                                    HeaderView(inGroupError:inGroupError,name: event.eventName,event:$event)
                                    
                                    
                                    
                                }
                                
                                
                                Section(header:ListHeader(text:"Description")){
                                    BodyView(description: event.eventDescription, tanOrNo: true)
//                                        .frame(maxWidth: geo.size.width * 9, minHeight:100)
                                }
                                .frame(width:geo.size.width * 0.95)
         
                                    Section(header:ListHeader(text: "Rules")){
                                        BodyView(description: event.eventRules, tanOrNo: false)
                                        //                                        .frame(maxWidth: geo.size.width * 9)
                                            .padding(.vertical,10)
                                    }
                                    .frame(maxWidth: geo.size.width * 0.95)
//                                }
                                
                                
                                //                                .frame(width:geo.size.width)
                                
                                if !event.eventTips.isEmpty {
                                    Section(header:ListHeader(text: "Tips")){
                                        BodyView(description: event.eventTips, tanOrNo: true)
                                        //                                        .frame(maxWidth: geo.size.width * 9, minHeight:100)
                                            .padding(.vertical,10)
                                    }
                                    .frame(maxWidth: geo.size.width * 0.95)
                                }
                                
                                //                                .frame(width:geo.size.width)
                                
                                
                                BigLabelView(time: event.eventTime, points: event.eventPoints)
                                    .frame(width:geo.size.width, height:geo.size.height * 0.3)
                                    .padding(.vertical,10)
                                
                                if !event.eventOfferings.isEmpty{
                                    Section(header:ListHeader(text: "Offerings")){
                                        BodyView(description: event.eventOfferings, tanOrNo: true)
//                                            .frame(maxWidth: geo.size.width * 9, minHeight:100)
                                            .padding(.vertical,10)
                                    }
                                    .frame(maxWidth: geo.size.width * 0.95)
                                }
                                
                                Group{
                                    Section(header:ListHeader(text: "Tags")){
                                        TagsView(tags: event.eventTags)
                                        
                                    }
                                    .frame(maxWidth: geo.size.width * 0.95)
                                    
                                }
                                .padding(.vertical,10)
                                .padding(.bottom,15)
                                
                            }
                            
                        }
                        
                    }
                    .frame(height:geo.size.height )
//                    if isCelebrationPresent{
//                        CelebrationView(isCelebrationPresent:$isCelebrationPresent,totalPoints:totalPointsEarned)
//
//                    }
                    
                }
                
                
                if event.isTempEvent && event.endingTime != nil && event.endingTime! < Date(){
                    
                    
                }
                else{
                    Button {
                        if inGroupError{
                            self.showInGroupError = true
                        }
                        else if cannotSubmit{
                            self.alreadySubmittedEvent = true
                        }else{
                            submitPhotoButtonPressed = true

                        }

                    } label: {
                        VStack{
                            Rectangle().fill(AppColor.lovolPinkish)
                                .frame(width:geo.size.width , height:80)
                                .overlay(
                                    VStack{
                                        Spacer()
                                        
                                        Text( uploadedImage == initialImage ? "Take Photo" : "Submit Photo") .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                                        Spacer()
                                    }
                                    
                                )
                        }

                    }
           
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
//                                    .resizable()
//                                    .frame(width:geo.size.width * 0.07 , height:geo.size.width * 0.07)
//                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(AppColor.lovolDark)).opacity(0.6)
                                
                            }
//                            .padding()
//                            .background(Circle().fill(AppColor.lovolDark)).opacity(0.6)
                        }
                        Spacer()

                    }
                    .padding(.top)
                    .padding(.top)
                    Spacer()
//                    if uploadedImage != initialImage {
//                            HStack{
////                                VStack{
//                                    Button(action: {
//                                        showImagePicker.toggle()
//                                    }, label: {
//                                        Image(uiImage: uploadedImage)
//                                            .resizable()
//                                            .centerCropped()
//                                            .frame(width: geo.size.width * 0.3, height: geo.size.width * 0.3)
//                                            .aspectRatio(contentMode: .fill)
//                                            .clipShape(Circle())
//                                            .overlay(
//                                                Circle().stroke(.black,lineWidth:2)
//                                            )
//                                    })
//                                VStack{
//                                    HStack{
//                                        Circle().fill(AppColor.strongRed).frame(width:20,height:20)
//                                            .overlay(Text("2x")
//                                                .font(.custom("Rubik Bold", size: 10)).foregroundColor(.white)
//)
//                                        Text("Use 1")
//                                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
//
//                                        Toggle("", isOn: $useDoubler)
//                                            .toggleStyle(SwitchToggleStyle())
//                                            .tint(AppColor.lovolPinkish)
//                                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
//                                    }
//                                    HStack{
//                                        Toggle("Global Feed", isOn: $isGlobal)
//                                            .toggleStyle(SwitchToggleStyle())
//                                            .tint(AppColor.lovolPinkish)
//                                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
//                                    }
//
//                                }
//                                .padding(10)
//                                .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolDarkerPurpleBackground))
//                                Spacer()
//
//                            }
//                            .padding(.bottom,50)
////                                                         Spacer()
//
//                    }
                }.padding()
//                    .frame(width: geo.size.width * 0.8, height: geo.size.height)

            
            )


            .frame(width:geo.size.width, height:geo.size.height)
    
            .background(BackgroundView()
            )
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
                .alert("This event has already been completed.", isPresented: $alreadySubmittedEvent, actions: {
                    Button("OK", role: .cancel, action: {
    
                    })
                })
                .alert("There has been an error uploading your event. Try again?", isPresented: $uploadError, actions: {
                    Button("OK", role: .cancel, action: {
    
                    })
                })
                .alert("There is a network issue validating if you have completed this event. Please try to submit later if you have not already.", isPresented: $cannotSubmitError, actions: {
                    Button("OK", role: .cancel, action: {
    
                    })
                })
                .alert("Join or create a team to submit an event.", isPresented: $showInGroupError, actions: {
                    Button("OK", role: .cancel, action: {
    
                    })
                })
//                .sheet(isPresented: $uploadPictureSheet){
//                    ContentTypeView(onContentTypeSelected: { contentType in
//                        switch contentType{
//                        case .permissionDenied:
//                            showPermissionDenied.toggle()
//                            return
//                        case .contentType(let sourceType):
//                            self.selectedContentType = sourceType
//                            showImagePicker.toggle()
//                            return
//                        }
//                    })
//                }
                .onChange(of: dismissed, perform: { newvalue in
                    if dismissed{
                        presentationMode.wrappedValue.dismiss()
                    }
                })
                .sheet(isPresented: $showImagePicker){
                    ImagePicker(sourceType: selectedContentType, selectedImage: $uploadedImage)
                }
                .sheet(isPresented: $reviewSheet){
                    EventFeedBackSheet(points:$totalPointsEarned, event:event, dismissed:$dismissed)
                        .presentationDetents([ .medium])

                }
                .fullScreenCover(isPresented: $submitPhotoButtonPressed, content: {
//                    CapturePhotosView(event:event)
                    CapturePhotosView( totalPointsEarned: $totalPointsEarned, reviewSheet: $reviewSheet, isCelebrationPresent: $isCelebrationPresent, event: event)

                })
//                .fullScreenCover(isPresented: $isCelebrationPresent, content: {
//                })
                .onAppear(perform: onAppear)
                .showLoading(pictureSubmitted)
        }
        


    }
    private func checkIfCompleted(){
        
    }

    private func onAppear(){
        initialImage = uploadedImage
        eventViewModel.checkIfEventAlreadyDone(event: event) { result in
            switch result{
            case .success(let canISubmit):
                
                if !canISubmit {
//                    alreadySubmittedEvent = true
                }else{
                    self.cannotSubmit = false
                }
            case .failure(let error):
                print("error retrieving necessary information")
                
                self.cannotSubmitError = true
            }
        }
    }

}
////
//struct NewEventInformationView_Previews: PreviewProvider {
//   @State static var event : EventModel = EventModel(id: "", eventName: "Anthonys event", eventDescription: "this is the description to the event please pay attention", eventRules: "these are the rules to the vent please follow them ", eventAverageCost: 30, eventTime: 30, eventPoints: 30, eventType: "Home", eventMonth: "0", eventURL: "https://firebasestorage.googleapis.com/v0/b/mygameshow-63e93.appspot.com/o/event%2FeventWatchMovie.jpeg?alt=media&token=fabf2876-4915-49a4-9c19-9ca7d5ab5e31", eventOfferings: "These are the offerings for the event", eventTips: "THese are the tips for the event", eventTags: ["Home","Physical","Romance"], isTemp: false, eventReviewPercentage: 10, eventTotalReviews: 2, eventLocation: false, long: 0, lat: 0, distance: 0)
//    static var previews: some View {
//        NewEventInformationView(event:$event)
//    }
//}



struct BodyView: View{
    let description : String
    let tanOrNo : Bool
    var body: some View{
//        GeometryReader{geo in
            HStack{
                Spacer()
                VStack{
                    Text(description)
                    
                        .font(.custom("Rubik Regular", size: 14))
                    
//                        .frame(maxWidth:geo.size.width * 0.85, minHeight: 50)
                }
//                .frame(maxWidth:geo.size.width * 0.9, minHeight: 50)
                .padding()
                .background(tanOrNo ? RoundedRectangle(cornerRadius: 10).fill(.clear) : RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
                .foregroundColor(.white)
                Spacer()

            }

   
//        }
    }
}
struct BigLabelView: View{
    
    let time: Int
    let points : Int
    
    var body: some View{
        GeometryReader{ geo in
            
            HStack{
                Spacer()
                VStack{
                    Text("Lovol Bits").font(.custom("Rubik Regular", size: 14)).foregroundColor(.clear)

                    Text("\(points)").font(.custom("Rubik Regular", size: 82))
                    Text("Lovol Bits").font(.custom("Rubik Regular", size: 14))
                }
                .padding(.vertical,10)
                .frame(width: geo.size.width * 0.45)
                .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
                VStack{
                    Text("Avg Time").font(.custom("Rubik Regular", size: 14))
                    Text("\(time)").font(.custom("Rubik Regular", size: 82))
                    Text("Minutes").font(.custom("Rubik Regular", size: 14))
                }
                .padding(.vertical,10)

                .frame(width: geo.size.width * 0.45)

                .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
                Spacer()
                    
                
            }


            
            .foregroundColor(.white)
        }
        
    }
    
    
}
struct TagsView: View{
    let tags : [String]
    let newColumns = [ 
       
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 100, maximum: 300))


     ]
    var body: some View {
        
        LazyVGrid(columns: newColumns, spacing: 15){
            ForEach(tags.indices, id: \.self) { item in
          
                    Text(tags[item])
                    .font(.custom("Rubik", size: 14)).foregroundColor(.white)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
     
                
            }
            
        }
    }
}

//struct TagsView_Previews: PreviewProvider {
//    static var tags: [String] = ["fun","hello","no","fun","hello","no"]
//    static var previews: some View {
//        TagsView(tags: tags)
//    }
//}
