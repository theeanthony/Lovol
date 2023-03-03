//
//  CircleArc.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/15/22.
//

import SwiftUI

struct CircleArc: Shape {
    let minuteIndex: Int
    let totalMinutes: Int
    // 7 days is 10080 minutes

    private var degreesPerMinute: Double {
        360.0 / Double(totalMinutes)
    }
    private var startAngle: Angle {
        Angle(degrees: Double(degreesPerMinute) * Double(minuteIndex) + 1.0)
    }
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerMinute - 1.0)
    }

    func path(in rect: CGRect) -> Path {
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        let radius = diameter / 2.0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}

//struct CircleArc_Previews: PreviewProvider {
//    static var previews: some View {
//        CircleArc()
//    }
//}
