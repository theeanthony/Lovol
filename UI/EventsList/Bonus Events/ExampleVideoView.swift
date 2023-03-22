//
//  ExampleVideoView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import SwiftUI
import AVKit

struct ExampleVideoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

//    @State private var selectedVideo: Video?
//    let player = AVPlayer (url: URL(string: "https://joy1.videvo.net/videvo_files/video/free/2014-12/large_watermarked/videvostock009_preview.mp4")!)
    let player : AVPlayer
    var body: some View {
        
            VStack{
//                HStack{
//                    Button {
//
//                        isPresented.toggle()
//                        presentationMode.wrappedValue.dismiss()
//
//                    } label: {
//                        Image(systemName: "xmark")
//                            .resizable()
//                            .frame(width:20,height:20)
//                    }
//                    Spacer()
//                }
//                .frame(width:300, height:10)
                VideoPlayer(player: player)
                
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                    .onAppear{
                        player.play()
                    }


            }
            .edgesIgnoringSafeArea(.all)



        
//            .frame(height: 300)
        
    }
    
}

//struct ExampleVideoView_Previews: PreviewProvider {
//    
//    @State static var isPresented : Bool = false
//    static var previews: some View {
//        ExampleVideoView(player: AVPlayer (url: URL(string: "https://joy1.videvo.net/videvo_files/video/free/2014-12/large_watermarked/videvostock009_preview.mp4")!), isPresented: $isPresented)
//    }
//    
//}
