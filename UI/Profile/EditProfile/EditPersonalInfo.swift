//
//  EditPersonalInfo.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct EditPersonalInfo: View {
    
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    
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
    
    @State var isLoadingInfo : Bool = true
    @State var isLoading : Bool = false
    @State var showError : Bool = false
    @State var isLoadingPics : Bool = false
    
    @State var isGroup : Bool 
   var initialCollege :String
     var initialOccupation: String
     var initialBio :String
    var initialPronouns :String
     var initialInterests : [String]
     var initialOwnQuestions : [String]
    var initialLeftAnswers : [String]
   var initialRightAnswers : [String]
     var initialLong : Double
    var initialLat : Double
    var initialLocationCity : String
    var initialInteractionPreference : Int
     var initialDistancePreference : Double
    var initialMinimumAge : Int
    var initialMaximumAge : Int
    var initialAnswers : [Int]
      var initialGender : String
//    var initialIsDiscoverable : Bool
    
    @Binding var bio : String
    @Binding var pronouns :String
    @Binding var occupation : String
    @Binding var college :String
    @Binding var interests : [String]
    @Binding var interactionPreference : Int
    @Binding var distancePreference : Double
    @Binding var minimumAge : Int
    @Binding var maximumAge : Int
    @Binding var ownQuestions : [String]
    @Binding var leftAnswers : [String]
    @Binding var rightAnswers : [String]
    @Binding var answers : [Int]
    @Binding var longitude : Double
    @Binding var latitude : Double
    @Binding var locationCity : String
    @Binding var gender : String
//    @Binding var isDiscoverable : Bool
    @State private var pictures: [UIImage] = []
     @State private var picturesModified: Bool = false
     @State private var previousPicCount : Int = 0
    
    
    var body: some View {
        NavigationStack{
            VStack{
                
                
                ScrollView{
                    Group{
                        
                        VStack(spacing:0){
                            HStack{
                                Text("Edit Bio")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                Spacer()
                            }
                            .frame(width:280)
                            Button {
                                
                            } label: {
                                VStack{
                                    NavigationLink(destination: EditBio(bio:$bio)) {
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                            .frame(width:300, height:35)
                                            .padding(.horizontal,20)
                                            .overlay(
                                                HStack{
                                                    Text(bio)
                                                    Spacer()
                                                    Image(systemName:"chevron.right")
                                                }
                                                    .frame(width:280, height:35)
                                                
                                                
                                            )
                                    }
                                    
                                }
                            }
                            
                            
                            
                        }
                        if(!isGroup){
                            VStack(spacing:0){
                                HStack{
                                    Text("Edit Pronouns")
                                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                    Spacer()
                                }
                                .frame(width:280)
                                Button {
                                    
                                } label: {
                                    VStack{
                                        NavigationLink(destination: EditPronouns(pronouns:$pronouns)) {
                                            RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                                .frame(width:300, height:35)
                                                .padding(.horizontal,20)
                                                .overlay(
                                                    HStack{
                                                        Text(pronouns)
                                                        Spacer()
                                                        Image(systemName:"chevron.right")
                                                    }
                                                        .frame(width:280, height:35)
                                                )
                                        }
                                        
                                    }
                                }
                            }
                            
                            
                            
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Edit Occupation")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                Spacer()
                            }
                            .frame(width:280)
                            Button {
                                
                            } label: {
                                VStack{
                                    NavigationLink(destination: EditOccupation(occupation:$occupation)) {
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                            .frame(width:300, height:35)
                                            .padding(.horizontal,20)
                                            .overlay(
                                                HStack{
                                                    Text(occupation)
                                                    Spacer()
                                                    Image(systemName:"chevron.right")
                                                }
                                                    .frame(width:280, height:35)
                                                
                                            )
                                    }
                                    
                                }
                            }
                            
                            
                            
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Edit College")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                Spacer()
                            }
                            .frame(width:280)
                            Button {
                                
                            } label: {
                                VStack{
                                    NavigationLink(destination: EditCollege(college:$college)) {
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                            .frame(width:300, height:35)
                                            .padding(.horizontal,20)
                                            .overlay(
                                                HStack{
                                                    Text(college)
                                                    Spacer()
                                                    Image(systemName:"chevron.right")
                                                }
                                                    .frame(width:280, height:35)
                                            )
                                    }
                                    
                                }
                            }
                            
                            
                            
                        }
                    }
                    Group{
                        
                        VStack(spacing:0){
                            HStack{
                                Text("Edit Interests/Hobbies")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                Spacer()
                            }
                            .frame(width:280)
                            Button {
                                
                            } label: {
                                VStack{
                                    NavigationLink(destination: EditInterestHobbies(interests:$interests)) {
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                            .frame(width:300, height:35)
                                            .padding(.horizontal,20)
                                            .overlay(
                                                HStack{
                                                    Text("Edit Interests/Hobbies")
                                                    Spacer()
                                                    Image(systemName:"chevron.right")
                                                }
                                                    .frame(width:280, height:35)
                                            )
                                    }
                                    
                                }
                            }
                            
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Edit Questions")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                Spacer()
                            }
                            .frame(width:280)
                            Button {
                                
                            } label: {
                                VStack{
                                    NavigationLink(destination: EditQuestions(ownQuestions:$ownQuestions, leftAnswers:$leftAnswers, rightAnswers: $rightAnswers, answers: $answers)) {
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                            .frame(width:300, height:35)
                                            .padding(.horizontal,20)
                                            .overlay(
                                                HStack{
                                                    Text("Edit Questions")
                                                    Spacer()
                                                    Image(systemName:"chevron.right")
                                                }
                                                    .frame(width:280, height:35)
                                            )
                                    }
                                    
                                }
                            }
                            
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Edit Preferences")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                Spacer()
                            }
                            .frame(width:280)
                            Button {
                                
                            } label: {
                                VStack{
                                    NavigationLink(destination: EditPreference(realInteractionPreference: $interactionPreference, realDistancePreference: $distancePreference, realMinimumAge: $minimumAge, realMaximumAge: $maximumAge)) {
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                            .frame(width:300, height:35)
                                            .padding(.horizontal,20)
                                            .overlay(
                                                HStack{
                                                    Text("Edit Preferences")
                                                    Spacer()
                                                    Image(systemName:"chevron.right")
                                                }
                                                    .frame(width:280, height:35)
                                                
                                            )
                                    }
                                    
                                }
                            }
                            
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Edit Location")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                Spacer()
                            }
                            .frame(width:280)
                            Button {
                                
                            } label: {
                                VStack{
                                    NavigationLink(destination: EditLocation(long: $longitude, lat: $latitude, locationCity: $locationCity )) {
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                            .frame(width:300, height:35)
                                            .padding(.horizontal,20)
                                            .overlay(
                                                HStack{
                                                    Text("Edit Location")
                                                    Spacer()
                                                    Image(systemName:"chevron.right")
                                                }
                                                    .frame(width:280, height:35)
                                            )
                                    }
                                    
                                }
                            }
                            
                        }
                        VStack(spacing:0){
                            HStack{
                                Text("Edit Pictures")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                                Spacer()
                            }
                            .frame(width:280)
                            Button {
                                
                            } label: {
                                VStack{
                                    NavigationLink(destination: EditPictures(picturesModified: $picturesModified, pictures:$pictures)) {
                                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                                            .frame(width:300, height:35)
                                            .padding(.horizontal,20)
                                            .overlay(
                                                HStack{
                                                    Text("Edit Pictures")
                                                    Spacer()
                                                    Image(systemName:"chevron.right")
                                                }
                                                    .frame(width:280, height:35)
                                            )
                                    }
                                    
                                }
                            }
                            
                        }
                        
                    }
                    Button(action: done) {
                        Text("Save Edits")
                            .padding(.top,20)
                    }
                    
                    
                    
                    
                }
            }
            .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolTan)

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   if isGroup{
                       Text("Edit Group Profile")
                           .foregroundColor(AppColor.lovolTan)
                   }
                   else{
                       Text("Edit Profile")
                           .foregroundColor(AppColor.lovolTan)
                   }
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: populateData)
        }
    }
    private func done(){
        isLoading = true
        print("done is pressed ")
        if !isGroup{
            if(hasModifiedProfileInformation() && picturesModified){
                print("here")
                profileViewModel.updateUserProfile(modified: getModifiedProfileFields(), pictures: pictures, previousPicCount: previousPicCount, onCompletion: onProfileUpdateCompletion)

            } else if(hasModifiedProfileInformation()){
                print("updating")
                profileViewModel.updateUserProfile(modified: getModifiedProfileFields(), onCompletion: onProfileUpdateCompletion)

                
            } else if(picturesModified){
                print("tjere")
                profileViewModel.updateUserProfile(pictures: pictures, previousPicCount: previousPicCount, onCompletion: onProfileUpdateCompletion)
            } else {
                print("how about here")
                presentationMode.wrappedValue.dismiss()
            }
        }
        else{
           let groupId = profileViewModel.fetchUserFromLocal().groupId!
            if(hasModifiedGroupProfileInformation() && picturesModified){
                profileViewModel.updateGroupProfile(groupId: groupId, modified: getModifiedGroupProfileFields(), pictures: pictures, previousPicCount: previousPicCount, onCompletion: onProfileUpdateCompletion)

            } else if(hasModifiedGroupProfileInformation()){
                profileViewModel.updateGroupProfile(groupId: groupId, modified: getModifiedGroupProfileFields(), onCompletion: onProfileUpdateCompletion)

                
            } else if(picturesModified){
                profileViewModel.updateGroupProfilePics(groupId:groupId, pictures: pictures, previousPicCount: previousPicCount, onCompletion: onProfileUpdateCompletion)
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }

    }
    private func populateData(){
        
        isLoadingPics = true
        firestoreViewModel.fetchUserPictures(onCompletion: { result in
            switch result{
            case .success(let pictureList):
                pictures = pictureList
                previousPicCount = pictureList.count
                isLoadingPics = false
                
                return
            case .failure(_):
                return
            }
        }, onUpdate: {result in
            switch result{
            case .success(let pictureList):
                pictures = pictureList
                previousPicCount = pictureList.count
                isLoadingPics = false

                return
            case .failure(_):
                return
            }
        })

 
        isLoadingInfo = false
 
    }
    private func onProfileUpdateCompletion(result: Result<Void, DomainError>){
        isLoading = false
        switch result{
        case .success(_):
            print("updating profile")
            profileViewModel.fetchUserToUpdateLocal {
                presentationMode.wrappedValue.dismiss()
                return
            }
           
        case .failure(let error):
            print("Error updating profile \(error)")
            showError = true
            return
        }
    }
    private func hasModifiedProfileInformation() -> Bool{
        print("initial bio \(initialBio)")
        print("bio \(bio)")
        return initialBio != bio || initialCollege != college || initialOccupation != occupation || initialAnswers != answers || initialOwnQuestions != ownQuestions || initialLeftAnswers != leftAnswers || initialRightAnswers != rightAnswers || initialMaximumAge != maximumAge || initialMinimumAge != minimumAge || initialDistancePreference != distancePreference || initialInteractionPreference != interactionPreference || initialPronouns != pronouns || initialInterests != interests || initialGender != gender

    }
    private func hasModifiedGroupProfileInformation() -> Bool{
        
        return initialBio != bio || initialCollege != college || initialOccupation != occupation || initialAnswers != answers || initialOwnQuestions != ownQuestions || initialLeftAnswers != leftAnswers || initialRightAnswers != rightAnswers || initialMaximumAge != maximumAge || initialMinimumAge != minimumAge || initialDistancePreference != distancePreference || initialInteractionPreference != interactionPreference ||  initialInterests != interests

    }
    private func getModifiedProfileFields() -> [String: Any]{
        var dictionary: [String: Any] = [:]
        if(initialBio != bio){ dictionary[FirestoreUser2.CodingKeys.bio.rawValue] = bio}
        if(initialCollege != college){
            dictionary[FirestoreUser2.CodingKeys.college.rawValue] = college
        }
        if(initialOccupation != occupation){
            dictionary[FirestoreUser2.CodingKeys.occupation.rawValue] = occupation
        }
        if(initialOwnQuestions != ownQuestions){dictionary[FirestoreUser2.CodingKeys.ownQuestions.rawValue] = ownQuestions}
        if(initialLeftAnswers != leftAnswers){dictionary[FirestoreUser2.CodingKeys.ownLeftAnswer.rawValue] = leftAnswers}
        if(initialRightAnswers != rightAnswers){dictionary[FirestoreUser2.CodingKeys.ownRightAnswer.rawValue] = rightAnswers}
        if(initialPronouns != pronouns){dictionary[FirestoreUser2.CodingKeys.pronouns.rawValue] = pronouns}
        if(initialInterests != interests){dictionary[FirestoreUser2.CodingKeys.interests.rawValue] = interests}
        if(initialMinimumAge != minimumAge){dictionary[FirestoreUser2.CodingKeys.minYearPreference.rawValue] = minimumAge}
        if(initialMaximumAge != maximumAge){dictionary[FirestoreUser2.CodingKeys.maxYearPreference.rawValue] = maximumAge}
        if(initialDistancePreference != distancePreference){dictionary[FirestoreUser2.CodingKeys.maxDistancePreference.rawValue] = distancePreference}
        if(initialInteractionPreference != interactionPreference){dictionary[FirestoreUser2.CodingKeys.interactionPreference.rawValue] = interactionPreference}
        if(initialAnswers != answers){dictionary[FirestoreUser2.CodingKeys.ownAnswers.rawValue] = answers}
        if(initialLocationCity != locationCity){dictionary[FirestoreUser2.CodingKeys.city.rawValue] = locationCity}
        if(initialLong != longitude){dictionary[FirestoreUser2.CodingKeys.longitude.rawValue] = longitude}
        if(initialLat != latitude){dictionary[FirestoreUser2.CodingKeys.latitude.rawValue] = latitude}
        if(initialGender != gender){dictionary[FirestoreUser2.CodingKeys.gender.rawValue] = gender }
       
            

        return dictionary
    }
    private func getModifiedGroupProfileFields() -> [String: Any]{
        var dictionary: [String: Any] = [:]
        if(initialBio != bio){ dictionary[FirestoreSquad.CodingKeys.bio.rawValue] = bio}
        if(initialCollege != college){
            dictionary[FirestoreSquad.CodingKeys.groupCollege.rawValue] = college
        }
        if(initialOccupation != occupation){
            dictionary[FirestoreSquad.CodingKeys.groupOccupation.rawValue] = occupation
        }
        if(initialOwnQuestions != ownQuestions){dictionary[FirestoreSquad.CodingKeys.ownQuestions.rawValue] = ownQuestions}
        if(initialLeftAnswers != leftAnswers){dictionary[FirestoreSquad.CodingKeys.ownLeftAnswer.rawValue] = leftAnswers}
        if(initialRightAnswers != rightAnswers){dictionary[FirestoreSquad.CodingKeys.ownRightAnswer.rawValue] = rightAnswers}

        if(initialInterests != interests){dictionary[FirestoreSquad.CodingKeys.groupInterests.rawValue] = interests}
        if(initialMinimumAge != minimumAge){dictionary[FirestoreSquad.CodingKeys.minYearPreference.rawValue] = minimumAge}
        if(initialMaximumAge != maximumAge){dictionary[FirestoreSquad.CodingKeys.maxYearPreference.rawValue] = maximumAge}
        if(initialDistancePreference != distancePreference){dictionary[FirestoreSquad.CodingKeys.maxDistancePreference.rawValue] = distancePreference}
        if(initialInteractionPreference != interactionPreference){dictionary[FirestoreSquad.CodingKeys.interactionPreference.rawValue] = interactionPreference}
        if(initialAnswers != answers){dictionary[FirestoreSquad.CodingKeys.answers.rawValue] = answers}
        if(initialLocationCity != locationCity){dictionary[FirestoreSquad.CodingKeys.city.rawValue] = locationCity}
        if(initialLong != longitude){dictionary[FirestoreSquad.CodingKeys.longitude.rawValue] = longitude}
        if(initialLat != latitude){dictionary[FirestoreSquad.CodingKeys.latitude.rawValue] = latitude}
       

            

        return dictionary
    }
}

struct EditPersonalInfo_Previews: PreviewProvider {
    static let isGroup : Bool = true
    static let initialCollege = ""
    static let initialOccupation = ""
    static let initialBio = ""
    static let initialPronouns = ""
    static let initialInterests : [String] = []
    static let initialOwnQuestions : [String] = []
    static let initialLeftAnswers : [String] = []
    static let initialRightAnswers : [String] = []
    static let initialChosenAnswers : [Int] = []
    static let initialLong : Double = 0
    static let initialLat : Double = 0
    static let initialLocationCity = ""
    static let initialInteractionPreference : Int = 0
    static let initialDistancePreference : Int = 0
    static let initialMinimumAge : Double = 0
    static let initialMaximumAge : Double = 0
    static let initialAnswers : [Int] = []
    static let initialGender = ""
    static let initialIsDiscoverable = true
    @State static var bio : String = "Hello this is my bio this is pretty cool but i just wnna see if it shows in the entire square things and or where it cuts off just checking..."
    @State static var pronouns : String = ""
    @State static var occupation : String  = ""
    @State static var college : String = ""
    @State static var interests : [String] = []
    @State static var interactionPreference : Int = 0
    @State static var distancePreference : Double = 0
    @State static var minimumAge : Int = 0
    @State static var maximumAge : Int = 0
    @State static var ownQuestions : [String] = []
    @State static var leftAnswers : [String ] = []
    @State static var rightAnswers : [String] = []
    @State static var answers : [Int] = []
    @State static var longitude : Double = 0
    @State static var latitude : Double = 0
    @State static var locationCity : String = ""
    @State static var gender : String = ""
    @State static var isDiscoverable : Bool = true
    static var previews: some View {
        EditPersonalInfo(isGroup: isGroup, initialCollege: initialCollege, initialOccupation: initialOccupation, initialBio: initialBio, initialPronouns: initialPronouns, initialInterests: initialInterests, initialOwnQuestions: initialOwnQuestions, initialLeftAnswers: initialLeftAnswers, initialRightAnswers: initialRightAnswers, initialLong: initialLong, initialLat: initialLat, initialLocationCity: initialLocationCity, initialInteractionPreference: initialInteractionPreference, initialDistancePreference: Double(initialDistancePreference), initialMinimumAge: Int(initialMinimumAge), initialMaximumAge: Int(initialMaximumAge), initialAnswers: initialAnswers, initialGender: initialGender, bio: $bio, pronouns: $pronouns, occupation: $occupation, college: $college, interests: $interests, interactionPreference: $interactionPreference, distancePreference: $distancePreference, minimumAge: $minimumAge, maximumAge: $maximumAge, ownQuestions: $ownQuestions, leftAnswers: $leftAnswers, rightAnswers: $rightAnswers, answers: $answers, longitude: $longitude, latitude: $latitude, locationCity: $locationCity, gender: $gender).environmentObject(ProfilesViewModel())
    }
}
