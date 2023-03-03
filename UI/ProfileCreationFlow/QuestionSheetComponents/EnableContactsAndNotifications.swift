//
//  EnableContactsAndNotifications.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/12/23.
//

import SwiftUI
import ContactsUI
import UserNotifications

struct EnableContactsAndNotifications: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.white)
                  
              }
          }
      }
    let name: String
    let role: String
    let age : Bool
    let pic : UIImage
    
    @Binding var number : String
    @State private var numberOne : String = ""
    
    @State private var contactPressed : Bool = false
    @State private var notificationPressed : Bool = false
    

    var body: some View {
        GeometryReader{geo in
            VStack{
                Spacer()
                VStack{
                    HStack{
                        Spacer()
                        Button {
                          trigger()
                        } label: {
                            Text("Enable Contacts")
                                .padding()
                                .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                                .background( RoundedRectangle(cornerRadius:30)
                                    .fill(AppColor.lovolDarkerPurpleBackground)).foregroundColor(.white)
                            
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    HStack{
                        Spacer()
                        Button {
                          registerForRemoteNotification()
                        } label: {
                            Text("Enable Notifications")
                                .padding()
                                .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                                .background( RoundedRectangle(cornerRadius:30)
                                    .fill(AppColor.lovolDarkerPurpleBackground)).foregroundColor(.white)
                            
                        }
                        
                        Spacer()
                    }
//                    Text("Please...")
//                        .font(.custom("Rubik Bold", size: 10)).foregroundColor(.white).opacity(0.6)

                }
                .padding(.bottom,40)
                Spacer()
                Button {
                    
                } label: {
//                    NavigationLink(destination: CreateJoinTeamView(name:name, role:role,pic:pic, age: age)) {
//                        Text("Next")
//                            .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)
//                        
//                            .padding()
//                            .frame(width:geo.size.width * 0.7)
//                            .background(RoundedRectangle(cornerRadius: 30).fill( AppColor.lovolDarkPurple ))
//                    }
                    
                }
                
                
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: onAppear)
    }
    private func onAppear(){
        print(number)
        var newNumber = ""
        for numbers in number.indices {
            if number[numbers] == " " || number[numbers] == "(" || number[numbers] == ")" || number[numbers] == "-" {
                continue
                
            }else{
                newNumber.append(number[numbers])
            }
        }
//        self.number = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
                self.number = newNumber
        self.numberOne = "1" + newNumber 
       
        

    }
    func registerForRemoteNotification() {
//            if #available(iOS 10.0, *) {
//                let center  = UNUserNotificationCenter.current()
//
//                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
//                    if error == nil{
//                        UIApplication.shared.registerForRemoteNotifications()
//                    }
//                }
//
//            }
//            else {
//                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
//                UIApplication.shared.registerForRemoteNotifications()
//            }
        }
    private func trigger(){
        let filter : ContactsFilter = .none
        for _ in PhoneContacts.getContacts(filter: filter) {
            break
            
        }
        
     
    }
}





//private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
//    let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Go to Settings to grant access.", preferredStyle: .alert)
//    if
//        let settings = URL(string: UIApplication.openSettingsURLString),
//        UIApplication.shared.canOpenURL(settings) {
//            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
//                completionHandler(false)
//                UIApplication.shared.open(settings)
//            })
//    }
//    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
//        completionHandler(false)
//    })
//    present(alert, animated: true)
//}
//struct EnableContactsAndNotifications_Previews: PreviewProvider {
//    static var previews: some View {
//        EnableContactsAndNotifications()
//    }
//}
