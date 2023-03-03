//
//  EditPreferences.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct EditPreference: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "chevron.left") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColor.lovolTan)
            
        }
    }
}
    @Binding var realInteractionPreference : Int
    @Binding var realDistancePreference : Double
    @Binding var realMinimumAge : Int
    @Binding var realMaximumAge : Int
    
    @State private var interactionPreference : Int = 0
    @State private var distancePreference : Double = 0
    @State private var minimumAge : Double = 0
    @State private var maximumAge : Double = 0
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(AppColor.lovolTan)
                            .frame(width: 325, height: 100)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        VStack{
                            Text("Choose how you will interact.")
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                                .padding(.bottom,5)
                            Text("By choosing Virtual, you will also be shown Avatar accounts.")
                                .font(.custom("Rubik Regular", size: 13)).foregroundColor(AppColor.lovolDarkPurple)
                            
                        }
                        
                        //                        .padding(.horizontal,10)
                        .padding(5)
                        .textInputAutocapitalization(.never)
                        .frame(width: 325, height: 150)
                    }
                    
                    Picker("", selection: $interactionPreference) {
                        Text("Physical").tag(0)
                        
                        Text("Virtual").tag(1)
                    }
//                    .background(AppColor.lovolTan)
                    .pickerStyle(SegmentedPickerStyle())
//                    .foregroundColor(AppColor.lovolDarkPurple)
                    .padding(.horizontal,20)
                    .padding(.bottom,10)
                    
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColor.lovolTan)
                            .frame(width: 325, height: 100)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                                VStack{
                                    Text("Set Distance Preference.")
                                        .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                                        .padding(.bottom,5)

                                }
          
                                .padding(20)
                                .textInputAutocapitalization(.never)
                                .frame(width: 325, height: 200)
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColor.lovolTan)
                                .frame(maxWidth: 325, maxHeight: 100)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                            VStack{
                                Text("Max Distance: \(String(format: "%.0f", distancePreference))")
                                    .font(.custom("Rubik Bold", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                                    .padding(.bottom,10)
                                SliderView1(value: $distancePreference)
                                    .frame(width: 320, height: 20)
                                HStack{
                                    Text("1")
                                    Spacer()
                                    Text("50")
                                }
                                .padding(.horizontal,45)
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                            }
                        }
                    }
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColor.lovolTan)
                            .frame(width: 325, height: 100)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                                VStack{
                                    Text("Set Age Preference.")
                                        .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                                        .padding(.bottom,5)

                                }
          
                                .padding(20)
                                .textInputAutocapitalization(.never)
                                .frame(width: 325, height: 200)
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColor.lovolTan)
                                .frame(maxWidth: 325, maxHeight: 300)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                            VStack{
                                Text("Minimum Age: \(String(format: "%.0f", minimumAge+18))")
                                    .font(.custom("Rubik Bold", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                                    .padding(.bottom,10)
                                SliderView2(value: $minimumAge)
                                    .frame(width: 320, height: 20)
                                    .padding(.horizontal,10)
                                HStack{
                                    Text("18")
                                    Spacer()
                                    Text("100")
                                }
                                .padding(.horizontal,45)
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                                Text("Maximum Age: \(String(format: "%.0f", maximumAge+18))")
                                    .font(.custom("Rubik Bold", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                                    .padding(.bottom,10)
                                SliderView2(value: $maximumAge)
                                    .frame(width: 320, height: 20)
                                    .padding(.horizontal,10)
                                
                                HStack{
                                    Text("18")
                                    Spacer()
                                    Text("100")
                                }
                                .padding(.horizontal,45)
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                            }
                        }
                    }
                    
                }
                Button {
                    done()
                } label: {
                    Text("done")
                }
                
                
                
                
                
                
                
            }
            .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)
            
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Text("Edit Preferences")
                        .foregroundColor(AppColor.lovolTan)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func done(){
        if isAgeGood(){
            self.realInteractionPreference = interactionPreference
            self.realDistancePreference = distancePreference
            self.realMinimumAge = Int(minimumAge)
            self.realMaximumAge = Int(maximumAge)
            presentationMode.wrappedValue.dismiss()
        }
    }
    func fillPreferences() {
        interactionPreference = realInteractionPreference
        distancePreference = realDistancePreference
        minimumAge = Double(realMinimumAge)
        maximumAge = Double(realMaximumAge)
    }
    func isAgeGood()->Bool{
        return maximumAge >= minimumAge
    }
}

struct EditPreference_Previews: PreviewProvider {
    @State static var interactionPreference : Int = 0
    @State static var distancePreference : Double = 0
    @State static var minimumAge : Int = 0
    @State static var maximumAge : Int = 0

    static var previews: some View {
        EditPreference(realInteractionPreference: $interactionPreference, realDistancePreference: $distancePreference, realMinimumAge: $minimumAge, realMaximumAge: $maximumAge)
    }
}
