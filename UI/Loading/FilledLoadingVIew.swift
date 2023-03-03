//
//  FilledLoadingVIew.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//


import SwiftUI

struct FilledLoadingView: View {
    @State private var isAnimating = false
    var body: some View {
        Image("logo").resizable()
            .scaledToFit()
            .frame(width: isAnimating ? 200 : 150)
            .foregroundGradient(colors: [AppColor.lovolDarkerPurpleBackground, AppColor.lovolPinkish, AppColor.lovolOrange])
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(Animation.easeOut(duration: 1).repeatForever()){
                        self.isAnimating = true
                    }
                }
            }
    }
}

struct FilledLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        FilledLoadingView()
    }
}
