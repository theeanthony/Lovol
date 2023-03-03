//
//  OccupationCreateView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/8/22.
//

import SwiftUI

struct OccupationCreateView: View {
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
    @State var occupation : String = ""
    
    @State var showWarning : Bool = false
    private let charLimit: Int = 20

    var body: some View {
        
        NavigationStack{
            GeometryReader { geo in
                VStack{
                    Text("You can be anything you want to be... <3")
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                        .frame(alignment: .center)
                        .padding(.bottom,20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                            .frame(width: geo.size.width * 0.85, height:60)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        HStack{
                            TextField("", text: $occupation).placeholder(when: occupation.isEmpty) {
                                Text("Current or Fantasy Job")
                            }.onChange(of: occupation, perform: {newValue in
                                if(newValue.count >= charLimit){
                                    occupation = String(newValue.prefix(charLimit))
                                }
                                
                                
                            })
                            Text("\(charLimit - occupation.count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline).bold()
                                .padding(.trailing,5)
                            
                        }
                        .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                        .padding(.leading,10)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        
                        .frame(width: geo.size.width * 0.8, height: 60)                    }
                    
                    
                    Button(action:{
                    }, label: {
                        NavigationLink(destination: FourthCreateView(count: count + 1, questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation)) {
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(!checkOccupation() ? AppColor.lovolTan :    Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))
                            
                            
                        }
                    })
                    .padding(.top,50)
                    .disabled(checkOccupation())
                    
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
                   Text("Choose Occupation")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            
        }
    

    }

    private func checkOccupation() -> Bool {
        if occupation.count < 1 || occupation.count > 15 {
//            showWarning = true
            return true
        }
        return false
    }
 
}
struct OccupationCreateView_Previews: PreviewProvider {
    
    static let questions : [String] = ["Name...", "Who are you...?", "What is your birth date...", "What University do you attend", "What is your occupation...?", "What do you identify as...?", "What is your sexual preference...?", "Please upload at least 2 pictures...", "If you have a solid friend group and never intend on using this app to find new friends, feel free to skip customizing your interests and hobbies to discover similar people.", "What are your interest/hobbies? Please choose 3-6.", "Let's dig deeper into how committed you are into your interests. Please slide the bar to how interested you are. "]
    static var previews: some View {
        OccupationCreateView(count: 4, questions: questions, name: "", pronouns: "", bio: "", birthDate: Date(), college: "")
    }
}

