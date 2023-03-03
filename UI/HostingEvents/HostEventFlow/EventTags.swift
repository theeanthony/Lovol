//
//  EventTags.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//

import SwiftUI

struct EventTags: View {
    
    @Binding var tags : [String]
    @State private var tagChoices : [String] = ["Physical","Romantic","Party","Calm","Nature"]
    let newColumns = [
        GridItem(.adaptive(minimum: 150, maximum: 300)),
        GridItem(.adaptive(minimum: 150, maximum: 300)),
        GridItem(.adaptive(minimum: 150, maximum: 300))
     ]
    var body: some View {
        
        VStack{
            LazyVGrid(columns: newColumns, spacing: 10){
                ForEach(tagChoices.indices, id: \.self) { item in
                    Button {
                        store(index:item)
                    } label: {
                        Text(tagChoices[item])
                            .font(.custom("Rubik", size: 14           )).foregroundColor(.white)
                            .padding(5)
                            .padding(.horizontal,5)
                            .background(RoundedRectangle(cornerRadius: 30).fill(tags.contains(tagChoices[item]) ? AppColor.lovolDarkerPurpleBackground : AppColor.lovolPinkish))
                    }
                    
                }
                
            }
            
            
        }
  
        
    }
    func store(index:Int){
        var count : Int = 0
        for tag in tags {
            if tag == tagChoices[index]{
                tags.remove(at: count)
                return
            }
            count += 1
        }
        tags.append(tagChoices[index])
    }
}

//struct EventTags_Previews: PreviewProvider {
//    static var previews: some View {
//        EventTags()
//    }
//}
