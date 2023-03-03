//
//  EventSubmitView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/16/22.
//

import SwiftUI

struct EventSubmitView: View {
    @EnvironmentObject private var eventViewModel : EventViewModel
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showSheet : Bool = false

    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(AppColor.lovolTan)
                  
              }
          }
      }
    
    var event: EventModel
    @State var image : UIImage = UIImage()
    @State private var initialImage : UIImage = UIImage()
    
    
//    var eventLabels : [String] = ["Name", "Description", "Rules", "Offering","Time","Price","Points"]
    var eventLabels : [String] = ["Name", "Description", "Rules", "Location", "Avg Cost","Time","Points"]
//    var eventContent : [String] = [event.eventName, event.eventDescription, event.eventLocation, event.eventDiscount, event.eventType, event.eventPoints]
    @State private var eventContent : [String] = ["","","","","","",""]
    
    @State private var showError : Bool = false
    @State private var showAlreadySubmitted : Bool = false
    @State private var showSubmission : Bool = false
    @State private var isLoading : Bool = false
    @State private var showGroupWarnign : Bool = false
    @State private var showJoinGroup : Bool = false
    
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                VStack{
                    ZStack{
                        
                        VStack{
                            
                            VStack{
                                ScrollView{
                                    ForEach(eventLabels.indices, id: \.self){ item in
                                        EventLabel(labelHeader: eventLabels[item], labelContent: eventContent[item])
                                        
                                    }
                                }
                            }
                            .frame(width:geo.size.width * 0.85, height:geo.size.height * 0.8)
                            .padding(.top,10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(#colorLiteral(red: 0.21176470816135406, green: 0.12156862765550613, blue: 0.40784314274787903, alpha: 0.4000000059604645))))
                            ZStack{
                                EventSubmit(image: image, initialImage: initialImage, showSheet: $showSheet)
                                    .frame(width:geo.size.width * 0.85)
                                

                                Button {
                                    submitPhoto()
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish)
                                            .frame(width: 70, height: 34)
                                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                                        Text("Submit")
                                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                                        
                                    }
                                }
                                .offset(y:35)
                            }
                            Spacer()
                            
                            
                        }
                        
                    }
                    
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .showLoading(isLoading)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Please upload a picture of your team before submitting.", isPresented: $showError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .alert("Event has already been completed.", isPresented: $showAlreadySubmitted, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .alert("You must be part of a team before submitting events.", isPresented: $showJoinGroup, actions: {
                Button("OK", role: .cancel, action: {
                    presentationMode.wrappedValue.dismiss()

                })
            })
            
            .onAppear(perform: fillEventContent)
        }


    }
    private func submitPhoto(){
        
       
        
        if image == initialImage {
            showError = true 
            return
        }
        profileViewModel.fetchUserWO { result in
            switch result {
            case .success(let user):
                let groupId = user.groupId ?? "" 
                if (groupId == ""){
                    showJoinGroup = true
                    return
                }
            case .failure(let error):
                print("error confirming in group \(error)")
                showError = true
            }
        }
        isLoading = true
//        eventViewModel.submitEvent(event: event, photo: image) { result in
//            switch result {
//            case .success(true):
//                showSubmission = true
//                presentationMode.wrappedValue.dismiss()
//
//            case .success(false):
//                showAlreadySubmitted = true
//                isLoading = false
//
//                presentationMode.wrappedValue.dismiss()
//
//            case .failure(let error):
//                print("error submitting event \(error)")
//                isLoading = false
//
//                showError = true
//                
//                
//            }
//        }
        
    }
    private func fillEventContent(){
        
        initialImage = image
        eventContent[0] = event.eventName
        eventContent[1] = event.eventDescription
        eventContent[2] = event.eventRules
//        eventContent[3] = event.eventLocation 
        eventContent[4] = String(event.eventAverageCost)
        eventContent[5] = String(event.eventTime)
        eventContent[6] = String(event.eventPoints)

        
    }
}

//struct EventSubmitView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventSubmitView(event: EventModel(id: "", eventName: "Name", eventDescription: "descripiont of the event it can be anything and anythingdescripiont of the event it can be anything and anythingdescripiont of the event it can be anything and anythingdescripiont of the event it can be anything and anythingdescripiont of the event it can be anything and anythingdescripiont of the event it can be anything and anything", eventRules: "these are the rules of the game and ", eventLocation: "None", eventAverageCost: 0, eventTime: 0, eventPoints: 0, eventType: "Home", eventMonth: "0", eventURL: ""))
//    }
//}
