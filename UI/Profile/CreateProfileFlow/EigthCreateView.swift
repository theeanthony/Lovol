//
//  EigthCreateView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/7/22.
//

import SwiftUI

struct EigthCreateView: View {
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
    var count: Int
    var questions: [String]
    var name: String
    var pronouns: String
    var bio : String
    var birthDate : Date
    var college : String
   var occupation : String
    var gender : String
    var pictures: [UIImage]
    @State var interests: [String] = []
//    @State  var filters : FilterModel = FilterModel(amountOfPeoplePreference: 4, genderPreference: 2, interactionPreference: 3, formPreference: 2, minYear: 18, maxYear: 100, maxDistance: 25)




    @State var jsonInterestHolder : [InterestsModel] = []
    @State var showWarning : Bool = false
    @State var showNeedMoreInterests : Bool = false
    @State var canContinue : Bool = false

    @State var newCount : Int = 0
    @State var currentCount : Int = 0
    @State var currentValues : [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    @State var tagCount = 0 
    let newColumns = [
       
        GridItem(.adaptive(minimum: 150, maximum: 300)),
        GridItem(.adaptive(minimum: 150, maximum: 300)),
        GridItem(.adaptive(minimum: 150, maximum: 300))


     ]
    let rows = [
        GridItem(.fixed(6))
    ]

    
    var body: some View {
        NavigationStack{

                
                VStack{
                        ProfileSection(questions[count]){
                            
                           
                                    VStack{
  
                                        LazyVGrid(columns: newColumns, spacing: 10){
                                            ForEach(interests.indices, id: \.self) { item in
                                                Button {
                                                    storeInterest(interest: interests[item])
                                                } label: {
                                                    Text(interests[item])
                                                        .font(.custom("Rubik", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                                                        .padding(1)
                                                }
                                                .buttonStyle(InterestButtonyCreateFullStyle())
                                                
                                            }
                                            
                                        }
                                        .padding(10)
                                    }
    
 

                                
 
                                
                                    
                                

                            
                            
                            ScrollView{

                            ForEach(jsonInterestHolder.indices, id: \.self) { index in
                                VStack{
                                    ProfileSection(jsonInterestHolder[index].category){
                                        
                                        VStack{
                                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 20)],spacing: 12) {
                                                ForEach(jsonInterestHolder[index].specifics, id: \.self) { item in
                                                    
                                                    if interests.contains(item){
                                                        Button {
                                                            storeInterest(interest: item)
                                                        } label: {
                                                            Text(item)
                                                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                                                                .padding(1)
                                                        }
                                                        .buttonStyle(InterestButtonyCreateFullStyle())

                                                    }
                                                    else{
                                                        Button {
                                                            storeInterest(interest: item)
                                                        } label: {
                                                            Text(item)
                                                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                                                                .padding(1)
                                                        }
                                                        .buttonStyle(InterestButtonyCreateStyle())
                                                    }
                                                }
                                                
                                            }
                                            .padding(10)
                                            
                                        }
                                        .padding(.top, 15)
                                        .padding(.bottom, 10)
                                    }
                                    
                                }
                                
                            }
                            
  
                            
                        }
                            Button(action:{
                            }, label: {
                                NavigationLink(destination: QuestionFlow(questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college:college, occupation:occupation, gender: gender, pictures: pictures, interests: interests, currentValues: $currentValues, newCount: newCount, currentCount: currentCount)) {
                                    
                                    Image(systemName:"arrow.right")
                                        .centerCropped()
                                        .frame(width: 50, height: 40)
                                    .foregroundColor(!checkForMinimumInterests() ? AppColor.lovolTan : Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))}
                            })
                            .disabled(checkForMinimumInterests())
                            .padding(.top, 30)

                            


                    }
                        .padding(.top, 10)

                        .frame(maxWidth:.infinity,maxHeight:.infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                        )
                }
 
                .alert("Need at least 3 interests", isPresented: $showNeedMoreInterests, actions: {
                    Button("OK", role: .cancel, action: {
                        
                    })
                })
                .navigationBarTitle("")
                .toolbar {
                   ToolbarItemGroup(placement: .principal) {
                       Text("Choose Interests/Hobbies")
                           .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

                   }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .navigationBarTitleDisplayMode(.inline)
   
                
//            }
        }
        .onAppear(perform: performOnAppear)
    }
    private func checkForMinimumInterests() -> Bool{
        if interests.count < 3 || interests.count > 6 {
            return true
        }
        return false


    }

    private func storeInterest(interest: String){
        var currentIndex = 0


        for item in interests
        {
            if item == interest {
                interests.remove(at: currentIndex)
                return
            }
            currentIndex += 1
        }
        if interests.count > 5 {
            return
        }
        

        interests.append(interest)
    }
    private func performOnAppear(){
        
        jsonInterestHolder = loadInterestJson()

    }

}

struct EigthCreateView_Previews: PreviewProvider {
    static let questions : [String] = ["Name...", "Who are you...?", "What is your birth date...", "What do you identify as...?", "What is your sexual preference...?", "Please upload at least 2 pictures...","What University do you attend", "What is your occupation...?", "If you have a solid friend group and never intend on using this app to find new friends, feel free to skip customizing your interests and hobbies to discover similar people.", "What are your interest/hobbies? Please choose 3-6.", "Let's dig deeper into how committed you are into your interests. Please slide the bar to how interested you are. "]
    static var previews: some View {
        EigthCreateView(count: 9, questions: questions, name: "Ant", pronouns: "", bio: "Hello", birthDate: Date(), college: "Stanford", occupation: "server", gender: "man",  pictures: [])
    }
}
//
