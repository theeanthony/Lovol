//
//  LeaveReviewView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/7/23.
//

import SwiftUI

struct LeaveReviewView: View {
    let name: String = "Anthony"
    @State private var chosenStar : Int = 0
    var body: some View {
        GeometryReader{geo in
            VStack{
                HStack{
                    Text(name)
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading,15)
                HStack{
                    ForEach(0...4,id:\.self){
                        index in
                        Button {
                            
                        } label: {
                            Image(systemName:"star")
                                .foregroundColor(.white)
                        }

                        
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Tap to review")
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                    }
                    Spacer()

                }
                .padding(.leading,15)

            }
//            .frame(width:geo.size.width * 0.9)
            .padding(.vertical)
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.3))
            
        }
    }
}

struct LeaveReviewView_Previews: PreviewProvider {
    static var previews: some View {
        LeaveReviewView()
    }
}
