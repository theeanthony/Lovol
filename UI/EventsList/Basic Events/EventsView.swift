//
//  EventsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/16/22.
//

import SwiftUI

struct EventsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
    
    let templateEvents : [EventModel]
    @State var events : [EventModel]
    
    @State var selectedPrice : String = ""
    @State var selectedTime: String = ""
    
    @State var filtersLoading : Bool = false 
    
    var body: some View {
//        NavigationStack{
            GeometryReader { geo in
                VStack{

                        VStack{
                            
                            EventFilterView(selectedPrice: $selectedPrice, selectedTime: $selectedTime, templateEvents: templateEvents, events: $events, loading: $filtersLoading)
                                .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.14)
                            
                            
                            ScrollView{
                                
                                if events.isEmpty {
                                    Text("No Events Available")
                                        .font(.custom("Rubik Regular", size: 24)).foregroundColor(AppColor.lovolTan)
                                    
                                }
                                //                            else if filtersLoading{
                                //                                ProgressView()
                                //                            }
                                else{
                                    ForEach(events.indices, id: \.self){ index in
                                        if events[index].eventCompleted ?? false {
                                            EventsButtonView(event: events[index] )
                                                .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.15)

                                        }else{
                                            NavigationLink(destination: EventSubmitView(event: events[index])) {
                                                EventsButtonView(event: events[index] )
                                                    .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.15)

                                            }
                                        }
                                        
                                        
                                    }
                                }
                                
                                
                                
                            }
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.7)
                        }
                        .frame(width: geo.size.width * 0.95, height: geo.size.height )

                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(#colorLiteral(red: 0.21176470816135406, green: 0.12156862765550613, blue: 0.40784314274787903, alpha: 0.4000000059604645)))
                            .frame(width: geo.size.width * 0.83, height: geo.size.height * 0.88)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
//

                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
           
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
//        }
    }



    
}

struct EventsView_Previews: PreviewProvider {
    static let selectedPrice : String = ""
    static let selectedTime : String = ""
    
    @State static var events : [EventModel] = []
    static var previews: some View {
        EventsView(templateEvents: events, events: events, selectedPrice: selectedPrice, selectedTime: selectedTime)
    }
}
