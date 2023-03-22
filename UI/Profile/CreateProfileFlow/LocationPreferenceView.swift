//
//  LocationPreferenceView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/2/22.
//
 
import SwiftUI
import Combine
import CoreLocation
import MapKit

struct LocationPreferenceView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var profileViewModel : ProfilesViewModel
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
    
    @State private var enteredValidAddress : Bool = false
    
    @State private var error : Bool = false
    
    @State private var notInGroup : Bool = false

    @State private var loading : Bool = false
    
    @Binding var updatedLocation : Bool
    var body: some View {
            GeometryReader{ geo in
                VStack{
                    //                List {
                    HStack{
                        Text("Search an Address")
                            .frame(width: geo.size.width * 0.9,alignment: .leadingFirstTextBaseline)
                            .font(.custom("Rubik Regular", size: 22)).foregroundColor(.white)
                            .padding(.bottom,10)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding(.leading,10)
                    .padding(.top,40)
                    VStack{
                        
                        
                        Section {
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .padding(.trailing,10)
                                TextField("", text: $mapSearch.searchTerm).placeholder(when: mapSearch.searchTerm.isEmpty) {
                                    Text("Address").foregroundColor(.white)
                                    //                                    .padding(10)
                                    
                                }
                                //                            .padding(.leading,10)
                                .padding(10)
                                Spacer()
                            
                                
                            }
                            .padding(10)
                            .foregroundColor(.white)
                            .frame(width:geo.size.width * 0.8)
                            .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid).opacity(0.3))
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
                                                self.enteredValidAddress = true
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
                                .frame(height:geo.size.height * 0.4)
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
                                if !address.isEmpty {
                                    Button {
                                        setAddress()
                                    } label: {
                                        Text("Save Address")
                                            .padding()
                                            .frame(width:geo.size.width * 0.7)
                                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolPinkish))
                                    }

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
                    //                .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
                    //                .padding(20)
                    
                }
//                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                BackgroundView()
            )
            .ignoresSafeArea(.keyboard)
            .showLoading(loading)
            .alert("Join or create a team to save your address and to see events happening near you.", isPresented: $notInGroup, actions: {
                Button("OK", role: .cancel, action: {

                })
            })

    }
    private func setAddress(){
            
        loading = true
        profileViewModel.saveAddress(address:address,long:longitude,lat:latitude,city:city) { result in
            switch result{
            case .success(true):
                self.updatedLocation = true
                loading = true
                presentationMode.wrappedValue.dismiss()
            case .success(false):
                
                self.notInGroup = true
                loading = false

                return
                
            case .failure(let error):
                print("error saving address \(error)")
                self.error = true
                loading = false

                return
            }
        }
        
    }
}
//
//struct LocationPreferenceView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationPreferenceView()
//    }
//}
