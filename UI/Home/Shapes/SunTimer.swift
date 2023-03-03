//
//  SunTimer.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/15/22.
//

import SwiftUI

// set due date , starting date of gameshow live video, in firebase, have countdown retrieve current time, and subtract time left of date in firebase and use that to fill circle 
struct SunTimer: View {
    
    @EnvironmentObject private var profilesViewModel : ProfilesViewModel
    @EnvironmentObject private var eventViewModel : EventViewModel
    
    @EnvironmentObject private var authViewModel : AuthViewModel
    @State private var buttonLoading : Bool = true
    @State private var showGroupError : Bool = false
    @State private var groupId : String = ""
    
    
    
    @State private var newLiveEvent: LiveEventModel = LiveEventModel(startTime: Date(), isActive: false, videoURL: "", seconds: 0, beginingTime: Date(), prize: "1000", season: "0", isSelection: false)
    
    @State private var validTimer: Bool = true
    @State private var isRotating = 0.0
    @State private var scale = 1.0
    @State private var isAnimating = false
//    var animation: Animation {
//        Animation.linear
//            .repeatForever(autoreverses: false)
//
//    }
    
    var body: some View {
        
        
        GeometryReader { geo in
            
            VStack{
//                Image("logo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 56, height: 56)
//                    .clipped()
//                    .frame(width: 56, height: 56)
//                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                Spacer()

                ZStack{
                    BehindTheSunView()
                        .frame(width: geo.size.width , height: geo.size.height * 0.6)
                        .rotationEffect(.degrees(isRotating))
                                .onAppear {
                                    withAnimation(.linear(duration: 1)
                                            .speed(0.1).repeatForever(autoreverses: false)) {
                                        isRotating = 360.0
                                    }
                                }
//                                .onDisappear {
//                                    self.isRotating = 0
//                                }
                                

                    Circle()

                        .fill(.white)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        .frame(width: geo.size.width * 0.71, height: geo.size.width * 0.71)
//                        .scaleEffect(scale)
//                        .scaleEffect(isAnimated ? 1 : 1.1)
//                        .onAppear{
//                            withAnimation(.easeIn(duration:1)
//                                .speed(0.5)
//                                .repeatForever(autoreverses: false)){
//                                    isAnimated.toggle()
//                                }
//                        }
                        .scaleEffect(self.isAnimating ? 1 : 1.1)
                        .animation(Animation.easeOut(duration: 1).repeatForever(), value: isAnimating)
                        .onAppear {
                            withAnimation(Animation.easeOut(duration: 1).repeatForever()){
                                self.isAnimating = true
                            }
                        }
//                        .onDisappear {
//                            self.isAnimating = false
//                        }

                    

                }
                .overlay(
                    VStack{
                        Text(newLiveEvent.prize)
                            .font(.custom("Rubik Regular", size: 32)).foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                                
                        
                        HStack{
                            Spacer()
                            Text("\(newLiveEvent.startTime.shortTime) \(newLiveEvent.startTime.fullDate)")
                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkerPurpleBackground)
                                .multilineTextAlignment(.center)
                                .frame(width:geo.size.width * 0.7)
                            Spacer()
                        }
                    }
                )
                .padding(.bottom,50)
//                Button {
//                    
//                } label: {
//                    NavigationLink(destination: SingleEventView()) {
//                        
//                        Text("Let's go")
//                            .padding()
//                            .frame(width:geo.size.width * 0.7)
//                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkerPurpleBackground))
//                        
//                            .font(.custom("Rubik Bold", size: 16))
//                            .foregroundColor(.white)
//                    }
//                    
//                    
//                }
//                .padding(.bottom,40)
                Spacer()
                
            }

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .alert("You must be in a team to access events.", isPresented: $showGroupError, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
        }
//        .onAppear(perform: loadAccess)
    }
    private func loadAccess(){
        eventViewModel.checkLiveStatus { result in
            switch result{
            case .success(let event):
                print(event)
                validTimer = true 
                self.newLiveEvent = event
                return
        case .failure(let error):
            print("error checking lvie status \(error)")
            }

        }
    }

}

struct SunTimer_Previews: PreviewProvider {
    static var previews: some View {
        SunTimer()
    }
}

//extension UIView {
//    func pulse(withIntensity intensity: CGFloat, withDuration duration: Double, loop: Bool) {
//        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse], animations: {
//            loop = true
//            self.transform = CGAffineTransform(scaleX: intensity, y: intensity)
//        }) { (true) in
//            self.transform = CGAffineTransform.identity
//        }
//    }
//}
