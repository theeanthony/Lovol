//
//  CollectionHeaderView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct CollectionHeaderView: View {
    let inGroupError : Bool
    let headers : [String] = ["Home", "Local", "Adult"]
    
    let headerPics : [String] = ["HouseFrame", "localPic", "adultFrame1"]
    
//    let events : [EventModel]
    
//    @State var editableEvents : [EventModel] = []
    
    @State private var loadedEvents : Bool = true
    
    let eventDictionary : [String:[String:EventModel]]
    
    let locationSet : Bool
    let long : Double
    let lat : Double
    
    @State private var chosenSetOfEvents : [EventModel] = []
    @State private var headerName : String = ""
    
//    eventDictionary[headers[header]]
    var body: some View {
        
        GeometryReader{geo in
            
//            ScrollView(.horizontal){
                HStack{
                    Spacer()
                    ForEach(headers.indices, id:\.self){ header in
                        Button {
                            
                        } label: {
                            NavigationLink(destination:IndividualLabelEventView(inGroupError:inGroupError,events: $chosenSetOfEvents , heder:headerName,locationSet:locationSet,long:long,lat:lat) ) {
                                //
                                VStack{
                                    Image(headerPics[header])
                                        .resizable()
                                        .centerCropped()
                                        .aspectRatio( contentMode: .fit)
                                        .frame(width:geo.size.width * 0.18, height:geo.size.width * 0.18)
                                        .padding(5 )
                                        .clipShape(Circle())
                                    
                                        .background(Circle().fill(.black.opacity(0.6)))
                                    Text(headers[header])
                                    
                                }
                            }
                            
                            Spacer()
                            
                            
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            // Handle tap gesture here
                            self.headerName = headers[header]
                            chosenSetOfEvents.removeAll()
                            let chosenDictionary = eventDictionary[headers[header]]
                            
                            for (_, value) in chosenDictionary! {
                                self.chosenSetOfEvents.append(value)
                            }
                            
                       
//                           = chosenDictionary![headers[header]]
                        })
                        .padding(.horizontal,10)
                        
                        
                    }



                }
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
//            }
            .padding(.vertical)
//            .scrollIndicators(.hidden)
//            .onAppear(perform:onAppear)
            
            
        }
    }
//    private func onAppear(){
//        self.editableEvents = events
//    }
}

//struct CollectionHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionHeaderView( eventDictionary: [:])
//    }
//}
