//
//  EditBio.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct EditBio: View {
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
    private let charLimit: Int = 150

    @Binding var bio : String
    @State private var tempBio : String = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                VStack(spacing:0){
                    HStack{
                        Text("Bio")
                        Spacer()
                    }
                    .frame(width:280)
                    HStack{
                        TextField("",text:$tempBio, axis: .vertical)
                            .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
                            .lineLimit(4)
                        
                            .padding(10)
                           



                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkPurple).shadow(radius: 5,y:5))

                            .onChange(of: tempBio, perform: {newValue in
                                    if(newValue.count >= charLimit){
                                        tempBio = String(newValue.prefix(charLimit))
                                    }
                                })
                        
                                Text("\(charLimit - tempBio.count)").foregroundColor(AppColor.lovolTan).font(.headline).bold()
                                    .padding(.trailing,5)
                        
                    }
                    .frame(width:280)

                    .padding(.horizontal,20)

                }
                .padding(.vertical,30)
                Button {
                    done()
                } label: {
                    Text("done")
                }

                        
        
                            



            }
            .onAppear(perform: fillBio)
            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Edit Bio")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func fillBio(){
        tempBio = bio
    }
    func done(){
        if tempBio.count>0{
            self.bio = tempBio
            print("BIO \(bio)")
            presentationMode.wrappedValue.dismiss()
        }
    }
    
}

struct EditBio_Previews: PreviewProvider {
    @State static var bio : String = "bio"

    static var previews: some View {
        EditBio(bio: $bio)
    }
}
