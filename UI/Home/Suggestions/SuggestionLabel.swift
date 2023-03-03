//
//  SuggestionLabel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/26/22.
//

import SwiftUI

struct SuggestionLabel: View {
    
    let labelHeader : String
    @Binding var labelContent : String
    var body: some View {
        ZStack{
            VStack(spacing: -15){
                HStack{
                    RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolTan)
                        .frame(width: 85, height: 35)
                       
                        .overlay(
                            VStack{
                        
                                Text(labelHeader)
                                    .padding(.top,2)
                                Spacer()
                            }
                            )
                    
                }
                .offset(x: -105)
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolPinkish)
                
                TextEditorView(string: $labelContent)
                    .scrollContentBackground(.hidden) // <- Hide it
                    .padding(10)
                    .cornerRadius(20)
                    .frame(maxWidth:300)
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
                
            
            }
        }
    }
}

struct SuggestionLabel_Previews: PreviewProvider {
    @State static var content: String = ""
    static var previews: some View {
        SuggestionLabel(labelHeader: "Name", labelContent: $content) }
}

struct TextEditorView: View {
    
    @Binding var string: String
    @State var textEditorHeight : CGFloat = 15
    
    var body: some View {
        
        ZStack(alignment: .leading) {
//            Text(string)
//                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)
//                .foregroundColor(.clear)
//                .padding(14)
//                .background(GeometryReader {
//                    Color.clear.preference(key: ViewHeightKey.self,
//                                           value: $0.frame(in: .local).size.height)
//                })
            
            TextEditor(text: $string)
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                .frame(height: max(40,textEditorHeight))
                .cornerRadius(10.0)
                            .shadow(radius: 1.0)
        }.onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
        
    }
    
}


struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
