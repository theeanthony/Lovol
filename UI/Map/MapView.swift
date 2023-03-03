//
//  MapView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/16/22.
//

import SwiftUI
import CoreLocation

struct MapViews: View {
    @StateObject var locationViewModel = LocationViewModel()
    
    var body: some View {
        switch locationViewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(locationViewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            InfiniteScrollView()
//                .environmentObject(locationViewModel)
        default:
            Text("Unexpected status")
        }
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                locationViewModel.requestPermission()
            }, label: {
                Label("Click to Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track your location.")
                .foregroundColor(.gray)
                .font(.caption)
            VStack{
                


            }
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    
    var body: some View {
            VStack {
                HStack{
                    Text( "Latitude:")
                    Text(String(coordinate?.latitude ?? 0))
                }
                HStack{
                    Text( "Longitude:")
                    Text(String(coordinate?.longitude ?? 0))
                }
                HStack{
                    Text( "Altitude:")
                    Text(String(locationViewModel.lastSeenLocation?.altitude ?? 0))
                }
                   
                   
    
          
//                    leftText: "Speed",
//                    rightText: String(locationViewModel.lastSeenLocation?.speed ?? 0)
//                    leftText: "Country",
//                    rightText: locationViewModel.currentPlacemark?.country ?? ""
//                PairView(leftText: "City", rightText: locationViewModel.currentPlacemark?.administrativeArea ?? ""
//                )
            }
            .padding()
    }
    
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastSeenLocation?.coordinate
    }
}
//
//// MARK: View that shows map to users
//struct MapViews: View {
//
//  @State var locationManager = CLLocationManager()
//  @State var showMapAlert = false
//
//  var body: some View {
//    MapView(locationManager: $locationManager, showMapAlert: $showMapAlert)
//        .alert(isPresented: $showMapAlert) {
//          Alert(title: Text("Location access denied"),
//                message: Text("Your location is needed"),
//                primaryButton: .cancel(),
//                secondaryButton: .default(Text("Settings"),
//                                          action: { self.goToDeviceSettings() }))
//    }
//  }
//}
//
//extension MapViews {
//  ///Path to device settings if location is disabled
//  func goToDeviceSettings() {
//    guard let url = URL.init(string: UIApplication.openSettingsURLString) else { return }
//    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//  }
//}
//
struct MapViews_Previews: PreviewProvider {
    static var previews: some View {
        MapViews()
    }
}
struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView().environmentObject(LocationViewModel())
    }
}
