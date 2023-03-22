//
//  EventDescriptionView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct EventDescription: View {
    @Binding var eventDescription : String
    @FocusState private var isFocused: Bool // new property to track focus state
    
    @State private var charLimit : Int = 200
    @State private var keyboardHeight: CGFloat = 0 // new state variable to track keyboard height
    
    var body: some View {
        VStack {
            ScrollView {
                TextField("", text: $eventDescription, axis:.vertical)
                    .focused($isFocused) // bind focus state to TextField
                    .lineLimit(8)
                    .padding()
                    .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolRedPyramid.opacity(0.6)))
                    .padding()
                    .placeholder(when: eventDescription.isEmpty) {
                        Text("Add Event Description")
                            .font(.custom("Rubik Regular", size: 12))
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .padding()
                            .padding()

                    }
            }
            .padding(.bottom, isFocused ? keyboardHeight : 10) // add padding to push up the TextField when the keyboard is shown
            .animation(.easeOut(duration: 0.16)) // add animation to make the transition smoother
            .onTapGesture { // add gesture to dismiss keyboard when clicked outside the keyboard view
                isFocused = false
            }
            .onAppear { // add observer to detect when the keyboard is shown
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    guard let keyWindowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
                    let keyWindow = keyWindowScene.windows.first { $0.isKeyWindow }
                    let safeAreaBottom = keyWindow?.safeAreaInsets.bottom ?? 0
                    keyboardHeight = value.height - safeAreaBottom
                }
            }
            .onDisappear { // add observer to detect when the keyboard is hidden
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                    keyboardHeight = 0
                }
            }
        }
    }
}



//struct EventDescriptionView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDescriptionView()
//    }
//}
