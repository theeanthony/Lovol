//
//  SuggestEventView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/26/22.
//

import SwiftUI

struct SuggestEventView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject private var eventViewModel :EventViewModel
    @Binding var showSuggestionSheet : Bool
    @State private var name: String = ""
    @State private var category : String = ""
    @State private var description: String = ""
    @State private var rules: String = ""
    @State private var location: String = ""
    @State private var time : String = ""
    @State private var cost: String = ""
    @State private var showFillError : Bool = false
    
    @State private var types  : [String] = ["Home", "Virtual", "Regional", "21+"]
    
    @State private var showError : Bool = false 
    var body: some View {
        
        VStack{
            VStack{
                
                Spacer()
                SuggestionLabel(labelHeader: "Name", labelContent: $name)
                SuggestionLabel(labelHeader: "Description", labelContent: $description)
                SuggestionLabel(labelHeader: "Rules", labelContent: $rules)
                SuggestionLabel(labelHeader: "Location", labelContent: $location)
                SuggestionLabel(labelHeader: "Time", labelContent: $time)
                SuggestionLabel(labelHeader: "Cost", labelContent: $cost)
                
                HStack{
                    ForEach(types.indices, id:\.self){ index in
                        Button {
                            category = types[index]
                        } label: {
                            if (types[index] == category){
                                Text(types[index])
                                    .padding(7)
                                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPrettyPurple))
                            }
                            else{
                                Text(types[index])
                                    .padding(7)
                                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
                            }
    
                        }

                    }
                }
                .padding()
                .frame(width:300)

                
                Spacer()
                Button {
                    submit()
                } label: {
                    Text("Submit")
                        .font(.custom("Rubik Regular", size: 14))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolPinkish) .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                        .foregroundColor(AppColor.lovolTan)
                }
//                Spacer()


                
                
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [ AppColor.lovolOrange,AppColor.lovolTan]), startPoint: .top, endPoint: .bottom)
            )
            .alert("There was a problem sending your suggestion. Please try again later.", isPresented: $showError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .alert("Please fill in all boxes.", isPresented: $showFillError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
        }
       
    }
    private func submit(){
//        if name.isEmpty || description.isEmpty || rules.isEmpty || location.isEmpty || time.isEmpty || cost.isEmpty || category.isEmpty {
//            showFillError = true
//            return
//        }
//        
//        let suggestEvent : EventModel = EventModel(id: time, eventName: name, eventDescription: description, eventRules: rules, eventLocation: location, eventAverageCost:0, eventTime: 0, eventPoints: 0, eventType: category, eventMonth: cost, eventURL: "")
//        eventViewModel.suggestEvent(event: suggestEvent) { result in
//            switch result{
//            case .success(()):
//                showSuggestionSheet = false
////                presentationMode.wrappedValue.dismiss()
//            case .failure(let error):
//                print("error suggesting event \(error)")
//                showError = true
//
//            }
//        }
    }
}

//struct SuggestEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        SuggestEventView()
//    }
//}
