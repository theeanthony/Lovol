//
//  FilterEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import SwiftUI

struct FilterEventView: View {
//    let tags : [String] = ["Offers", "Ratings","Under 30 min", "Price", "Lov Pass"]
    @State var tags : [String] = ["Ratings","Under 30 min", "Under $20"]

    @Binding var reset : Bool
    @Binding var filterChosen : Bool 
    @State private var tagsChosen : [String] = []
    
    var body: some View {
        GeometryReader{geo in
            
            VStack{
                ScrollView(.horizontal){
                    HStack{
                        ForEach(tags.indices, id:\.self){ tag in
                            Button {
                                if tags[tag] == "Reset"{
                                    self.filterChosen = false
                                    tags.remove(at: 0)
                                }
                            } label: {
                                HStack{
                                    if tags[tag] == "Ratings" {
                                        Image(systemName:"star.fill")
                                    }
//                                    if tags[tag] == "Offers" {
//                                        Image(systemName:"tag.fill")
//                                    }
                                    
                                    Text(tags[tag])
                                
                                    
                                    if tags[tag] == "Price" {
                                        Image(systemName:"chevron.down")
                                    }
                                    
                                }
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 30).fill(tags[tag] == "Reset" ? AppColor.lovolPinkish : AppColor.lovolDarkerPurpleBackground.opacity(0.6)))
                            }
                            .padding(.horizontal,5)
                            
                            
                        }
                        
                        
                        
                    }
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                }
                .padding(.top)
                .scrollIndicators(.hidden)
                .onChange(of: filterChosen) { newValue in
                    if filterChosen{
                        if !tags.contains("Reset"){
                            tags.insert("Reset", at: 0)
                        }
                    }
                }
//                if filterChosen {
//                    Button {
//                        self.filterChosen = false
//                    } label: {
//                        HStack{
//                            Spacer()
//                            Text("Reset")
//                                .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
//
//                                .padding(5)
//                                .padding(.horizontal,5)
//
//                                .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
//                        }
//                        .padding(.trailing,15)
//                    }
//                    .padding(.bottom,10)
//
//                }
//                Spacer()
            }
            
            
        }
    }
}

//struct FilterEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterEventView()
//    }
//}
