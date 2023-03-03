//
//  FifthCreateView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/6/22.
//

import SwiftUI

struct FifthCreateView: View {
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
//    @State var orientation : Orientation? = nil
    @State var showWarning: Bool = false
    

//
    var body: some View {
        
        NavigationStack{
            ZStack{
                AppColor.almondBackGround.ignoresSafeArea()
                VStack{
                    ProfileSection(questions[count]){
//                        Picker("", selection: $orientation) {
//                            ForEach(Orientation.allCases, id: \.self) {
//                                Text(LocalizedStringKey($0.rawValue)).tag($0 as Orientation?)
//                            }
//                        }.pickerStyle(.segmented).frame(maxWidth: .infinity)
                        
                    }
//                    Button(action:{
//                        
//                    }, label: {
//                        NavigationLink(destination: SixthCreateView(count: count + 1, questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender, orientation: orientation ?? Orientation.both)) {
//                            
//                            Text("Continue")
//                            
//                            
//                        }
//                    })
//                    .buttonStyle(.purple)
//                    .padding()
//                    .disabled(checkOrientation())
                }
            }
        }
        .alert("Must choose orientation.", isPresented: $showWarning, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
    }
    private func checkOrientation() -> Bool {
//            if orientation == nil {
////                showWarning = true
//
//                return true
//            }
            return false
    }
}

//struct FifthCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        FifthCreateView()
//    }
//}
