//
//  GroupProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/24/22.
//

import SwiftUI

struct GroupProfileView: View {
    

    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var profileViewModel: ProfilesViewModel
    
    @State private var isLoadingScreen : Bool = false

    
    @State private var isLoading: Bool = false
    @State private var groupName: String = ""
    @State private var groupBio: String = ""
    @State private var groupId: String = ""
    @State private var matchDataUpdated: Bool = false

    @State private var groupUsers: [String] = []

    @State private var showCannotEditError : Bool = false
    @State private var showErrorTogglign : Bool = false
    @State private var showErrorUpdating : Bool = false
    @State private var showLeaveGroupError : Bool = false
    @State private var droppedOutside: Bool = false
    @State private var showLeaveGroupConfirmation: Bool = false
    @State private var picturesModified: Bool = false
    @State private var previousPicCount: Int = 0
    
    @State private var discoverChoice : Bool = false
    @State private var profilePic : UIImage = UIImage()
    @State private var profilPicLoading : Bool = true
    
    
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
    @State private var isDiscoverable : Bool = false
    
    @State private var initialCollege :String = ""
    @State private var initialOccupation: String = ""
    @State private var initialBio :String  = ""
    @State private var initialPronouns :String = ""
    @State private var initialInterests : [String] = []
    @State private var initialPreferences = []
    @State private var initialOwnQuestions : [String] = []
    @State private var initialLeftAnswers : [String] = []
    @State private var initialRightAnswers : [String] = []
    @State private var initialLong : Double = 0
    @State private var initialLat : Double = 0
    @State private var initialIsDiscoverable : Bool = false
    @State private var initialLocationCity = ""
    @State private var initialInteractionPreference = 0
    @State private var initialDistancePreference : Double = 0
    @State private var initialMinimumAge = 0
    @State private var initialMaximumAge = 0
    @State private var initialAnswers = [0,0,0]
    @State private var initialGender : String = ""
    @State var doneProfile : Bool = false
//    @State var groupView : Bool = false
    
    @Binding var groupView : Bool
    @State private var loading : Bool = true
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                
//                if loading {
//                    ProgressView()
//                }
//                else if groupId == ""{
//                    NoGroupView()
//                }
            
                VStack{
                    if !profilPicLoading {
                        Image(uiImage: profilePic)
                            .resizable()
                            .centerCropped()

                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(AppColor.lovolTan,lineWidth:2)
                            )
                            .padding(.bottom,20)
                        
                    }
                    else{
                        Circle().stroke(AppColor.lovolTan,lineWidth:2)
                            .frame(width: 60, height: 60)
                            .padding(.bottom,20)
                        
                    }
                    
                    //
                    //                    Toggle("Team Is Discoverable", isOn: $isDiscoverable)
                    //                    .onChange(of: isDiscoverable, perform: { value in
                    //                        beDiscoverable(discoverChoice: value)
                    //                    })
                    //                        .toggleStyle(SwitchToggleStyle(tint: AppColor.lovolTan))
                    //                        .frame(width: 170)
                    
                    Button {
                        //
                    } label: {
                        HStack{
                            Spacer()
                            //                        Image(systemName: "pencil")
                            
                            Text("ID #\(groupId)")
                            
                            Spacer()
                            
                        }
                        
                        //                    .frame(width:.infinity)
                        
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    Button {
                        canIEdit()
                    } label: {
                        
                        NavigationLink(destination:EditPersonalInfo(isGroup: true, initialCollege: initialCollege, initialOccupation: initialOccupation, initialBio: initialBio, initialPronouns: initialPronouns, initialInterests: initialInterests, initialOwnQuestions: initialOwnQuestions, initialLeftAnswers: initialLeftAnswers, initialRightAnswers: initialRightAnswers, initialLong: initialLong, initialLat: initialLat, initialLocationCity: initialLocationCity, initialInteractionPreference: initialInteractionPreference, initialDistancePreference: initialDistancePreference, initialMinimumAge: initialMinimumAge, initialMaximumAge: initialMaximumAge, initialAnswers: initialAnswers, initialGender: initialGender,  bio: $bio, pronouns: $pronouns, occupation: $occupation, college: $college, interests: $interests, interactionPreference: $interactionPreference, distancePreference: $distancePreference, minimumAge: $minimumAge, maximumAge: $maximumAge, ownQuestions: $ownQuestions, leftAnswers: $leftAnswers, rightAnswers: $rightAnswers, answers: $answers, longitude: $longitude, latitude: $latitude, locationCity: $locationCity, gender: $gender)){
                            HStack{
                                Spacer()
                                Image(systemName: "pencil")
                                
                                Text("Edit Group Profile")
                                
                                Spacer()
                            }
                            
                        }
                        
                        //                    .frame(width:.infinity)
                        
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    .disabled(isDiscoverable)
                    
                    Button {
                        //
                    } label: {
                        NavigationLink(destination: RequestsView(groupId: groupId)) {
                            HStack{
                                Image(systemName: "person.badge.plus")
                                Text("Requests")
                                
                            }
                        }
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    
                    Button {
                        //
                    } label: {
                        NavigationLink(destination: ViewTestProfile(isGroup: true)) {
                            HStack{
                                Image(systemName: "eye")
                                Text("View Test Profile")
                                
                            }
                        }
                        
                        
                        
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    
                    Button {
                        //
                    } label: {
                        HStack{
                            Image(systemName: "crown.fill")
                            Text("Stats")
                            
                        }
                        
                        
                        
                    }
                    .frame(width:geo.size.width * 0.7,height:40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    Button {
                        //                    leaveGroup()
                    } label: {
                        NavigationLink(destination:  GroupOrSoloView()) {
                            HStack{
                                Image(systemName: "return")
                                Text("Leave Group")
                                
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            leaveGroup()
                        })
                    }
                    .frame(width:geo.size.width * 0.7,height:40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius:5, y: 5))
                    .padding(10)
                    
                    Spacer()
                    
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
            .alert("Cannot edit profile when I am Discoverable is on. Please turn it off to edit profile.", isPresented: $showCannotEditError, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
            .alert("Did not perform toggling action. Please try again later.", isPresented: $showErrorTogglign, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
            .alert("Error updating profile to enter match list. Please try again.", isPresented: $showErrorTogglign, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
            .alert("Error leaving group. Please try again.", isPresented: $showLeaveGroupError, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
//            .frame(maxWidth:.infinity,maxHeight:.infinity)
//            .background(
//                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
//            )
            .showLoading(isLoading)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
               ToolbarItemGroup(placement: .principal) {
//                   VStack{
//                       Image(systemName: "face.smiling.fill")
//                           .resizable()
//
//                           .frame(width:15,height:15)
//
//                           .foregroundColor(AppColor.lovolTan)
                       HStack{
                           Image(systemName: "face.smiling.fill")
                               .resizable()

                               .frame(width:10,height:10)

                               .foregroundColor(AppColor.lovolTan)
                           Image(systemName: "face.smiling.fill")
                               .resizable()
                               .frame(width:10,height:10)

                               .foregroundColor(AppColor.lovolTan)
                           Image(systemName: "face.smiling.fill")
                               .resizable()
                               .frame(width:10,height:10)

                               .foregroundColor(AppColor.lovolTan)
                       }
                       .font(.custom("Rubik Regular", size: 18))
//                   }
                   
         
               }
            }

        }
        .onAppear(perform: performOnAppear)
        
        
        
        
        
        
    }
    private func canIEdit(){
        if isDiscoverable{
            showCannotEditError = true
        }
    }
    private func leaveGroup(){
        isLoading = true
        profileViewModel.leaveGroupArray(groupId: groupId) { result in
            switch result{
            case .success(()):
                isLoading = false
                groupView = false
                groupId = ""
            case .failure(let error):
                print("error leaving group \(error)")
            }
        }

        
        
        
    }
    private func beDiscoverable(discoverChoice: Bool){
        
        if discoverChoice {
            print("discover choice is true")
            profileViewModel.updateConversion(groupId: groupId) { result in
                switch(result){
                case .success(()):
                    print("SUCCESS UPDATING CONVERSION")
                case .failure(let error):
                    print("FAILURE UPDATING CONVERSION \(error)")
                }
            }
        }
        var dictionary: [String: Any] = [:]
        dictionary[FirestoreSquad.CodingKeys.isPartOfSwipe.rawValue] = discoverChoice
        var dictionary2: [String: Any] = [:]
        dictionary2[FirestoreUser2.CodingKeys.isDiscoverable.rawValue] = discoverChoice
        
        profileViewModel.updateGroupProfile(groupId: groupId, modified: dictionary) { result in
            switch result {
            case .success(()):
                profileViewModel.updateUserProfile(id: groupId, modified: dictionary2) { result in
                    switch result{
                    case .success():
                        print("success toggling")
                    case .failure(let error):
                            print("failure updating userprofile of toggle \(error)")
                        showErrorUpdating = true

                    }
                }
            case .failure(let error):
                print("Error Toggling for squad \(error)")
                showErrorTogglign = true
            }
        }

 
   


        
    }

    private func performOnAppear() {
        print("repopulating")
        
        let user = profileViewModel.fetchUserFromLocal()
        let groupId = user.groupId ?? ""
        print("Group ID \(groupId)")
        if groupId == "" {
            loading = false
            
            return 
        }

        
        profileViewModel.fetchGroup(id: groupId) { result in
            switch result {
            case .success(let squad):
                populate(squad : squad)
                loading = false 
            case .failure(let error):
                print("Failure populating group profile \(error)")
            }
        }
        
        
        profileViewModel.fetchGroupMainPicture(profileId: groupId) { result in
            switch result {
            case .success(let image):
                profilePic = image
                profilPicLoading = false
            case .failure(let error):
                print("error retrieving group profile picture \(error)")
//                showLeaveGroupError = true

            }

        }

    }
    private func populate(squad: FirestoreSquad){
        let user = squad
        bio = user.bio
        interests = user.groupInterests
        college = user.groupCollege
        occupation = user.groupOccupation
        answers = user.answers
        ownQuestions = user.ownQuestions
        leftAnswers = user.ownLeftAnswer
        rightAnswers = user.ownRightAnswer
        interactionPreference = user.interactionPreference
        distancePreference = user.maxDistancePreference
        minimumAge = user.minYearPreference
        maximumAge = user.maxYearPreference
        longitude = user.longitude
        latitude  = user.latitude
        locationCity = user.city
        groupId = user.id
        isDiscoverable = user.isPartOfSwipe
        
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
        self.initialIsDiscoverable = isDiscoverable
    }

    

}

struct GroupProfileView_Previews: PreviewProvider {
    @State static var groupView: Bool = true
    static var previews: some View {
        GroupProfileView(groupView: $groupView)
    }
}
