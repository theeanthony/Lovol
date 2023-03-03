//
//  CreateGroupNameView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/14/22.
//

import Foundation
import SwiftUI



struct CreateGroupNameView: View {
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

    @State var name : String = ""
    @State var bio : String = ""

    private let charLimit: Int = 15

    var body: some View {
        NavigationStack{
            GeometryReader {geo in
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                            .frame(width: geo.size.width * 0.8, height: 80)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        HStack{
                            TextField("", text: $name).placeholder(when: name.isEmpty) {
                                Text("Name")
                            }.onChange(of: name, perform: {newValue in
                                if(newValue.count >= charLimit){
                                    name = String(newValue.prefix(charLimit))
                                }
                                
                                
                            })
                            Text("\(charLimit - name.count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline).bold()
                                .padding(.trailing,5)
                            
                        }
                        .font(.custom("Rubik Regular", size: 24)).foregroundColor(AppColor.lovolDarkPurple)
                        .padding(.leading,10)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .frame(width: geo.size.width * 0.8, height:70)
                    }
                    
                    
                    Button(action:{
                    }, label: {
                        NavigationLink(destination: CreateGroupBioView(name: name, bio: bio) ) {
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(!checkIfName() ? AppColor.lovolTan :    Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))
                        }
                    })
                    .padding(.top,50)
                    .disabled(checkIfName())
                    
                }
                
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }


        }
            

                .frame(maxWidth:.infinity,maxHeight:.infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                )
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .navigationBarTitleDisplayMode(.inline)
                
            }
    private func checkIfName() -> Bool{
        
        if(name.count < 1){
    //            showWarning = true
            return true
        }
        return false
        
    }

    }





