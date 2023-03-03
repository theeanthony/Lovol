//
//  SignUpView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
     
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack{
            VStack{
   
                NavigationLink(destination: SignUpEmailView()){
                    ZStack{
                        RoundedRectangle(cornerRadius: 40)
                            .fill(AppColor.lovolTan)
                        .frame(width: 300, height: 45)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        HStack{
                            Image(systemName: "envelope.fill").font(.system(size: 15, weight: .bold)).foregroundColor(AppColor.lovolDarkPurple)
                            Text("Sign Up With Email").foregroundColor(AppColor.lovolDarkPurple)
                        }
                    }
                    
                }
                
//                LoginSignUpButton(action: {
//
//                }, iconName: "applelogo", input: "Sign Up with Apple")
//                LoginSignUpButton(action: {
//
//                }, iconName: "g.circle", input: "Sign Up with Google")
                
                .padding(.bottom,15)
                
                Button(action: dismissView) {
                    Text("Have an Account? Sign In!")
                        .font(.custom("Source Sans Pro Regular", size: 16)).underline().foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 1))).multilineTextAlignment(.center)
                }
                
                //HAVE VIRTUAL PREFERENCES AND DISTANCE PREFERNCES AS ONE OR THE OTHER NOT BOHT
                //AND CHOOSE LOCATION NOT TRACKING LOCATION
                
                
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                AppColor.lovolNavyBlue
            )
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
            
        }
    private func dismissView(){
        dismiss()
    }
    
    
}




struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
