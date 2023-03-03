//
//  EditPronouns.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct EditPronouns: View {
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
    @Binding var pronouns : String
    @State private var tempPronouns : String = ""
    
    @State var pronounList : [String] = ["she/her/hers","he/him/his","they/them/theirs","ze/zir/zirs","xe/xem/xirs","sie/hir/hirs"]
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack(spacing:0){
                    HStack{
                        Text("Pronouns")
                        Spacer()
                    }
                    .padding(.leading,25)
                    RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5)
                        .frame(width:350, height:35)
                        .padding(.horizontal,20)
                        .overlay(
                            Text(tempPronouns)
                                .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
                        )
                }
                .padding(.vertical,10)
                Text("If you do not see your pronouns listed, feel free to list them in your bio.")
                    .padding(.horizontal,20)
//                    .padding(.vertical,10)
                VStack{
                    ForEach(pronounList.indices, id:\.self){ index in
                        Button {
                            choosePronoun(index: pronounList[index])
                        } label: {
                            Text(pronounList[index])
                                .padding(.vertical,5)
                        }
                        
                        
                    }
                }
                .padding(.vertical,30)

                Button {
                    done()
                } label: {
                    Image(systemName: "checkmark")
                        .background(Circle().fill(AppColor.lovolDarkPurple).frame(width:20,height:20))
                    
                }

                        
        
                            



            }
            .onAppear(perform: fillPronouns)
            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Edit Pronouns")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func fillPronouns(){
        tempPronouns = pronouns
    }
    func done(){
        pronouns = tempPronouns
        presentationMode.wrappedValue.dismiss()
    }
    func choosePronoun(index: String){
        tempPronouns = index
    }
}

struct EditPronouns_Previews: PreviewProvider {
    @State static var pronouns : String = "he/his/him"

    static var previews: some View {
        EditPronouns(pronouns:$pronouns)
    }
}
