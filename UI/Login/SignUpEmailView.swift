//
//  SignUpEmailView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//

import SwiftUI

struct SignUpEmailView: View {
    @Environment(\.dismiss) private var dismiss

    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""

    @State var name: String = ""
    @State private var showWarning : Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoading: Bool = false

    @State private var passwordError: Bool = false
    @State private var passwordShortError: Bool = false
    @State private var nameError: Bool = false

    
    var body: some View {
        
        GeometryReader{geo in
            VStack{
                
                
                Group{
                    VStack{
                        HStack{
                            Text("Sign up")
                                .font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
                            Spacer()
                            
                        }
                        
                        HStack{
                            Text("Name")
                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.top,15)
                        HStack{
                            TextField("", text: $name).placeholder(when: name.isEmpty) {
                                Text("Name")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.6)
                                
                            } .textContentType(.name)
                                .textInputAutocapitalization(.never)
                                .padding()
                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish)  .opacity(0.3))
                              
                        }
                        
                        
                        
                        .textInputAutocapitalization(.never)
                        
                        
                        
                        HStack{
                            Text("Email")
                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                        HStack{
                            TextField("", text: $email).placeholder(when: email.isEmpty) {
                                Text("Email")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.6)
                            } .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .padding()
                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish)  .opacity(0.3))
                        }
                        
                        
                        .textInputAutocapitalization(.never)
                        
                        HStack{
                            Text("Password")
                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            
                            Spacer()
                        }
                        HStack{
                            SecureField("", text: $password).placeholder(when: password.isEmpty) {
                                Text("Password")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.6)
                            }
                            .padding()
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish)  .opacity(0.3))
                        }
                        
                        
                        .textInputAutocapitalization(.never)
                        .textContentType(.password)
                        HStack{
                            Text("Confirm Password")
                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            
                            Spacer()
                        }
                        HStack{
                            SecureField("", text: $confirmPassword).placeholder(when: confirmPassword.isEmpty) {
                                Text("Confirm Password")
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.6)
                            }
                            .padding()
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish)  .opacity(0.3))
                        }
                        
                        
                        .textInputAutocapitalization(.never)
                        .textContentType(.password)
                        
                    }
                    Button(action: {
                        createAccount()
                    }, label: {
                        
                        Text("Sign up")
                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width:geo.size.width * 0.9)
                            .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
                    })
                    .padding(.top)
                    //                .showLoading(isLoading)
                    Button(action: dismissView) {
                        Text("Have an Account? Sign In!")
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .underline()
                    }
                    .padding(.top)
                    
                }
                .frame(width:geo.size.width * 0.9)

                
                
            }
            .frame(width:geo.size.width,height:geo.size.height)
            .background(AppColor.lovolDark)

            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .alert("This email address or password does not match.", isPresented: $showWarning, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .alert("Your password does not match.", isPresented: $passwordError, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        
        .alert("Your password must be longer than 6 letters.", isPresented: $passwordShortError, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .alert("Your name is blank.", isPresented: $nameError, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .ignoresSafeArea(.keyboard)


                


    }
    private func dismissView(){
        dismiss()
    }
    func createAccount(){
        isLoading = true
        
        if name.isEmpty{
            nameError = true
            
            return
        }
        if password != confirmPassword {
            passwordError = true
            print("passwords do not match")
            return
        }
        if  password.count < 6{
            passwordShortError = true
            print("passwords do not match")
            return
        }
                authViewModel.createAccountWithEmail(controller: getRootViewController(), name: name, email: email, password: password)
    }
}

struct SignUpEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpEmailView()
    }
}
