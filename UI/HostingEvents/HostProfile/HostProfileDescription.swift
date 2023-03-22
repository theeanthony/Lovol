//
//  HostProfileDescription.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/15/23.
//

import SwiftUI

struct HostProfileDescription: View {
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let inGroupError:Bool
    @EnvironmentObject private var eventViewModel : EventViewModel
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    let hostId : String
    let hostName : String
    @State private var groupId:String = ""
    
    @State private var  locationSet : Bool = false
    @State private var  long : Double = 0
    @State private var  lat : Double = 0
    
    @State private var currentDate : Date = Date()
    
    @State private var loadingHost : Bool = true
    
    @State private var errorFetching : Bool = false
    
    @State private var hostInformation : HostInformation = HostInformation(id: "", name: "", description: "", pastEvents: [], upcomingEvents: [])
    @State private var loadedPic : Bool = false
    @State private var followers : [String] = []
    
    @State private var errorFollowing : Bool = false 
    @State private var following : Bool = false
    
    @State private var mainPic : UIImage = UIImage()
    var body: some View {
        GeometryReader{geo in
            VStack{
                if loadingHost{
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
                    ScrollView{
                        VStack{
                            if loadedPic {
                                Image(uiImage: mainPic)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height:geo.size.height * 0.3)
                                    .padding(.bottom, 150) // Add some padding below the image

                                
                            }else{
                                
                            }
                            VStack(spacing:16){
                                HStack{
                                    Text(hostInformation.name)
                                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                                        .frame(height:geo.size.height * 0.05)
                                    Spacer()
                                    Button {
                                        followHost()
                                    } label: {
                                        Text(following ? "Following" : "Follow")
                                            .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)

                                            .padding(5)
                                            .background(RoundedRectangle(cornerRadius:30).fill(following ? AppColor.lovolPinkish : AppColor.lovolPinkish.opacity(0.4)))
                                    }

                                }
                                .frame(width:geo.size.width * 0.93)

                                HStack{
                                    Text(hostInformation.description)
                                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
//                                        .frame(height:geo.size.height * 0.1)

                                    Spacer()
                                    
                                }
                                .frame(width:geo.size.width * 0.93)

                                ExDivider(color: .white)
                                
                                
                                Text("Upcoming Events")
                                    .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)

                                if !hostInformation.upcomingEvents.isEmpty{
                                    LabelEventView(inGroupError:inGroupError,events: $hostInformation.upcomingEvents, heder: "", locationSet: locationSet, long: long, lat: lat)
                                        .frame(height:geo.size.height * 0.35)
                                        .padding(.bottom,20)

                                }else{
                                    Text("No upcoming events.")
                                        .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                                        .padding(.bottom,20)


                                }

                                
                                Text("Past Events")
                                    .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)

                                if !hostInformation.pastEvents.isEmpty{
                                    LabelEventView(inGroupError:inGroupError,events: $hostInformation.pastEvents, heder: "", locationSet: locationSet, long: long, lat: lat)
                                        .frame(height:geo.size.height * 0.35)
                                        .padding(.bottom,30)

                                }else{
                                    Text("No past events.")
                                        .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                                        .padding(.bottom,30)


                                }

                                
                                
                            }
                            .frame(width: geo.size.width * 0.95)
                            
                           
                        }
                    }
                }
            
        
            }
            .background(BackgroundView())
            .overlay(VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"chevron.left").foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(AppColor.lovolDark.opacity(0.6)))
                    }

                    Spacer()
                }.padding()
                Spacer()
            })
        }
        .onAppear(perform: onAppear)
        .alert("There has been an error following this host.", isPresented: $errorFollowing, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
    }
    private func followHost(){
        profileViewModel.followHost(follow: !following, followingId: hostId, followerId: groupId) { result in
            switch result{
            case .success(()):
                print("success following")
                self.following.toggle()
            case .failure(_):
                print("could not follow")
                self.errorFollowing = true

                
            }
        }
    }
    private func onAppear(){
        
        profileViewModel.fetchTeam(id: hostId) { result in
            switch result{
            case .success(let team):
//                hostInformation.description = team.teamDescription
                long = team.long
                lat = team.lat
                locationSet = team.locationSet
                followers = team.followers
                profileViewModel.fetchMember { result in
                    switch result{
                    case .success(let member):
                        self.groupId = member.groupId
                    case .failure(_):
                        print("Failure checking group id")
                    }
                }
                
                if followers.contains(groupId){
                    self.following = true
                }
                
                eventViewModel.fetchHostedEventsForProfile(id: hostId, locationSet: locationSet, long: long, lat: lat) { result in
                    switch result{
                    case .success(let events):
                        var pastEvents : [EventModel] = []
                        var upcomingEvents : [EventModel] = []
         

                        for event in events{
                            if event.endingTime! < currentDate {
                                print("PAST")
                                pastEvents.append(event)
                            }else{
                                print("UPCOMING")

                                upcomingEvents.append(event)
                            }
                        }
                        hostInformation = HostInformation(id: hostId, name: hostName, description: team.teamDescription, pastEvents: pastEvents, upcomingEvents: upcomingEvents)
                        loadingHost = false
                    case .failure(let error):
                        print("error fetching events for specific profile. \(error)")
                    }
                }
            case .failure(let error):
                print("error fetching description \(error)")
            }
        }


        profileViewModel.fetchGroupMainPicture(profileId: hostId) { result in
            switch result{
            case .success(let image):
                self.mainPic = image
                self.loadedPic = true
            case .failure(let error):
                print("error fetching main picture")
            }
        }
    }
}

//struct HostProfileDescription_Previews: PreviewProvider {
//    static var previews: some View {
//        HostProfileDescription()
//    }
//}
