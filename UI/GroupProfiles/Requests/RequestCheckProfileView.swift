//
//  RequestCheckProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/19/22.
//

import SwiftUI

struct RequestCheckProfileView: View {
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showSheet : Bool = false
    
    @State private var answers : [Int] = [-1,-1,-1]
    @State private var questions: [String] = ["","",""]
    @State private var left : [String] = ["","",""]
    @State private var right : [String] = ["","",""]
    @State private var model : NewUserProfile = NewUserProfile(userId: "", name: "", age: 0, bio: "", amountOfUsers: 0, isATeam: false, interests: [], college: "", occupation: "",  formPreference: 0, interactionPreference: 0, maxDistancePreference: 0, maxYearPreference: 0, minYearPreference: 0, answersToGlobalQuestions: [], ownQuestions: [], ownLeftAnswer: [], ownRightAnswer: [], pictures: [], nameAndPic: [], city: "")
    @State private var pictures : [UIImage] = []
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
    @State private var showError : Bool = false
    
    var senderId : String
    @State private var isLoading :Bool = true
    
    var body: some View {
        NavigationStack{
            VStack{
                if isLoading{
                    ProgressView()
                }
                else{
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
                   Text("\(model.name)")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: perform)
            .alert("Failure loading profile. Please try agian.", isPresented: $showError, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
        }

        
    
    }
    private func perform(){
        
        profileViewModel.fetchUser(id: senderId) { result in
            switch result{
            case .success(let user):

                firestoreViewModel.fetchProfilePictures(profileId: senderId) { pics in
                    switch pics {
                    case .success(let photos):
                        let newModel = NewUserProfile(userId: "", name: user.name, age: user.age, bio: user.bio, amountOfUsers: user.amountOfUsers, isATeam: user.isDiscoverable, interests: user.interests, college: user.college, occupation: user.occupation, formPreference: 0, interactionPreference: 0, maxDistancePreference: 0, maxYearPreference: 0, minYearPreference: 0, answersToGlobalQuestions: [], ownQuestions: user.ownQuestions, ownLeftAnswer: user.ownLeftAnswer, ownRightAnswer: user.ownRightAnswer, pictures: photos, nameAndPic: [], city: user.city)
                            model = newModel
                        isLoading = false 
                    case .failure(_):
                        showError = true
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
            case .failure(_):
                showError = true
                presentationMode.wrappedValue.dismiss()
                
            }
        }
        
        
        
    }
    
}

struct RequestCheckProfileView_Previews: PreviewProvider {
    static var previews: some View {
        RequestCheckProfileView(senderId: "")
    }
}
