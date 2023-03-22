//
//  TagsHeaderView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct TagsHeaderView: View {
    
    let tags : [String] = ["Trending", "Experience", "Nature", "Party", "Night", "Physical", "Calm", "Board Games", "Art", "Food", "Spicy","Odd"]
    let tagPhotos : [String] = ["trendFrame", "experienceFrame", "natureFrame", "partyFrame", "nightFrame", "physicalFrame", "calmFrame", "boardGameFrame", "artFrame", "foodFrame","spicyFrame","oddFrame"]
    
    @Binding var chosenTag : String 
    
    @Binding var filterChosen : Bool 
     
    var body: some View {
        GeometryReader{geo in
            
            VStack{
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
                .padding(.top)
                .scrollIndicators(.hidden)
                HStack{
                    Spacer()

                    if filterChosen{
                        Button {
                            self.filterChosen = false
                        } label: {
                            Text("Reset")
                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                            
                        }
                    }

                }
                .padding(.trailing,25)
            }
            
            
        }
    }
}

//struct TagsHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagsHeaderView()
//    }
//}
