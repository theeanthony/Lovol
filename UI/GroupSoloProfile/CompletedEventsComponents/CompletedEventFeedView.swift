//
//  CompletedEventFeedView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//

import SwiftUI

struct CompletedEventFeedView: View {
    
    @EnvironmentObject private var eventViewModel : EventViewModel
    let newColumns = [
       
        GridItem(.flexible()),
        GridItem(.flexible())
//        GridItem(.flexible())


     ]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.white)
                  
              }
          }
      } 
    @State private var readToEnd = false
        @State private var scrollViewHeight = CGFloat.infinity

        @Namespace private var scrollViewNameSpace
    
    @State private var loadingMore : Bool = false
    @State private var reachedEndOfScroll = false
    @State private var number : CGFloat = 0.0
    @State private var templatePhotos : [FetchedEvent] = []
    @State private var photos : [FetchedEvent] = []
    @State private var isPresent : Bool = false
    @State private var loading : Bool = true
    @State private var chosenEvent : String = ""
    let groupId : String
    var body: some View {
        GeometryReader{geo in

//            NavigationView{
                VStack{
                    if loading {
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(AppColor.lovolDark)
                    }else{
             
                        ExDivider(color:.white)
                        VStack{
                            ScrollView{
                                HStack{
                                    VStack(spacing:0){
                                        if !photos.isEmpty {
                                            
                                            ForEach(Array(stride(from: 0, to: self.photos.count, by: 3)), id: \.self) { index in
                                                HStack(spacing:0){
                                          
                                                    CompleteImagePost(completedEvent: photos[index], fromProfile: true)
                                                        .frame(width:geo.size.width * 0.315)
                                           
                                                    
                                                    if(index + 1 < photos.count){
                                             
                                                        
                                                        CompleteImagePost(completedEvent: photos[index+1], fromProfile: true)
                                                            .frame(width:geo.size.width * 0.315)//

                                                    }
                                                    
                                                    if(index + 2 < photos.count){
                                            
                                                        CompleteImagePost(completedEvent: photos[index+2], fromProfile: true)
                                                            .frame(width:geo.size.width * 0.315)

                                     
                                                        
                                                    }
                                                    Spacer()
                                                }
                                                .frame(width:geo.size.width * 0.99, height:geo.size.height * 0.19)
                                                .padding(.leading,10)
                                                
                                            }
                                        }else{
                                            Text("No Photos") .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                            
                                        }
                                        
                                    }
                                    .frame(width:geo.size.width * 0.99)
                                }
                                
                            }
                            .frame(width:geo.size.width, height:geo.size.height * 0.8)
                            
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onChange(of: proxy.size, perform: { newSize in
                                            let _ = print("ScrollView: ", newSize)
                                            scrollViewHeight = newSize.height
                                        })
                                }
                            )
                            .coordinateSpace(name: scrollViewNameSpace)
                        }.frame(height:geo.size.height * 0.85)
                    }
                }

//        }
        .onAppear(perform: onAppear)
        .frame(height:geo.size.height )

            
//        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(BackgroundView())

            
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    private func fill(chosen:String){
        self.chosenEvent = chosen
        print("URL first \(chosen)")
        isPresent = true
    }
    private func onAppear(){
        eventViewModel.fetchCompletedEvents(groupId: groupId) { result in
            switch result {
            case .success(let events):

                self.photos = events
                self.photos.sort {
                    $0.timeStamp > $1.timeStamp
                }
                self.templatePhotos = photos
                loading = false
            case .failure(let error):
                print("Error on fetching completed events for feed \(error)")
                return
            }
        }
    }
}

struct CompletedEventFeedView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedEventFeedView(groupId: "")
    }
}
