//
//  CreateGroupOccupationView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI

struct CreateGroupOccupationView: View {
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
    var name: String
    var bio : String
    var college : String
     
    @State var occupation : String
    
    @State var showWarning : Bool = false
    private let charLimit: Int = 15

    var body: some View {
        
        NavigationStack{
            GeometryReader{ geo in
                VStack{
                    Text("Team Occupation?")
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
                        .frame(alignment: .center)
                        .padding(.bottom,20)
                    ZStack{
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                            .frame(width:geo.size.width * 0.9, height:50)
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
                        .font(.custom("Rubik Regular", size: 24)).foregroundColor(AppColor.lovolDarkPurple)
                        .padding(.leading,10)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        
                        .frame(width:geo.size.width * 0.9, height:50)
                    }
                    
                    
                    Button(action:{
                    }, label: {
                        NavigationLink(destination: CreateGroupPicturesView(name: name, bio: bio, college: college, occupation: occupation)) {
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
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
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

struct CreateGroupOccupationView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupOccupationView(name: "", bio: "", college: "", occupation: "")
    }
}
