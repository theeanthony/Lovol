//
//  PronounsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct PronounsView: View {
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
    @State private var pronouns : String = ""
    @State private var showWarning : Bool = false
    @State var pronounList : [String] = ["she/her/hers","he/him/his","they/them/theirs","ze/zir/zirs","xe/xem/xirs","sie/hir/hirs","none"]
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                VStack{
                    VStack(spacing:0){
                        HStack{
                            Text("Pronouns")
                            Spacer()
                        }
                        .frame(width: geo.size.width * 0.7)
                        .padding(.leading,25)
                        RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolTan).shadow(radius: 5,y:5)
                            .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.06)
                            .overlay(
                                Text(pronouns)
                                    .foregroundColor(AppColor.lovolDarkPurple)
                                    .font(.custom("Rubik Regular", size: 18))
                            )
                    }
                    .padding(.vertical,10)
                    Text("If you do not see your pronouns listed, feel free to list them in your bio.")
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                        .frame(width: geo.size.width * 0.7, height:geo.size.height * 0.1)

                    //                    .padding(.vertical,10)
                    VStack{
                        ForEach(pronounList.indices, id:\.self){ index in
                            Button {
                                choosePronoun(index: pronounList[index])
                            } label: {
                                Text(pronounList[index])
                                    .padding(.vertical,10)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(pronouns == pronounList[index] ? AppColor.lovolPrettyPurple : AppColor.lovolTan).frame(width:geo.size.width * 0.35).shadow(radius: 5,y:5))
                                    .padding(.vertical,5)
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(pronouns == pronounList [index] ? AppColor.lovolTan : AppColor.lovolDarkPurple)
                                
                                
                            }
                            
                            
                        }
                    }
//                    .padding(.vertical,30)
                    
                    Button(action:{
                    }, label: {
                        
                        NavigationLink(destination: SecondCreateView(count: count, questions: questions, name: name, pronouns: pronouns, bio: "")) {
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(!checkFill() ? AppColor.lovolTan :    Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))
                        }
                        
                        
                        
                    })
                    .disabled(checkFill())
                    
                    
                    
                    
                    
                    
                    
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Choose Pronouns")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func checkFill()->Bool{
        
        return pronouns.isEmpty
        
    }
    func choosePronoun(index: String){
        pronouns = index
    }
}

struct PronounsView_Previews: PreviewProvider {
    static var previews: some View {
        PronounsView(count: 0, questions: [], name: "")
    }
}
