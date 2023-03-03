//
//  TeamListView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//

import SwiftUI

struct TeamListView: View {
    @State var changeBool : Bool =  false
    @State var unsaved: String = ""
    @State var chosenEvent : EventModel = EventModel()
    var body: some View {

            
Text("hello wol")

            
        }
    
}

struct TeamListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamListView()
    }
}
extension View {
    
    func hasScrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
}
struct ListHeader: View {
    let text : String
    var body: some View {
        HStack {
            Text(text)
                .font(.custom("Rubik Regular", size: 8)).foregroundColor(.white).opacity(0.7)
//                .padding(.leading,20)
            ExDivider(color:.white.opacity(0.7))
        }
    }
}
struct ExDivider: View {
    let color: Color
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
