//
//  EditOccupation.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct EditOccupation: View {
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
    private let charLimit: Int = 15
    @State private var tempOccupation : String = ""
    @Binding var occupation : String
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack(spacing:0){
                    HStack{
                        Text("Occupation")
                        Spacer()
                    }
                    .padding(.leading,25)
                    HStack{
                        TextField("",text:$tempOccupation)
                            .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5))
                            .padding(.leading,20)
                            .onChange(of: tempOccupation, perform: {newValue in
                                    if(newValue.count >= charLimit){
                                        tempOccupation = String(newValue.prefix(charLimit))
                                    }
                                    
                                    
                                })
                                Text("\(charLimit - tempOccupation.count)").foregroundColor(AppColor.lovolTan).font(.headline).bold()
                                    .padding(.trailing,10)

                    }
                }
                .padding(.vertical,30)
                Button {
                    done()
                } label: {
                    Text("done")
                }

                        
        
                            



            }
            .onAppear(perform: fillOccupation)
            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Edit Occupation")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func fillOccupation(){
        tempOccupation = occupation
    }
    func done(){
        self.occupation = tempOccupation
        presentationMode.wrappedValue.dismiss()
    }

}

struct EditOccupation_Previews: PreviewProvider {
    @State static var occupation : String = "bio"

    static var previews: some View {
        EditOccupation(occupation:$occupation)
    }
}
