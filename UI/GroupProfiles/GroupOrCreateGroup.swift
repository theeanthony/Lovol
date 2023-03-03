//
//  GroupOrCreateGroup.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/24/22.
//

import SwiftUI

struct GroupOrCreateGroup: View {
    @EnvironmentObject var profileViewModel: ProfilesViewModel
    
    
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
    var entity : Int
    var interactionPreference : Int
    var longitude : Double
    var latitude : Double
    var city : String
    var distance: Double
    var minAge : Int
    var maxAge : Int
    
    @State private var isLoading :Bool = false
    @Binding  var doneProfile : Bool
    @Binding var groupView: Bool
//    @State private var groupId : String = ""
    
    
    var body: some View {
        
        NavigationStack{
            VStack{
                
                
                if groupView {
                    GroupOrSoloView(groupView: groupView)
                }
                else if doneProfile {
                    FinishGroupCreationView(name: name)

                }

                else{
                   Text("no group view after creating group")

                }
            }

     
//            .frame(maxWidth:.infinity,maxHeight:.infinity)
//            .background(
//                LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
//            )
            .navigationBarBackButtonHidden(true)
            
        }
        
        
        
        .onAppear(perform: performOnAppear)
    }
        
      
    private func performOnAppear(){
        
//        print("APPEARING or apppeard")
//
//        self.groupId = profileViewModel.fetchGroupId()
//        print("GROUP ID AFTER APPERAR \(self.groupId)")
//        if  groupId != ""  {
//            self.groupView = true
//            self.doneProfile = true
//        }else{
//            groupView = false
//        }
//        print("groupView \(groupView)")
//        print("done \(doneProfile)")


        
    }
    private func done(){
        isLoading = true
        print("done")
        
        profileViewModel.createCompleteGroup(name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, entity: entity, interactionPreference: interactionPreference, longitude: longitude, latitude: latitude, city: city, distancePreference: distance, minYear: minAge, maxYear: maxAge) { result in
            switch result {
                
            case .success(()):
                print("success")
                isLoading = false
                groupView = true
                doneProfile = true
                

            case .failure(let error):
                print(error)
            }
        }
        
    }


    
    
}

//struct GroupOrCreateGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupOrCreateGroup(completedProfile: false).environmentObject(AuthViewModel())
//    }
//}
