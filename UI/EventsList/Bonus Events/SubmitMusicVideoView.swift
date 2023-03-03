//
//  SubmitMusicVideoView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/21/22.
//

import SwiftUI

struct SubmitMusicVideoView: View {
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
    var musicEvent : BonusMusicVideo
    var index : Int
    var body: some View {
        NavigationStack{
            VStack{
                
                VStack{
                    EventLabel(labelHeader: "Song/Artist", labelContent: musicEvent.choices[index])
                    EventLabel(labelHeader: "Description", labelContent: musicEvent.description)
                    EventLabel(labelHeader: "Rules", labelContent: musicEvent.rules)
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Submit")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                            .foregroundColor(AppColor.lovolPinkish)
                            .font(.custom("Rubik Regular", size: 16))
                    }

                }
                .frame(height:630)
                .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple).opacity(0.5).frame(width:325,height:680))
                .padding()
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("\(musicEvent.points) lovols")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
        }
    }
}

struct SubmitMusicVideoView_Previews: PreviewProvider {
   static var musicEvent : BonusMusicVideo = BonusMusicVideo(name: "Musical Vibration", description: "Make a music video with your squad! Choose from any of the songs provided. ", rules: "Every member must be included.There must be at least 60 seconds of content ", type: "", choices: ["A this is a coool song by Anthony","B","C","D","E","F","G","H","I"], example: "", points: 100)
    static var index : Int = 0
    static var previews: some View {
        SubmitMusicVideoView( musicEvent: musicEvent, index: index)
    }
}
