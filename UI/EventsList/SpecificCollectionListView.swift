//
//  SpecificCollectionListView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/4/23.
//

import Foundation
import SwiftUI

struct SpecificCollectionListView : View{
    
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
    @State private var events : [EventModel] = []
    @State private var searchFilter : String = ""
    let eventDictionary : [String:EventModel]
    @State private var specificEvents : [EventModel] = []
//    var searchResults: [EventModel] {
//        
//        if searchFilter.count == 0 {
//            return specificEvents
//        }
//
//        return specificEvents.filter {$0.eventDescription.lowercased().contains(searchFilter.lowercased())}
//
//
//    }
//    @Binding var loadedEvents : Bool
//    var collegeList : [String] {
//        var college : [String] = []
//        for index in collegeModel {
//            college.append(index.institution)
//        }
//        return college
//    }
    @State private var isPresented = false
    
    @State private var chosenEvent : EventModel = EventModel()
    
    let headerName : String

    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                
                VStack{
                    HStack{
//                        Image(systemName:"magnifyingglass")
                        SearchBar(text: $searchFilter)
                            .frame(height:geo.size.height * 0.05)
                        
                    }
//                    if loadedEvents {
//                        FilledLoadingView()
//                    }
//                    else{
                        ScrollView{
                            ForEach(specificEvents.indices, id:\.self){event in

                                    Button {
                                        fillEvent(event:specificEvents[event])
                                    } label: {
//                                        NavigationLink(destination: NewEventInformationView(event: specificEvents[event])) {
                                        NewEventsView(events: specificEvents[event])
                                            .frame(width:geo.size.width, height:geo.size.height * 0.35)
                                   

                                    }.fullScreenCover(isPresented: $isPresented) {
//                                        NewEventInformationView(event:$chosenEvent, inGroupError: <#Bool#>)
                                    }
                          

                              
                            }
                        }
                        .frame(height:geo.size.height * 0.9)
//                    }
         
                }
                .frame(height:geo.size.height )
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Text(headerName)
                        .font(.custom("Rubik Regular", size: 20)).foregroundColor(.white)
                    
                }
            }
            .onAppear(perform:onAppear)
        }
        
    }
    private func fillEvent(event:EventModel){
        self.chosenEvent = event
        isPresented.toggle()
        return
    }
    private func onAppear(){
        for (_,value) in eventDictionary {
            
            specificEvents.append(value)
            
        }
    }
    
    
}

//struct SpecificCollectionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SpecificCollectionListView()
//    }
//}
