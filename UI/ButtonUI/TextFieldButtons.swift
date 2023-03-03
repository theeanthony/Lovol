//
//  TextFieldButtons.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/1/22.
//

import SwiftUI

struct TextFieldEditor: View {
    private let charLimit: Int = 10
    init(_ text: Binding<String>){
        self._text = text
//        UITextView.appearance().backgroundColor = .clear
    }
    @Binding var text: String
//    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
//        VStack{

            HStack{
                TextEditor(text: $text).background(AppColor.lovolTan).onChange(of: text, perform: {newValue in
                    if(newValue.count >= charLimit){
                        text = String(newValue.prefix(charLimit))
                    }
                    
                })
      
//                Spacer()
//                Text("\(charLimit - text.count)").foregroundColor(.gray).font(.headline).bold()
            }
            .frame(width: 325, height: 55)
            .overlay{
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.5)))
                .frame(width: 325, height: 55)
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)

            }

        }

//    }
}

struct TextFieldEditor_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ProfileTextEditor(.constant("Texto de prueba para hacer la preview. "))
        }
    }
}
