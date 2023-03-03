//
//  EditMottoView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/1/23.
//

import Foundation


import SwiftUI

struct EditMottoView: View {
    @Binding var name : String
    @State private var charLimit : Int = 50
//    @Binding var isTeam : Bool
    
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
    @State private var isPresented : Bool = false
    var body: some View {
        GeometryReader{ geo in
            
            VStack{
                Spacer()
                HStack{
                    Text("Team Motto")
                        .font(.custom("Rubik Regular", size: 12))
                        .foregroundColor(.white)
                        .padding(10)
                    Spacer()
                }
                
                .padding(.leading,5)
                
                HStack{
                    TextField("", text: $name, axis:.vertical).placeholder(when: name.isEmpty) {
                        Text("Team Motto").opacity(0.5).foregroundColor(.white)
                    }.onChange(of: name, perform: {newValue in
                        if(newValue.count >= charLimit){
                            name = String(newValue.prefix(charLimit))
                        }
                    })
                    .font(.custom("Rubik Regular", size: 16))
                    .foregroundColor(.white)
                    Text("\(charLimit - name.count)").foregroundColor(.white).font(.headline).bold()
                        .padding(.trailing,5)
                    
                }
                .padding(10)
                .background(AppColor.lovolDarkPurple.opacity(0.3))
                .lineLimit(1)

                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()

                } label: {
                    Text("Done")
                        .font(.custom("Rubik Bold", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width:geo.size.width * 0.7)
                        .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                }
                Spacer()
            }
            .overlay(
            
                VStack{
                    HStack{
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName:"xmark").foregroundColor(.white)
                        }

                        Spacer()
                    }
                    Spacer()
                })
            .padding()
     
            
            
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            .background(BackgroundView())

            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        
          
            
            
        }
    }
            
            
        
}
struct EditMottoView_Previews: PreviewProvider {
    @State static var name : String = "a long description toshow how it looks like when i"

    static var previews: some View {
        EditMottoView(name: $name)
    }
}
