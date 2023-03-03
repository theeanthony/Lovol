//
//  FinishGroupCreationView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/14/22.
//

import SwiftUI

struct FinishGroupCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var profileViewModel : ProfilesViewModel 
    
//
    var name: String
//    var bio : String
//    var college : String
//   var occupation : String
//    var pictures: [UIImage]
//    var interests: [String]
//    var leftAnswers : [String]
//    var rightAnswers : [String]
//    var ownQuestions : [String]
//    var answers : [Int]
//    var entity : Int
//    var interactionPreference : Int
//    var longitude : Double
//    var latitude : Double
//    var city : String
//    var distance: Double
//    var minAge : Int
//    var maxAge : Int
//
//    @Binding var doneProfile : Bool
//    @Binding var groupView : Bool
    
    @State private var tips : [String] = ["If you are a team of 6, your points get multiplied times 2!", "When team swipe is on, the team member who activated it has control.","Make sure to have everyone in your team in the picture for it to count!", "Quality over quantity", "Make sure to have everyone grouped around for team swiping!", "You can exchange 100 lovol bits for one lovol", "Does a team's event submission look sus? Downvote it."]
    
    @State private var isLoading : Bool = false
    
    @State private var index : Int = 0
    var body: some View {
        VStack{
            
//            if !doneProfile{
                GeometryReader{ geo in
                    VStack(spacing: 20){
                        
                        Text("\(name) is being created... This might honestly take a bit, it's your team pictures that is taking a while to upload... Please stay on this screen until your profile shows up or you may have to redo everything! Sorry.")
                            .multilineTextAlignment(.center)
                            .font(.custom("Rubik Regular", size: 15)).foregroundColor(AppColor.lovolDarkPurple)
                            .frame(width: geo.size.width * 0.8)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                        
                        Text("Tips:")
                            .font(.custom("Rubik Bold", size: 15))
                            .foregroundColor(AppColor.lovolTan)
//                        ForEach(tips.indices, id: \.self) { index in

          
                        Text(tips[index])
                                .font(.custom("Rubik Regular", size: 15))
                                .foregroundColor(AppColor.lovolTan)
                                .frame(width: geo.size.width * 0.8)
                                .multilineTextAlignment(.center)
                                .frame(width:geo.size.width * 0.8, height: geo.size.height * 0.1)
                     

//                        }
     
                        
                        
                    }
                    .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)


                }
//            }
//            else{
//                GroupProfileView(groupView:$groupView)
//
//            }
 

        }
        .navigationBarBackButtonHidden(true)

        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
        )
        .showLoading(isLoading )
        .onAppear(perform: performOnAppear)

    }
    private func performOnAppear(){
        self.index = tips.startIndex

        _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            
            self.index = tips.index(after: index)
            if index == tips.endIndex  { self.index = 0 }
          }
           
  
        }


    
//    private func done(){
//        isLoading = true
//        print("done")
//
//        profileViewModel.createCompleteGroup(name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, entity: entity, interactionPreference: interactionPreference, longitude: longitude, latitude: latitude, city: city, distancePreference: distance, minYear: minAge, maxYear: maxAge) { result in
//            switch result {
//
//            case .success(()):
//                print("success")
//                isLoading = false
//                doneProfile = true
////                groupView = true
//                presentationMode.wrappedValue.dismiss()
//
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//    }


}

struct FinishGroupCreationView_Previews: PreviewProvider {
    @State static var doneProfile : Bool = false
    @State static var groupView : Bool = false

    static var previews: some View {
        FinishGroupCreationView(name: "Team")
//        FinishGroupCreationView(name: "Team", bio: "", college: "", occupation: "", pictures: [], interests: [], leftAnswers: [], rightAnswers: [], ownQuestions: [], answers: [], entity: 0, interactionPreference: 0, longitude: 0, latitude: 0, city: "", distance: 0, minAge: 0, maxAge: 0, doneProfile: $doneProfile, groupView: $groupView)
    }
}
