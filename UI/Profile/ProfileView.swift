//
//  ProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/27/22.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var profileViewModel: ProfilesViewModel
//    @ObservableObject var localStore : LocalStore
    
    @State private var isLoading: Bool = false
    @State private var profilPicLoading: Bool = true
    @State private var profilePic: UIImage = UIImage()
    @State private var showError: Bool = false
    @State private var showCannotEditError = false 
    @State private var showCannotToggleError = false
    @State private var isDiscoverable : Bool = false


    @State private var bio : String = ""
    @State private var pronouns :String = ""
    @State private var occupation = ""
    @State private var college :String = ""
    @State private var interests : [String] = []
    @State private var interactionPreference : Int = 0
    @State private var distancePreference : Double = 0
    @State private var minimumAge : Int = 0
    @State private var maximumAge : Int = 0
    @State private var ownQuestions : [String] = ["1","2","3"]
    @State private var leftAnswers : [String] = ["1","2","3"]
    @State private var rightAnswers : [String] = ["1","2","3"]
    @State private var answers : [Int] = [1,2,3]
    @State private var longitude : Double = 0
    @State private var latitude : Double = 0
    @State private var locationCity = ""
    @State private var gender : String = ""
    @State private var name : String = ""
    
    @State private var initialCollege :String = ""
    @State private var initialOccupation: String = ""
    @State private var initialBio :String  = ""
    @State private var initialPronouns :String = ""
    @State private var initialInterests : [String] = []
    @State private var initialPreferences = []
    @State private var initialOwnQuestions : [String] = []
    @State private var initialLeftAnswers : [String] = []
    @State private var initialRightAnswers : [String] = []
    @State private var initialChosenAnswers : [String] = []
    @State private var initialLong : Double = 0
    @State private var initialLat : Double = 0

    @State private var initialLocationCity = ""
    @State private var initialInteractionPreference = 0
    @State private var initialDistancePreference : Double = 0
    @State private var initialMinimumAge = 0
    @State private var initialMaximumAge = 0
    @State private var initialAnswers = [0,0,0]
    @State private var initialGender : String = ""
    var body: some View {
        
        NavigationStack{
            GeometryReader { geo in
                VStack{
                    if !profilPicLoading {
                        Image(uiImage: profilePic)
                            .resizable()
                            .centerCropped()
                            .frame(width: geo.size.height * 0.1, height: geo.size.height * 0.1)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(AppColor.lovolTan,lineWidth:2)
                            )
                            .padding(.bottom,20)
                        
                        
                    }
                    else{
                        Circle().stroke(AppColor.lovolTan,lineWidth:2)
                            .frame(width: 80, height: 80)
                            .padding(.bottom,20)
                        
                        
                    }
                    
                    //                    Toggle("I am Discoverable", isOn: $isDiscoverable)
                    //                    .onChange(of: isDiscoverable, perform: { value in
                    //                        beDiscoverable(discoverChoice: value)
                    //                    })
                    //                        .toggleStyle(SwitchToggleStyle(tint: AppColor.lovolTan))
                    //                        .frame(width: 170)
                    
                    Button {
//                        canIEdit()
                    } label: {
                        NavigationLink(destination: EditPersonalInfo(isGroup: false, initialCollege: initialCollege, initialOccupation: initialOccupation, initialBio: initialBio, initialPronouns: initialPronouns, initialInterests: initialInterests, initialOwnQuestions: initialOwnQuestions, initialLeftAnswers: initialLeftAnswers, initialRightAnswers: initialRightAnswers, initialLong: initialLong, initialLat: initialLat, initialLocationCity: initialLocationCity, initialInteractionPreference: initialInteractionPreference, initialDistancePreference: initialDistancePreference, initialMinimumAge: initialMinimumAge, initialMaximumAge: initialMaximumAge, initialAnswers: initialAnswers, initialGender: initialGender, bio: $bio, pronouns: $pronouns, occupation: $occupation, college: $college, interests: $interests, interactionPreference: $interactionPreference, distancePreference: $distancePreference, minimumAge: $minimumAge, maximumAge: $maximumAge, ownQuestions: $ownQuestions, leftAnswers: $leftAnswers, rightAnswers: $rightAnswers, answers: $answers, longitude: $longitude, latitude: $latitude, locationCity: $locationCity, gender: $gender)) {
                            HStack{
                                Spacer()
                                Image(systemName: "pencil")
                                
                                Text("Edit Profile")
                                
                                Spacer()
                                
                            }
                        }
                    }
                    .frame(width:geo.size.width * 0.7,height:geo.size.height * 0.1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
//                    .disabled(isDiscoverable)
                    Button {
                        //
                    } label: {
                        NavigationLink(destination: ViewTestProfile(isGroup: false)) {
                            HStack{
                                Image(systemName: "eye")
                                Text("View Test Profile")
                                
                            }
                        }
                        
                        
                        
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:geo.size.height * 0.1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    Button {
                        //
                    } label: {
                        NavigationLink(destination: ProfileSettingsView()) {
                            HStack{
                                Image(systemName: "slider.horizontal.3")
                                Text("Settings")
                            }
                            
                        }
                        
                        
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:geo.size.height * 0.1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    
                    Button {
                        //
                    } label: {
                        HStack{
                            Image(systemName: "envelope.fill")
                            Text("Contacts")
                            
                        }
                        
                        
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:geo.size.height * 0.1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    
                    Button {
                        //
                    } label: {
                        HStack{
                            Image(systemName: "hurricane")
                            Text("Lovol+")
                            
                        }
                        
                        
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:geo.size.height * 0.1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    
                    
                    Spacer()
                    
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
                //
                //            .frame(maxWidth:.infinity,maxHeight:.infinity)
                //            .background(
                //                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                //            )
                .navigationBarTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .principal) {
                        //                   Image(systemName: "face.smiling.fill")
                        Text("Hello \(name)")
                            .foregroundColor(AppColor.lovolTan)
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
                        
                    }
                }
                .alert("Cannot edit profile when I am Discoverable is on. Please turn it off to edit profile.", isPresented: $showCannotEditError, actions: {
                    Button("OK", role: .cancel, action: {
                        
                    })
                })
                .alert("Cannot edit profile when I am Discoverable is on. Please turn it off to edit profile.", isPresented: $showCannotToggleError, actions: {
                    Button("OK", role: .cancel, action: {
                        
                    })
                })
                
            }
        }
        .onAppear(perform: populateData)
        .onDisappear()



        }
    private func beDiscoverable(discoverChoice: Bool){
        var dictionary: [String: Any] = [:]

        dictionary[FirestoreUser2.CodingKeys.isDiscoverable.rawValue] = discoverChoice
        profileViewModel.updateUserProfile(modified: dictionary) { result in
            switch result {
            case .success(()):
                print("success toggling")
            case .failure(let error):
                showCannotToggleError = true 
                print("failure toggling \(error)")
            }
        }
    }
    private func canIEdit(){
        if isDiscoverable {
            showCannotEditError = true
            
        }
    }


            
    private func populateData(){
        
        let user = profileViewModel.fetchUserFromLocal()
//        let user = localStore.localUser[0].userInfo
        name = user.name
        bio = user.bio
        interests = user.interests
        college = user.college
        occupation = user.occupation
        answers = user.ownAnswers
        ownQuestions = user.ownQuestions
        leftAnswers = user.ownLeftAnswer
        rightAnswers = user.ownRightAnswer
        
        pronouns = user.pronouns
        gender = user.gender
        isDiscoverable = user.isDiscoverable
        interactionPreference = user.interactionPreference
        distancePreference = user.maxDistancePreference
        minimumAge = user.minYearPreference
        maximumAge = user.maxYearPreference
       longitude = user.longitude ?? 0.0
       latitude  = user.latitude ?? 0.0
        locationCity = user.city
        self.initialBio = bio
        self.initialCollege = college
        self.initialOccupation = occupation
        self.initialPronouns = pronouns
        self.initialInterests = interests
        self.initialInteractionPreference = interactionPreference
        self.initialDistancePreference = distancePreference
        self.initialMaximumAge = maximumAge
        self.initialMinimumAge = minimumAge
        self.initialOwnQuestions = ownQuestions
        self.initialLeftAnswers = leftAnswers
        self.initialRightAnswers = rightAnswers
        self.initialAnswers = answers
        self.initialGender = gender
        self.initialLong = longitude
        self.initialLat = latitude
        self.initialLocationCity = locationCity
        
        
   
        profileViewModel.fetchMainPicture(profileId: profileViewModel.fetchUserId()) { result in
            switch result{
                
            case .success(let image):
                profilePic = image
                profilPicLoading = false
                print("loaded profile pictures")
            case .failure(let error):
                print("error retrieving users profile picture \(error)")
                
            }
        }
        
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
