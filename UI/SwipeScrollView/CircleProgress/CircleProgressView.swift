//
//  CircleProgressView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import SwiftUI

struct CircleProgressView: View {
    
     var progress: Float
//    let model : NewUserProfile
    var body: some View {
        
        ZStack {
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.largeTitle)
                .bold()
                .foregroundColor(AppColor.lovolDarkPurple)
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(AppColor.lovolDarkPurple)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                   .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                   .foregroundColor(AppColor.lovolPrettyPurple)
                   .rotationEffect(Angle(degrees: 270.0))
                   .animation(.linear, value: progress)

        }
    }
}

//struct PracticeView: View {
//    @State var progressValue: Float = 0.2
//    
//    var body: some View {
//            
//            HStack {
//                CircleProgressView(progress: self.$progressValue)
//                    .frame(width: 120.0, height: 120.0)
//                    .padding(25.0)
//                CircleProgressView(progress: self.$progressValue)
//                    .frame(width: 120.0, height: 120.0)
//                    .padding(25.0)
//                
//            }
//    }
//}
//
//
//struct PracticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeView()
//    }
//}
