//
//  LoginView.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//
 
import SwiftUI

struct LoginView<Footer:View>: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ViewBuilder let footer: () -> Footer
    
    
    @State private var isLoading: Bool = false

    @State var email: String = ""
    @State var password: String = ""
    @State var showWarning : Bool = false
    var body: some View {
        
        NavigationStack{
            GeometryReader{geo in
                
                VStack{
                    
                    VStack{
                        HStack{
                            Text("Sign in")
                                .font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
                            
                            Spacer()
                        }
                        VStack{
                            HStack{
                                Text("Email")
                                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                Spacer()
                                
                            }
                            HStack{
                                TextField("", text: $email).placeholder(when: email.isEmpty) {
                                    Text("Email")
                                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white).opacity(0.6)
                                } .textContentType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled(true)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolPinkish).opacity(0.3))
                            }
                            
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            
                        }
                        .padding(.top)
                        VStack{
                            HStack{
                                Text("Password")
                                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                
                                Spacer()
                            }
                            HStack{
                                SecureField("", text: $password).placeholder(when: password.isEmpty) {
                                    Text("Password")
                                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white).opacity(0.6)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolPinkish).opacity(0.3))
                                
                            }
                            
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                            .textContentType(.password)
                        }
                        Button(action: {
                            signIn()
                        }, label: {
                            
                            Text("Sign in")
                                .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                                .frame(width:geo.size.width * 0.9)
                                .padding(.vertical)
                                .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolPinkish))
                            
                        })
                        .padding(.top)
                        .showLoading(isLoading)
                        .alert("This email address or password does not match.", isPresented: $showWarning, actions: {
                            Button("OK", role: .cancel, action: {
                                isLoading = false
                            })
                        })
                        
                        
                        footer()
                            .padding(.top)

                        
//                        LoginSignUpButton(action: {
//                            
//                        }, iconName: "applelogo", input: "Sign In with Apple")
//                        LoginSignUpButton(action: {
//                            
//                        }, iconName: "g.circle", input: "Sign In with Google")
                    }
                    .frame(maxWidth:geo.size.width * 0.9)

                    
                }
                .frame(maxWidth:geo.size.width  ,maxHeight:geo.size.height)
                .background(AppColor.lovolDark)

                .ignoresSafeArea(.keyboard)
                
            }


        }

    }
    func signIn(){
        isLoading = true
        authViewModel.signInWithEmail(controller: getRootViewController(), email: email, password: password) { result in
            switch result {
            case .success(()):
                print("success logging in")
                isLoading = false
            case .failure(let error):
                print("\(error)")
                showWarning = true
                isLoading = false
                
            }
        }
    }
    
}



extension View{
    func getRootViewController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        return root
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(footer: {})
    }
}
