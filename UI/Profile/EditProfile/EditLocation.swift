//
//  EditLocation.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit

struct EditLocation: View {
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
    @Binding var long : Double
    @Binding var lat : Double
    @Binding var locationCity : String
    
    
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
        NavigationStack{
            VStack{
                Section {
                    HStack{
                        TextField("", text: $mapSearch.searchTerm).placeholder(when: mapSearch.searchTerm.isEmpty) {
                            Text("Address")
//                                    .padding(10)
                         
                    }
//                            .padding(.leading,10)
                        .padding(10)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing,10)
      
                    }
                    .foregroundColor(AppColor.lovolDarkPurple)
                    .frame(width:280)
                    .background(RoundedRectangle(cornerRadius:20).fill((Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))))
                    .padding(.horizontal,20)
                    .padding(.bottom,10)
                    .padding(.top,5)
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)

                    
                    
                    // Show auto-complete results
                    if address != mapSearch.searchTerm && isFocused == false {
                        ScrollView{
                            VStack{
                                ForEach(mapSearch.locationResults, id: \.self) { location in
                                    Button {
                                        reverseGeo(location: location)
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(location.title)
                                            Text(location.subtitle)
                                                .font(.system(.caption))
                                        }
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                                    } // End Label
                                } // End ForEach
                                
                            }
                            .padding(10)
                        } // End if
                        
                        .frame(width: 280, height: 100)
                        .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
                        .padding(.bottom,10)
                   

                    }
                    HStack{
                        Image(systemName: "house.fill")
                            .padding(.vertical,10)
                            .padding(.leading,10)
                        if (!address.isEmpty){
                            Text("\(address) \(city), \(state), \(zip)")
                            
                        }
                        Spacer()
                       
                    }
                    .foregroundColor(AppColor.lovolDarkPurple)                      .frame(width:280)
                    .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan))
                    .padding(.horizontal,20)
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                    .padding(.bottom,30)

   
                    
                }
                Button {
                    done()
                } label: {
                    Text("done")
                }
                
                
                
                
                
                
                
            }
            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
            
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Text("Edit Location")
                        .foregroundColor(AppColor.lovolTan)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func done(){
        
        self.locationCity = city
        self.long = longitude
        self.lat = latitude
        presentationMode.wrappedValue.dismiss()
        
    }
}

//struct EditLocation_Previews: PreviewProvider {
//    @State static var locationCoords : [Double] = [1,2]
//    @State static var locationCity : String = "SanJose"
//    static var previews: some View {
//        EditLocation(locationCoords:$locationCoords, locationCity: $locationCity)
//    }
//}
