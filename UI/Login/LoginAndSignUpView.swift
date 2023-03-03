//
//  LoginAndSignUpView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//

import SwiftUI

struct LoginAndSignUpView: View {

    var body: some View {
        
        ZStack {
            LoginView() {
                
                NavigationLink("New User? Sign Up!", destination: SignUpEmailView())
                    .font(.custom("Rubik Regular", size: 14)).underline().foregroundColor(.white).multilineTextAlignment(.center)
                   

//                    .hiddenNavigationBarStyle()
//                    .navigationTitle("")
//                    .navigationBarHidden(true)

            }
        }
        
    }
}

struct LoginAndSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAndSignUpView()
    }
}
