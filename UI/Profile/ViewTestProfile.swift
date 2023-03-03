//
//  ViewTestProfile.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/11/22.
//

import SwiftUI

struct ViewTestProfile: View {
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
    @State var isGroup : Bool

    @State private var swipeViewLoading = true
    @State private var answers : [Int] = [-1,-1,-1]
    @State private var questions: [String] = ["","",""]
    @State private var left : [String] = ["","",""]
    @State private var right : [String] = ["","",""]
    @State private var model : NewUserProfile = NewUserProfile(userId: "", name: "", age: 0, bio: "", amountOfUsers: 0, isATeam: false, interests: [], college: "", occupation: "",  formPreference: 0, interactionPreference: 0, maxDistancePreference: 0, maxYearPreference: 0, minYearPreference: 0, answersToGlobalQuestions: [], ownQuestions: [], ownLeftAnswer: [], ownRightAnswer: [], pictures: [], nameAndPic: [], city: "")
    @State private var pictures : [UIImage] = []
    var body: some View {
        NavigationStack{
            VStack{
                if (swipeViewLoading){
                    ProgressView()
                }else{
                    InfiniteSwipeCardView(model: model, chosenAnswers: $answers, chosenQuestions: $questions, leftQuestions: $left, rightQuestions: $right, personalAnswers: [], isTestProfile: true)
                }
                
                
                
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Test View")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: perform)
        }
        
    }
    func perform(){
        
        if isGroup{
            profileViewModel.fetchUserWO { result in
                switch result {
                case .success(let user):
                    profileViewModel.fetchUser(id: user.groupId!) { result in
                        switch result{
                        case .success(let user):
                            firestoreViewModel.fetchGroupUserPictures(groupId: profileViewModel.fetchGroupId()) { result in
                                switch result{
                                case .success(let pictures):
                                    populate(user: user, pictures: pictures)

                                    return
                                case .failure(_):
                                    return
                                }
                            } onUpdate: { result in
                                switch result{
                                case .success(let pictureList):
                                    pictures = pictureList
                                    populate(user: user, pictures: pictureList)

                                    return
                                case .failure(_):
                                    return
                                }
                            }

                        case .failure(let error):
                            print("error fetching group profile for view testing \(error)")
                        }
                    }
                case .failure(let error):
                    print("error fetching user from group \(error)")
                    return
                }
            }

            
        }
        else{
            profileViewModel.fetchUserWO { result in
                switch result {
                case .success(let user):
                    print("This belongs to \(user.name)")
                    firestoreViewModel.fetchUserPictures(onCompletion: { result in
                        switch result{
                        case .success(let pictureList):
                            self.pictures = pictureList
                            print("picturelist count \(pictureList.count)")
                            populate(user: user, pictures: pictureList)
                            print("Success populating pictures")
                            return
                        case .failure(_):
                            return
                        }
                    }, onUpdate: {result in
                        switch result{
                        case .success(let pictureList):
                            self.pictures = pictureList
                            populate(user: user, pictures: pictureList)

                            return
                        case .failure(_):
                            return
                        }
                    })
                case .failure(let error):
                    print("error fetching user \(error)")
                }
            }

        }
 
    

        
    }
    
    //checks local cache first, then downloads pictures
    func populate(user : FirestoreUser2, pictures: [UIImage]){
        let id = profileViewModel.fetchUserId()
        print("pictures . count \(pictures.count)")
        let modelUser = NewUserProfile(userId: id, name: user.name, age: user.age, bio: user.bio, amountOfUsers: user.amountOfUsers, isATeam: user.isATeam, interests: user.interests, college: user.college, occupation: user.occupation, formPreference: user.formPreference, interactionPreference: user.interactionPreference, maxDistancePreference: user.maxDistancePreference, maxYearPreference: user.maxYearPreference, minYearPreference: user.minYearPreference, answersToGlobalQuestions: user.answersToGlobalQuestions, ownQuestions: user.ownQuestions, ownLeftAnswer: user.ownLeftAnswer, ownRightAnswer: user.ownRightAnswer, pictures: pictures, nameAndPic: [], city: user.city)
        self.model = modelUser
        
        if pictures.count == 0 {
            return
        }
        swipeViewLoading = false 

    }
}


struct ViewTestProfile_Previews: PreviewProvider {
    static var previews: some View {
        ViewTestProfile(isGroup: true)
    }
}
