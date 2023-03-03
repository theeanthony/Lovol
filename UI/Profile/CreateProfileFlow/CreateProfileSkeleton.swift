//
//  CreateProfileSkeleton.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/5/22.
//

import SwiftUI



struct CreateProfileSkeleton: View {
    
    @State var count : Int = 0
    @State var questions : [String] = ["Name...", "Who are you...?", "What is your birth date...", "What University do you attend", "What is your occupation...?", "What do you identify as...?",  "Please upload 3 pictures...",  "What are your interest/hobbies? Please choose 3-6."]
    
//    @State private var gameExplanation : [String] = ["Welcome to Lovol! A gameshow for you and your friends.", "Team up with your friends, or find new friends to complete monthly events to earn lovol bits!", "Lovol bits can be exchanged for Lovols, which are used to increase your teams chances of entering the monthly gameshow.", "Win the gameshow, and you and your team will win a prize!", "You and your team will be competing against other teams around you, so choose your team wisely and have fun!"]
    @State private var gameExplanation : [String] = ["Burh Jst start", "1"]
    @State private var gameCount : Int = 0
    var body: some View {
        NavigationStack{
            
            GeometryReader { geo in
                
                VStack{
                    HStack{
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 56, height: 56.2)
                            .clipped()
                            .frame(width: 56, height: 56.2)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        Text("lovol").font(.custom("Rubik Regular", size: 70)).foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 1))).tracking(4.2).multilineTextAlignment(.center)
                            .textCase(.uppercase).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                    }
                    
                    Text("\(gameExplanation[gameCount % gameExplanation.count ])")
                        .padding()
                        .background(AppColor.lovolTan)
                        .cornerRadius(20.0)
                        .padding(.bottom, 20)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .foregroundColor(AppColor.lovolDarkPurple)
                        .font(.custom("Rubik Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .frame(width: geo.size.width * 0.85, height:geo.size.height * 0.3)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                    
                    
                    if gameCount != gameExplanation.count - 1  {
                        Button(action: {
                            gameCount += 1
                        }, label: {
    
                                HStack{
                                    
                                    Text("Next")
                                        .padding()
                                        .font(.custom("Rubik Regular", size: 14))
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                    
                                }
                        })
                        .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                    }else{
                        Button(action: {
                            
                        }, label: {
//                            NavigationLink(destination:  Over21View()){
                                
                                HStack{
                                    
                                    Text("Start")
                                        .padding()
                                        .font(.custom("Rubik Regular", size: 14))
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                    
                                }
//                            }
                        })
                        .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                    }

                    
                }
               
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)


            }
            
                          .frame(maxWidth:.infinity,maxHeight:.infinity)
                          .background(
                              LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                          )
                
        }
 
    }

}

struct CreateProfileSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileSkeleton()
    }
}

extension UIView {


    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 1.0
        }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
        self.alpha = 0.0
        }, completion: completion)
}

}
