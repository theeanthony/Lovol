//
//  LoginEmailView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//

import SwiftUI


struct LogInEmailView: View {
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
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoading: Bool = false

    @State var email: String = ""
    @State var password: String = ""
    @State var showWarning : Bool = false
    var body: some View {

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
            
            ZStack{
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                    .frame(width: 300, height: 55)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                HStack{
                    TextField("", text: $email).placeholder(when: email.isEmpty) {
                        Text("Email")
                    } .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .padding()
                }
                
                .font(.custom("Rubik Regular", size: 24)).foregroundColor(AppColor.lovolDarkPurple)
                .padding(.leading,10)
                .textInputAutocapitalization(.never)
                
                .frame(width: 290, height: 55)
            }
            .padding(.bottom,15)
            ZStack{
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                    .frame(width: 300, height: 55)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                HStack{
                    SecureField("", text: $password).placeholder(when: password.isEmpty) {
                        Text("Password")
                    }
                    .padding()
                }
                
                .font(.custom("Rubik Regular", size: 24)).foregroundColor(AppColor.lovolDarkPurple)
                .padding(.leading,10)
                .textInputAutocapitalization(.never)
                .textContentType(.password)
                .frame(width: 290, height: 55)
            }
            
            
            Button(action: {
                signIn()
            }, label: {
                
                Image(systemName:"arrow.right")
                    .centerCropped()
                    .frame(width: 50, height: 40)
                    .foregroundColor( AppColor.lovolTan)
            })
            .padding(.top,50)
//            .showLoading(isLoading)
            .alert("This email address or password does not match.", isPresented: $showWarning, actions: {
                Button("OK", role: .cancel, action: {
                    isLoading = false 
                })
            })
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)


    }


    func signIn(){
        isLoading = true
        authViewModel.signInWithEmail(controller: getRootViewController(), email: email, password: password) { result in
            switch result {
            case .success(()):
                print("success logging in")
            case .failure(let error):
                print("\(error)")
                showWarning = true
                
            }
        }
    }


}

struct LogInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        LogInEmailView()
    }
}

