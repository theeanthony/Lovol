//
//  CollectionHeaderView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct CollectionHeaderView: View {
    
    let headers : [String] = ["Home", "Local", "Virtual", "21+", "Couples", "After Dark"]
    
    let headerPics : [String] = ["HouseFrame", "localPic", "virtualReality", "adultFrame1", "CouplesFrame1", "AfterDarkFrame"]
    
//    let events : [EventModel]
    
//    @State var editableEvents : [EventModel] = []
    
    @State private var loadedEvents : Bool = true
    
    let eventDictionary : [String:[String:EventModel]]
    
    let locationSet : Bool
    let long : Double
    let lat : Double 
    
    
    var body: some View {
        
        GeometryReader{geo in
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(headers.indices, id:\.self){ header in
                        Button {
                            
                        } label: {
                            NavigationLink(destination:IndividualLabelEventView(eventDictionary: eventDictionary[headers[header]] ?? [:], heder: headers[header], locationSet:locationSet,long:long,lat:lat) ) {
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
                            
                            
                        }
                        .padding(.horizontal,10)
                        
                        
                    }



                }
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
            }
            .padding(.vertical)
            .scrollIndicators(.hidden)
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
