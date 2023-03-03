//
//  BonusMusicEvent.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import SwiftUI
import AVKit

struct BonusMusicEvent: View {
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
//    @State private var musicEvent : BonusMusicVideo = BonusMusicVideo(name: "", description: "", rules: "", type: "", choices: [], example: "",points:0)
    @State private var musicEvent : BonusMusicVideo = BonusMusicVideo(name: "Musical Vibration", description: "Make a music video with your squad! Choose from any of the songs provided. ", rules: "Every member must be included.There must be at least 60 seconds of content ", type: "", choices: ["A this is a coool song by Anthony","B","C","D","E","F","G","H","I"], example: "", points: 100)
    @State private var isPresented : Bool = false
    @State private var videoURL : String = ""
    var body: some View {
        NavigationStack{
            VStack{
                
                VStack{
                    EventLabel(labelHeader: "Name", labelContent: musicEvent.name)
                    EventLabel(labelHeader: "Description", labelContent: musicEvent.description)
                    EventLabel(labelHeader: "Rules", labelContent: musicEvent.rules)
                    
                    BonusChoicesView(musicEvent: musicEvent, choices: musicEvent.choices)
                        .padding(.top,10)
                    ExampleVideoFrame(isPresented: $isPresented)
                        .fullScreenCover(isPresented: $isPresented) {
                            ExampleVideoView(player: AVPlayer(url: URL(string: videoURL)!), isPresented: $isPresented)
                        }
                        .padding(.top,20)
                    

                }
                .frame(height:630)
//                .padding()
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

struct BonusMusicEvent_Previews: PreviewProvider {
    static var previews: some View {
        BonusMusicEvent()
    }
}
