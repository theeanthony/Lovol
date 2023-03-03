//
//  TickingSunView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/21/22.
//

import SwiftUI

struct TickingSunView: View {
    
    var receivedATime : Bool
    var startTime : Date
    var seconds: Int
    var beginningTime : Date
    
    var prizeMoney : String
    @State private var timeRightNow : Date = Date()
    @State private var secondsRemaining : Int = 0
    @State private var progress : Float = 0.0
    

    @State private var pieSliceData: PieSliceData = PieSliceData(
        startAngle: Angle(degrees: 0.0),
        endAngle: Angle(degrees: 360.0),
        color: AppColor.lovolCoverOrange)
    private var degreesPerMinute: Double {
        360.0 / Double(seconds)
    }

    
    @State private var endAngle: Angle = Angle()

    
    var body: some View {
        
        if !receivedATime {
//            ZStack{
//                Circle()
//                    .fill(
//                        .white
//                       )
//                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
////                    .frame(width: 324, height: 324)
//               
//          
//            }
        }
        else{
            GeometryReader {geo in
            VStack{
                    
  
//                    Circle()
//                        .fill(
//                            LinearGradient(gradient: Gradient(colors: [AppColor.lovolSunOrange, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
//                           )
////                        .rotationEffect(.degrees(360))
//
//                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
//                    GeometryReader { geometry in
//                        Path { path in
//                            let width: CGFloat = min(geometry.size.width, geometry.size.height)
////                            let width: CGFloat = 250
//
//                            let height = width
//
//                            let center = CGPoint(x: width * 0.5, y: height * 0.5)
//
//                            path.move(to: center)
//
//                            path.addArc(
//                                center: center,
//                                radius: width * 0.5,
//                                startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
//                                endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
//                                clockwise: false)
//
//                        }
//                        .fill(pieSliceData.color)
//                        .opacity(0.6)
//
//                    }
//                    .aspectRatio(1, contentMode: .fit)
                    Text(prizeMoney)
                        .font(.custom("Rubik Regular", size: 32)).foregroundColor(AppColor.lovolDarkerPurpleBackground)

//                    Circle().frame(width:350,height:350)
                
          
                    HStack{
                        Spacer()
                        Text("\(startTime.shortTime) \(startTime.fullDate)")
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkerPurpleBackground)
                            .multilineTextAlignment(.center)
                            .frame(width:geo.size.width * 0.7)
                        Spacer()
                    }
                }
//                                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

//                .frame(width:324,height:324)


            }
            
//            .onAppear(perform: calculateSecondsRemaining)
        }
            

    }

    
    private func calculateSecondsRemaining(){


 
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.day,.hour, .minute], from: startTime)
        let nowComponents = calendar.dateComponents([.day,.hour, .minute], from: Date())

        let difference = calendar.dateComponents([.minute], from: nowComponents, to: timeComponents).minute!

       secondsRemaining = difference
        
        progress = 1 - Float(secondsRemaining)/Float(seconds)
        
        endAngle = Angle(degrees: 1 - (Double(secondsRemaining) * degreesPerMinute))
        
        pieSliceData.endAngle = endAngle
        print(progress)
        
        
    }
}

struct TickingSunView_Previews: PreviewProvider {
   
    static var previews: some View {
        TickingSunView(receivedATime: true, startTime: Date(timeIntervalSinceReferenceDate: 694004400),seconds:11520, beginningTime:Date(timeIntervalSinceReferenceDate:693313200), prizeMoney: "$20,000")
    }
}

struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
}

