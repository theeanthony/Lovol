//
//  FilterEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct FilterEventView: View {
    let tags : [String] = ["Offers", "Ratings","Under 30 min", "Price", "Lov Pass"]
    
    @Binding var reset : Bool
    @Binding var filterChosen : Bool 
    @State private var tagsChosen : [String] = []
    
    var body: some View {
        GeometryReader{geo in
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(tags.indices, id:\.self){ tag in
                        Button {
                            
                        } label: {
                            HStack{
                                if tags[tag] == "Ratings" {
                                    Image(systemName:"star.fill")
                                }
                                if tags[tag] == "Offers" {
                                    Image(systemName:"tag.fill")
                                }
                                
                                Text(tags[tag])
                          
                                if tags[tag] == "Price" {
                                    Image(systemName:"chevron.down")
                                }

                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolDarkerPurpleBackground).opacity(0.6))
                        }
                        .padding(.horizontal,5)
                        
                        
                    }



                }
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
            }
            .padding(.vertical)
            .scrollIndicators(.hidden)
            
            
        }
    }
}

//struct FilterEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterEventView()
//    }
//}
