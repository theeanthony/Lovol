//
//  ReviewsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/7/23.
//

import SwiftUI

struct ReviewsView: View {
    
    let event : EventModel
    let reviewerName : String = "Anthony"
    

    
    var body: some View {
        
        GeometryReader{geo in
            
            VStack{
                HStack{
                    Text(event.lastReviewName)
                        .font(.custom("Rubik Bold", size: 15)).foregroundColor(.white)
                    Spacer()
                }
                .padding(2)
                .padding(.leading,5)
                HStack{
                    ForEach(0...4,id:\.self){
                        index in
                        if index < event.lastReviewScore {
                            Image(systemName:"star.fill")
                                .foregroundColor(.yellow)

                        }else{
                            Image(systemName:"star")
                        }
                    }
                    Text("\(event.lastReviewDate)")
                        .opacity(0.5)
                    Spacer()
                }
                .padding(2)
                .padding(.leading,5)
                HStack{
                    Text(event.lastReview)
                        .padding(2)
                        .padding(.leading,5)

                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                    Spacer()
                }

            }
            .frame(width:geo.size.width, height:geo.size.height)
            .background(RoundedRectangle(cornerRadius:10).stroke(.white.opacity(0.6),lineWidth:1))
            
            
        }
        
    }
}

//struct ReviewsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewsView()
//    }
//}
