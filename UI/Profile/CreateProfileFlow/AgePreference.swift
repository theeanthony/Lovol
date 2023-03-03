//
//  AgePreference.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/3/22.
//

import SwiftUI

struct AgePreference: View {
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
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    
    @State private var isLoading : Bool = false
    @State private var showError : Bool = false
    @State private var showWarning : Bool = false
    
    @State private var minimumAge: Double = 0
    @State private var maximumAge: Double = 0
    var name: String
    var pronouns : String
    var bio : String
    var birthDate : Date
    var college : String
   var occupation : String
    var gender : String
   
    var pictures: [UIImage]
    var interests: [String]
    var currentValues : [Int]
    var leftAnswers : [String]
    var rightAnswers : [String]
    var ownQuestions : [String]
    var answers : [Int]
    var typeOfEntity : Int
    var interactionPreference : Int
    var longitude : Double
    var latitude : Double
    var city : String
    var distance : Double
    
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColor.lovolTan)
                            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.1)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        VStack{
                            Text("Set Age Preference.")
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                                .padding(.bottom,5)
                            
                        }
                        
                        .padding(20)
                        .textInputAutocapitalization(.never)
                        .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.2)                    }
                    
                    
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColor.lovolTan)
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.35)
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
                        createAccount()
                    }, label: {
                        
                        Text("Finish")
                            .frame(width: 80, height: 50)
                            .foregroundColor(!checkForInequality() ? AppColor.lovolTan : Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))
                            .font(.custom("Rubik Bold", size: 24)).foregroundColor(AppColor.lovolDarkPurple)
                        
                        
                    })
                    .padding(.top,50)
                    .disabled(checkForInequality())
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Choose Age")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .showLoading(isLoading)
        }
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
    private func createAccount(){
        isLoading = true
        print("Finish crreating account")
        firestoreViewModel.createUserProfile(name: name, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender, pictures: pictures, interests: interests, currentValues: currentValues, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, typeOfEntity: typeOfEntity, interactionPreference: interactionPreference, longitude: longitude, latitude: latitude, city: city, distance: distance, minAge: Int(minimumAge) + 18 , maxAge: Int(maximumAge) + 18, pronouns: pronouns, onCompletion: { result  in
            isLoading = false
            switch result{
            case .success():
                self.authViewModel.signIn()
                isLoading = false
            return
            case .failure(_):
                self.showError = true
                isLoading = false

            return
            }
        })
    }
}

struct AgePreference_Previews: PreviewProvider {
    static var previews: some View {
        AgePreference(name: "", pronouns: "", bio: "", birthDate: Date(), college: "", occupation: "", gender: "", pictures: [], interests: [], currentValues: [], leftAnswers: [], rightAnswers: [], ownQuestions: [], answers: [], typeOfEntity: 0, interactionPreference: 0, longitude: 0, latitude: 0, city: "", distance: 0)
    }
}
