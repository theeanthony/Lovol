//
//  CurrentFiltersView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/16/22.
//

import SwiftUI

struct ChooseFilters: View {
    @Environment(\.dismiss) private var dismiss
    var questions: [String]
    var name: String
    var bio : String
    var birthDate : Date
    var college : String
   var occupation : String
    var gender : String
//    var orientation : Orientation
    var pictures: [UIImage]
    var interests: [String]
    @State var newCount : Int = 0
    @State var currentCount : Int = 0
    @State var currentValues : [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @State private var amountOfPeoplePreference : Int = 4
    @State private var genderPreference : Int = 2
    @State private var interactionPreference : Int = 2
    @State private var formPreference : Int = 2
    var age = Array(18...100)
    @State private var minYear : Int = 18
    @State private var maxYear : Int = 100
    var distance = Array(1...50)
    @State private var distancePreference : Double = 25
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    VStack{
                        //paid feature
                        Section("Gender Preferences") {
                            Picker("Gender Friend", selection: $genderPreference) {
                                Text("Male").tag(0)
                                Text("Female").tag(1)
                                Text("Both").tag(2)
                            }
                            
                        }
                        Section("Interaction Form"){
                            Picker("Form", selection: $formPreference){
                                Text("Human").tag(0)
                                Text("Avatar").tag(1)
                                Text("Both").tag(2)
                            }
                        }
                        //paid feature
                        Section("Amount of people") {
                            Picker("# of People", selection: $amountOfPeoplePreference) {
                                Text("1").tag(0)
                                Text("2").tag(1)
                                Text("3").tag(2)
                                Text("4").tag(3)
                                Text("5").tag(4)
                                
                            }
                        }
                        Section("Distance Preferences") {
                            Picker("Max Distance", selection: $distancePreference) {
                                ForEach(distance, id: \.self) {
                                    Text("\($0.formatted(.number.grouping(.never)))")
                                }
                            }
                        }
                        Section("Age Preferences") {
                            HStack{
                                Picker("Min Age", selection: $minYear) {
                                    ForEach(age, id: \.self) {
                                        Text("\($0.formatted(.number.grouping(.never)))")
                                    }
                                }
                                Picker("Max Age", selection: $maxYear) {
                                    ForEach(age, id: \.self) {
                                        Text("\($0.formatted(.number.grouping(.never)))")
                                    }
                                }
                            }
                        }
                        Section("Interaction Preference") {
                            Picker("Interaction Platform", selection: $interactionPreference) {
                                Text("Physical").tag(0)
                                Text("Facetime/Zoom").tag(1)
                                Text("MetaVerse/Virtual").tag(2)
                                Text("I don't care").tag(3)
                            }
                        }
                    }
                    .frame(maxWidth:.infinity,maxHeight:.infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                    )
                }
                Button {
                } label: {
//                    NavigationLink(destination: QuestionFlow(questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college:college, occupation:occupation, gender: gender, orientation: orientation , pictures: pictures, interests: interests, currentValues: $currentValues, newCount: newCount, currentCount: currentCount, filters: FilterModel(amountOfPeoplePreference: amountOfPeoplePreference, genderPreference: genderPreference, interactionPreference: interactionPreference, formPreference: formPreference, minYear: minYear, maxYear: maxYear, maxDistance: distancePreference))) {
//                        Text("Continue")
//
//                    }

                }
                .frame(maxWidth:.infinity,maxHeight:.infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                )
            }

            
        }

    }
}

//struct ChooseFilters_PreviewsProvider: PreviewProvider{
//    static let questions : [String] = ["Name...", "Who are you...?", "What is your birth date...", "What do you identify as...?", "What is your sexual preference...?", "Please upload at least 2 pictures...","What University do you attend", "What is your occupation...?", "If you have a solid friend group and never intend on using this app to find new friends, feel free to skip customizing your interests and hobbies to discover similar people.", "What are your interest/hobbies? Please choose 3-6.", "Let's dig deeper into how committed you are into your interests. Please slide the bar to how interested you are. "]
//    static var previews: some View {
//        ChooseFilters( questions: questions, name: "Ant", bio: "Hello", birthDate: Date(), college: "Stanford", occupation: "server", gender: "man", orientation: Orientation.both, pictures: [], interests: [])
//    }
//}
