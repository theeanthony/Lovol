//
//  GroupAgeView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI

struct GroupAgeView: View {
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
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var minimumAge: Double = 0
    @State private var maximumAge: Double = 0
    @State private var isLoading : Bool = false
    @State private var showWarning : Bool = false
    
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
    
    @State var doneProfile : Bool = false
    @State var groupView :Bool = false
    var body: some View {
//        NavigationStack{
        GeometryReader{ geo in
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColor.lovolTan)
                        .frame(width: geo.size.width * 0.8, height: geo.size.height*0.1)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                    VStack{
                        Text("Set Age Preference.")
                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                            .padding(.bottom,5)
                        
                    }
                    
                    .padding(20)
                    .textInputAutocapitalization(.never)
                   
                }
                
                
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColor.lovolTan)
                            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.4)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        VStack{
                            Text("Minimum Age: \(String(format: "%.0f", minimumAge+18))")
                                .font(.custom("Rubik Bold", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                                .padding(.bottom,10)
                            SliderView2(value: $minimumAge)
                                .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.035)
                            HStack{
                                Text("18")
                                Spacer()
                                Text("100")
                            }
                            .padding(.horizontal,45)
                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                            Text("Maximum Age: \(String(format: "%.0f", maximumAge+18))")
                                .font(.custom("Rubik Bold", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                                .padding(.bottom,10)
                            SliderView2(value: $maximumAge)
                                .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.035)
                              
                            
                            HStack{
                                Text("18")
                                Spacer()
                                Text("100")
                            }
                            .padding(.horizontal,45)
                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                            Button {
                                reset()
                            } label: {
                                Text("Reset")
                                    .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                            }

                           
                        }
                    }
                    
                    
                    
                    
                }
                
                Button(action:{
                }, label: {
                    NavigationLink(destination: GroupOrCreateGroup( name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, entity: entity, interactionPreference: interactionPreference, longitude: longitude, latitude: latitude, city: city, distance: distance, minAge: Int(minimumAge) , maxAge: Int(maximumAge),doneProfile: $doneProfile, groupView: $groupView)){
                        Text("Finish")
                            .foregroundColor(!checkForInequality() ? AppColor.lovolTan : Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))
                            .font(.custom("Rubik Bold", size: 20)).foregroundColor(AppColor.lovolTan)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        done()
                    })
                    
                    
                    .frame(width: 100, height: 40)
                    
                    
                    
                })
                .padding(.top,50)
                .disabled(checkForInequality())
            }
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

        }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Choose Age")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .showLoading(isLoading)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Failure creating group profile, please try again", isPresented: $showWarning, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })

        
    }
    private func reset () {
        minimumAge = 0.0
        maximumAge = 0.0
    }
    private func checkForInequality() -> Bool {
        if maximumAge >= minimumAge {
            return false
        }
        else{
            return true
        }
        
    }
    private func done(){
        isLoading = true
        print("done")
        doneProfile = true
        
        profileViewModel.createCompleteGroup(name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, entity: entity, interactionPreference: interactionPreference, longitude: longitude, latitude: latitude, city: city, distancePreference: distance, minYear: Int(minimumAge), maxYear: Int(maximumAge)) { result in
            switch result {
                
            case .success(()):
                print("success")
                isLoading = false
                groupView = true

                doneProfile = false
                presentationMode.wrappedValue.dismiss()
                

            case .failure(let error):
                print(error)
            }
        }
        
    }

}

struct GroupAgeView_Previews: PreviewProvider {
    @State static var ownLeftExamples : [String] = []
    @State static var ownRightExamples : [String] = []
    @State static var makeOwnQuestion : [String] = []
    @State static var ownAnswers : [Int] = []
    static var previews: some View {
        GroupAgeView(name: "", bio: "", college: "", occupation: "", pictures: [], interests: [],leftAnswers: ownLeftExamples, rightAnswers: ownRightExamples, ownQuestions: makeOwnQuestion, answers: ownAnswers, entity: 0, interactionPreference: 0, longitude: 0, latitude: 0, city: "", distance: 0)
    }
}
