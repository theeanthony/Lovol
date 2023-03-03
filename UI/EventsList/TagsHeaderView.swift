//
//  TagsHeaderView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct TagsHeaderView: View {
    
    let tags : [String] = ["Trending", "Experience", "Nature", "Party", "Video Games", "Physical", "Calm", "Board Games", "Art", "Food"]
    let tagPhotos : [String] = ["trendFrame", "experienceFrame", "natureFrame", "partyFrame", "videogamesFrame", "physicalFrame", "calmFrame", "boardGameFrame", "artFrame", "foodFrame"]
    
    @Binding var chosenTag : String 
    
    @Binding var filterChosen : Bool 
    
    var body: some View {
        GeometryReader{geo in
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(tags.indices, id:\.self){ tag in
                        Button {
                            
                            self.chosenTag = tags[tag]
                            self.filterChosen = true
                            
                        } label: {
                            VStack{
                                Image(tagPhotos[tag])
                                    .resizable()
                                    .centerCropped()
                                    .aspectRatio( contentMode: .fit)
                                    .frame(width:geo.size.width * 0.15, height:geo.size.width * 0.15)
                                Text(tags[tag])

                            }
                        }
                        .padding(.horizontal,10)
                        
                        
                    }



                }
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
            }
            .padding(.vertical)
            .scrollIndicators(.hidden)
            
            
        }
    }
}

//struct TagsHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagsHeaderView()
//    }
//}
