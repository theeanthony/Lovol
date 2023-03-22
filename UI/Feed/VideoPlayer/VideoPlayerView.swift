//
//  VideoPlayerView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/20/23.
//


//import SwiftUI
//import AVFoundation
//
//struct VideoPlayerView: UIViewRepresentable {
//    var videoURL: URL
//
//    func makeUIView(context: Context) -> UIView {
//        let player = AVPlayer(url: videoURL)
//        let playerLayer = AVPlayerLayer(player: player)
//        let view = UIView()
//        view.layer.addSublayer(playerLayer)
//        player.play()
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//    }
//}
import SwiftUI
// 1
import AVKit

// 2
struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        
        if let player = player {
               player.playImmediately(atRate: 1.0) // Autoplay the video
               controller.player = player
           }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the view controller if needed
    }
}
