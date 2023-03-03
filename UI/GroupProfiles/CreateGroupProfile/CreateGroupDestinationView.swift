//
//  CreateGroupDestinationView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI
import Combine
import CoreLocation
import MapKit

struct CreateGroupDestinationView: View {
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
    @StateObject private var mapSearch = LocationService()
    var name: String
    var bio : String
    var college : String
   var occupation : String
    var pictures: [UIImage]
    var interests: [String]
    var leftAnswers : [String]
    var rightAnswers : [String]
    var ownQuestions : [String]
    var answers : [Int]
    var entity: Int
    var interactionPreference: Int
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
            GeometryReader{ geo in
                VStack{
                    //                List {
                    Text("Set your team's meeting point.")
                        .frame(width: geo.size.width * 0.7)
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                        .padding(.bottom,10)
                        .multilineTextAlignment(.center)
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
                            .frame(width:geo.size.width * 0.8)
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
                                                    Rectangle()
                                                        .frame(width:geo.size.width * 0.7, height:4)
                                                }
                                                .foregroundColor(AppColor.lovolDarkPurple)
                                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                                            } // End Label
                                        } // End ForEach
                                        
                                    }
                                    .padding(10)
                                } // End if
                                
                                .frame(width:geo.size.width * 0.8, height: geo.size.height * 0.2)
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
                            .foregroundColor(AppColor.lovolDarkPurple)                    .frame(width:geo.size.width * 0.8)
                            .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan))
                            .padding(.horizontal,20)
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                            .padding(.bottom,30)
                            
                            
                            
                        }
                        //                } // End List
                        Button(action:{
                        }, label: {
                            
                            NavigationLink(destination: CreateGroupDistanceView(name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, entity: entity, interactionPreference: interactionPreference, longitude: longitude, latitude:latitude, city:city)) {
                                Image(systemName:"arrow.right")
                                    .centerCropped()
                                    .frame(width: 50, height: 40)
                                    .foregroundColor(AppColor.lovolTan)
                            }
                            
                            
                            
                        })
                        //                    .padding(.top,50)
                        //                .disabled(checkIfName())
                    }
                    //                .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
                    //                .padding(20)
                    
                    
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Choose Location")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateGroupDestinationView_Previews: PreviewProvider {
    @State static var ownLeftExamples : [String] = []
    @State static var ownRightExamples : [String] = []
    @State static var makeOwnQuestion : [String] = []
    @State static var ownAnswers : [Int] = []
    static var previews: some View {
        CreateGroupDestinationView(name: "", bio: "", college: "", occupation: "", pictures: [], interests: [],leftAnswers: ownLeftExamples, rightAnswers: ownRightExamples, ownQuestions: makeOwnQuestion, answers: ownAnswers, entity: 0, interactionPreference: 0)
    }
}
