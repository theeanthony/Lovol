//
//  LiveShow.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import SwiftUI
import AVKit

struct LiveShow: View {
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
    var videoURL : String 
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                VStack{
                    VStack(spacing:100){
                        Text("A live viewing is currently being broadcasted")
                            .frame(width:200)
                            .font(.custom("Rubik Regular", size: 16))
                            .foregroundColor(AppColor.lovolTan)
                            .padding()
                            .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolPinkish).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                        
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text("Tune in")
                                .padding()
                                .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                                .font(.custom("Rubik Regular", size: 16))
                                .foregroundColor(AppColor.lovolPinkish)
                        }
                    }
//                    .frame(width: geo.size.width * 0.95, height:geo.size.height * 0.98)
                    .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple).opacity(0.5) .frame(width: geo.size.width * 0.95, height:geo.size.height * 0.98))
                    .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                    
                }
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .fullScreenCover(isPresented: $isPresented) {
                ExampleVideoView(player: AVPlayer(url: URL(string: videoURL)!), isPresented: $isPresented)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
        }
    }
}

struct LiveShow_Previews: PreviewProvider {
    static var previews: some View {
        LiveShow( videoURL: "")
    }
}
