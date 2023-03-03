//
//  BackgroundView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/24/23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
            }
        }
        .background(AppColor.lovolDark)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
