//
//  InviteFriendsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/17/23.
//

import SwiftUI

struct InviteFriendsLabelView: View {
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @State private var urlString : URL = URL(string: "https://lovol.page.link")!
    
    @State private var isPresented : Bool = false

    let groupId : String
    let teamName : String
    var body: some View {
        
            VStack{
                VStack{
                    HStack{
                        Text("Invite friends to get extra")
                            .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                        Spacer()
                    }
                    HStack{
                        Text("Lovol Bits")
                            .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,5)
                    HStack{
                        Text("Invite a friend to get 10 extra Lovol Bits for")
                            .font(.custom("Rubik Regular", size: 11)).foregroundColor(.white).opacity(0.8)
                        Spacer()
                    }
                    HStack{
                        Text("your team")
                            .font(.custom("Rubik Regular", size: 11)).foregroundColor(.white).opacity(0.8)
                        Spacer()
                    }
                    .padding(.bottom,5)
                    HStack{
                        Spacer()
                        Text("Invitation code: ")
                            .font(.custom("Rubik Regular", size: 11)).foregroundColor(.white).opacity(0.8)
                        Button {
                            UIPasteboard.general.string = groupId
                            
                        } label: {
                            Text("\(groupId)")
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                            Image(systemName:"doc.on.clipboard.fill").foregroundColor(.white)
                        }
                        
                        
                        
                        Spacer()
                    }
                }.padding(.leading,15)
                HStack {
                    Spacer()
                    Button(action: {
                        let activityVC = UIActivityViewController(activityItems: [urlString], applicationActivities: nil)
                        print("URL STRING IN BUTTON \(urlString)")
                        DispatchQueue.main.async {
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                                if let rootVC = window.rootViewController {
                                    rootVC.present(activityVC, animated: true, completion: nil)
                                } else {
                                    window.rootViewController = UIViewController()
                                    window.rootViewController?.present(activityVC, animated: true, completion: nil)
                                }
                            }
                        }
                    }, label: {
                        Text("Invite")
                            .font(.custom("Rubik Regular", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal,60)
                            .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                    })
                    .contentShape(RoundedRectangle(cornerRadius: 30))
                    Spacer()
                }




                
            }
            .background(AppColor.lovolDark)


        .onAppear(perform: onAppear)
//        .background(AppColor.lovolDark)
        
      
    }
    private func onAppear() {
        firestoreViewModel.shareTapped(groupId) { url in
            DispatchQueue.main.async {
                self.urlString = url
            }
        }
    }
}
//
//struct InviteFriendsLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        InviteFriendsLabelView(groupId: "")
//    }
//}
