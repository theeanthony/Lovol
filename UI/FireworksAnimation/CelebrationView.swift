//
//  CelebrationView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/19/23.
//

import SwiftUI

struct CelebrationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isCelebrationPresent : Bool
    let totalPoints : Int
    var body: some View {

       
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier())
                    .offset(x: -100, y : -50)

                
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier())
                    .offset(x: 60, y : 70)


    }
}

//struct CelebrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        CelebrationView(totalPoints: 20)
//    }
//}
