//
//  EventDestination.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit
struct EventDestination: View {
    
    @Binding var cityName : String
    @Binding var long : Double
    @Binding var lat : Double
    @Binding var eventAddress : String
    @StateObject private var mapSearch = LocationService()

    func reverseGeo(location: MKLocalSearchCompletion) {
           let searchRequest = MKLocalSearch.Request(completion: location)
           let search = MKLocalSearch(request: searchRequest)
           var coordinateK : CLLocationCoordinate2D?
           search.start { (response, error) in
           if error == nil, let coordinate = response?.mapItems.first?.placemark.coordinate {
               coordinateK = coordinate
           }

           if let c = coordinateK {
               let location = CLLocation(latitude: c.latitude, longitude: c.longitude)
               CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                   longitude = c.longitude
                   latitude = c.latitude
               guard let placemark = placemarks?.first else {
                   let errorString = error?.localizedDescription ?? "Unexpected Error"
                   print("Unable to reverse geocode the given location. Error: \(errorString)")
                   return
               }

               let reversedGeoLocation = ReversedGeoLocation(with: placemark)

               address = "\(reversedGeoLocation.streetNumber) \(reversedGeoLocation.streetName)"
               city = "\(reversedGeoLocation.city)"
               state = "\(reversedGeoLocation.state)"
               zip = "\(reversedGeoLocation.zipCode)"
               mapSearch.searchTerm = address
               isFocused = false

                   
                   self.cityName = city
                   self.long = longitude
                   self.lat = latitude
                   self.eventAddress = address + ", " + city + state 
                   }
               }
           }
       }

       // Form Variables

       @FocusState private var isFocused: Bool

       @State private var btnHover = false
       @State private var isBtnActive = false
    @State private var longitude = 0.0
    @State private var latitude = 0.0
       @State private var address = ""
       @State private var city = ""
       @State private var state = ""
       @State private var zip = ""
    var body: some View {

        VStack{
            
            
            Section {
                HStack{
                    Image(systemName: "magnifyingglass")
                        .padding(.leading,15)
                    TextField("", text: $mapSearch.searchTerm).placeholder(when: mapSearch.searchTerm.isEmpty) {
                        Text("Address").foregroundColor(.white).opacity(0.6)
                        //                                    .padding(10)
                        
                    }
                    //                            .padding(.leading,10)
                    .padding()
                    Spacer()
                
                    
                }
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.6))
                .padding()

//                            .padding(.horizontal,20)
//                            .padding(.bottom,10)
//                            .padding(.top,5)
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                
                
                
                // Show auto-complete results
                if address != mapSearch.searchTerm && isFocused == false {
                    ScrollView{
                        VStack{
                            ForEach(mapSearch.locationResults, id: \.self) { location in
                                Button {
                                    reverseGeo(location: location)
                                    setAddress()

//                                    self.enteredValidAddress = true
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(location.title)
                                        Text(location.subtitle)
                                            .font(.system(.caption))
                                        ExDivider(color:.white.opacity(0.5))
                                    }
                                    .foregroundColor(.white)
                                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                                } // End Label
                            } // End ForEach
                            
                        }
                        .padding(10)
                    } // End if
                    .padding(.bottom,10)
                    
                    
                }
                VStack{
                    HStack{
               
                        if (!address.isEmpty){
                            Image(systemName: "house.fill")
                                .padding(.vertical,10)
                                .padding(.leading,10)
                            Text("\(address) \(city), \(state), \(zip)")
                        }
                        Spacer()
                        
                    }

                }
  
              
                .padding(.horizontal,20)
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                .padding(.bottom,30)
                
                
                
            } // End Section
            //                } // End List

            //                    .padding(.top,50)
            //                .disabled(checkIfName())
        }
    }
    private func setAddress(){

        
        self.cityName = city
        self.long = longitude
        self.lat = latitude
        self.eventAddress = address + ", " + city + state 
        
    }
}

//struct EventDestination_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDestination()
//    }
//}
