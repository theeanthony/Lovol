//
//  InfiniteSwipeCardView.swift
//
//  InfiniteSwipeCardView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/10/22.
//

import SwiftUI

struct InfiniteSwipeCardView: View {
    @EnvironmentObject var firestoreViewModel : FirestoreViewModel
    let model: NewUserProfile
//    var index: Int
    @State private var currentImageIndex: Int = 0
    
    @State private var showReportSheet : Bool = false
 
    @Binding var chosenAnswers : [Int]
    @Binding var chosenQuestions: [String]
    @Binding var leftQuestions : [String]
    @Binding var rightQuestions : [String]
    var personalAnswers : [Int]
    
    @State private var oneToFive : [Int] = [1,2,3,4,5]
    @State private var oneToFive1 : [Int] = [1,2,3,4,5]
    @State private var oneToFive2 : [Int] = [1,2,3,4,5]

    @State private var firstChosen : Int = -1
    @State private var secondChosen : Int = -1
    @State private var thirdChosen : Int = -1
    
    @State var progressValue: Float = 0.1
    
    @State var reportSheetPopUp : Bool = false
    
    var isTestProfile : Bool
    
    @State private var onTap : Bool = false
    var body: some View {
        
        
        GeometryReader{ geo in
            ScrollView{
                
//                ScrollView{
                    VStack{
                       
                        VStack{
                            ZStack{
                                Image(uiImage: model.pictures[0])
                                    .centerCropped()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.8)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .background(RoundedRectangle(cornerRadius: 20).fill(.clear))

                                VStack{
                                    Spacer()
                                    ZStack(alignment: .bottomLeading){
                                        HStack{
                                            Text("\(model.name), \(model.age)").font(.largeTitle).fontWeight(.semibold)
                                                .foregroundColor(.white)
                                                .textCase(.uppercase)
                                                .padding(.leading,3)
                                            if model.isATeam {
                                                Spacer()
                                                
                                                VStack(alignment: .trailing){
                                                    Image(systemName: "face.smiling.fill")
                                                        .foregroundColor(.white)
                                                        .frame(width: 20, height: 20)
                                                        .padding(.trailing,15)
                                                    HStack{
                                                        Image(systemName: "face.smiling.fill")
                                                            .foregroundColor(.white)
                                                            .frame(width: 20, height: 20)
                                                        Image(systemName: "face.smiling.fill")
                                                            .foregroundColor(.white)
                                                            .frame(width: 20, height: 20)
                                                    }
                                                }
                                                //                                    .padding(.trailing,10)
                                                
                                            }
                                            else{
                                                Spacer()
                                                VStack(alignment: .trailing){
                                                    Image(systemName: "face.smiling.fill")
                                                        .foregroundColor(.white)
                                                        .frame(width: 20, height: 20)
                                                        .padding(.trailing,10)
                                                }
                                                
                                            }
                                        }
                                        .padding(.bottom,5)
                                        .frame(width: geo.size.width * 0.85)
                                    }
                                }
                            }

                        }
                       
                        Group{
                            if model.isATeam{
                                VStack(alignment:.leading){
                                    if(model.city == "Virtual"){
                                        HStack{
                                            Image(systemName: "cloud.fill")
                                            Text("Virtual")
                                            Spacer()
                                            
                                        }
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                        .padding(.leading,15)
                                        .padding(.top,10)
                                        .padding(.bottom,5)
                                    }
                                    else{
                                        HStack{
                                            Image(systemName: "house.fill")
                                            Text(model.city)
                                            Spacer()
                                        }
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                        .padding(.leading,15)
                                        .padding(.top,10)
                                        .padding(.bottom,5)
                                        
                                    }
                                    Text(model.bio)
                                        .padding(.leading,15)
                                        .padding(.bottom,10)
                                    
                                    
                                    
                                }
                                .font(.custom("Rubik Regular", size: 13))

                                .foregroundColor(AppColor.lovolDarkPurple)
                                
                                .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan)                .frame(width:geo.size.width * 0.9)
)
                        
//                                .padding(.leading,5)
//                                .padding(.trailing,5)
                                .padding(.bottom,5)
                                .padding(.top,5)
                                
                            }
                            else{
                                VStack(alignment: .leading){
                                    
                                    if model.occupation != "" {
                                        HStack(alignment:.firstTextBaseline){
                                            Image(systemName: "suitcase.fill")
                                                .foregroundColor(AppColor.lovolDarkPurple)
                                            Text(model.occupation).font(.caption).foregroundColor(AppColor.lovolDarkPurple)
                                                .font(.custom("Rubik Regular", size: 13))
                                            Spacer()
                                        }
                                        .padding(.top,10)
                                        .padding(.leading, 10)
                                        
                                    }
                                    if model.college != "none" && model.college != "" {
                                        HStack(alignment:.firstTextBaseline){
                                            Image(systemName:"brain")
                                                .foregroundColor(AppColor.lovolDarkPurple)
                                            Text(model.college).font(.footnote).foregroundColor(AppColor.lovolDarkPurple)
                                                .font(.custom("Rubik Regular", size: 13))
                                            Spacer()
                                            
                                        }
                                        .padding(.top,1)
                                        .padding(.leading, 9)
                                        //                                    .padding(.bottom, 10)
                                        
                                    }
                                    if(model.city == "Virtual"){
                                        HStack{
                                            Image(systemName: "cloud.fill")
                                            Text("Virtual")
                                            Spacer()
                                            
                                        }
                                        .padding(.leading,9)
                                        .padding(.top,10)
                                        .padding(.bottom,5)
                                    }
                                    else{
                                        HStack{
                                            Image(systemName: "house.fill")
                                            Text(model.city)
                                            Spacer()
                                        }
                                
                                        .padding(.leading,9)
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                        
                                    }
                                    Text(model.bio)
                                        .padding(.top,1)
                                        .padding(.leading, 15)
                                        .padding(.bottom, 10)
                                    
                                    
                                }
                                .font(.custom("Rubik Regular", size: 13))
                                .foregroundColor(AppColor.lovolDarkPurple)
                                .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan)                .frame(width:geo.size.width * 0.9))
                                .padding(.leading,5)
                                .padding(.trailing,5)
                                .padding(.bottom,5)
                                .padding(.top,5)
                            }
                        }
//                            Group{
                                if model.isATeam {

                                VStack(alignment: .leading){
                                    ForEach(model.nameAndPic!.indices, id: \.self){ index in
                                        HStack{
                                            Image(uiImage: model.nameAndPic![index].pictures)
                                                .centerCropped()
                                                .clipShape(Circle())
                                                .frame(width: 45, height: 45)
                                                .overlay(
                                                    Circle().stroke(AppColor.lovolPrettyPurple,lineWidth: 2)
                                                    
                                                )
                                            VStack(alignment: .leading){
                                                Text(model.nameAndPic![index].names)
                                                    .font(.custom("Rubik-Bold", size: 15)).fontWeight(.heavy)
                                                Text(model.nameAndPic![index].bio)
                                                    .font(.custom("Rubik Regular", size: 13))
                                            }
                                            Spacer()
                                        }
                                        .padding(.leading,15)
                                        //                                    .padding(
                                        
                                    }
                                    .padding(.top,5)
                                    .padding(.bottom,5)
                                    
                                }
                                .foregroundColor(AppColor.lovolDarkPurple)
                                
                                .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan)                .frame(width:geo.size.width * 0.9))
                                .padding(.leading,5)
                                .padding(.trailing,5)
                                .padding(.bottom,5)
                                
                            }
//                        }
                        
//                        Group{

//                        }
                        
                 
   
                            VStack{

                                Text(model.ownQuestions[0])
                                    .padding(.leading,35)
                                    .padding(.trailing,35)
                                    .padding(.top,10)
                                    .font(.custom("Rubik Regular", size: 16))

                                ZStack{
                                    Rectangle()
                                        .frame(width:geo.size.width * 0.67,height: 3)

                                    HStack{
                                        ForEach(0...4, id: \.self){ index in
                                            Button {
                                                self.chooseFirstQuestion(index: index)
                                            } label: {
//                                                Spacer()
                                                if firstChosen == index{
                                                    Circle()
                                                        .fill(AppColor.lovolOrange)
                                                        .frame(width: geo.size.width * 0.15, height: 15)

                                                }
                                                else{
                                                    Circle()
                                                        .fill(AppColor.lovolDarkPurple)
                                                        .frame(width: geo.size.width * 0.15, height: 15)

                                                }

//                                                Spacer()
                                            }
                                        }

                                    }

                                    .padding(.top,10)
                                    .padding(.bottom,10)
                                }

                                HStack{
                                    Text(model.ownLeftAnswer[0])
                                    Spacer()
                                    Text(model.ownRightAnswer[0])
                                }
                                .frame(width:geo.size.width * 0.8)

                                .font(.custom("Rubik Regular", size: 12))
                                .padding(.leading,5)
                                .padding(.trailing,5)
                                .padding(.bottom, 20)
                            }

                            .foregroundColor(AppColor.lovolDarkPurple)

                            .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan).frame(width:geo.size.width * 0.9))

                            .padding(.bottom,5)
////
                        HStack{
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum:150),spacing: 5),GridItem(.adaptive(minimum: 100, maximum:150),spacing: 5),GridItem(.adaptive(minimum: 100, maximum:150),spacing: 5)], spacing: 10) {
                                ForEach(model.interests, id: \.self) { item in
                                    
                                    Button {
                                        
                                    } label: {
                                        Text(item)
                                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                    }
                                    .buttonStyle(InterestHobbiesButton())
                                }
                                //                                Spacer()
                            }
                            .padding(.trailing, 5)
                            .padding(.leading, 5)
                            .padding(.bottom, 10)
                            .padding(.top,10)
                        }
                        .foregroundColor(AppColor.lovolDarkPurple)
                        .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan)                .frame(width:geo.size.width * 0.9))
                        .padding(.leading,5)
                        .padding(.trailing,5)
                        .padding(.bottom,5)
//                        Group{
                        VStack{
//                            QuestionComponents(index: 0, buttonChoice: $firstChosen, model: model, chosenAnswers: $chosenAnswers, chosenQuestions: $chosenQuestions, leftQuestions: $leftQuestions, rightQuestions: $rightQuestions)
//                                .frame(height:geo.size.height * 0.2 )
                            Image(uiImage: model.pictures[1])
                                .centerCropped()
                                .aspectRatio(contentMode: .fill)
                                .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.8)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom,5)                                .background(RoundedRectangle(cornerRadius: 20).fill(.clear))
                        }


                            //                            .padding(5)
                            
//                        }
//                        Group{

                        VStack{


                            Text(model.ownQuestions[1])
                                .padding(.leading,35)
                                .padding(.trailing,35)
                                .padding(.top,10)
                                .font(.custom("Rubik Regular", size: 16))

                            ZStack{
                                
                                Rectangle()
                                    .frame(width:geo.size.width * 0.67,height: 3)

                                HStack{
                                    ForEach(0...4, id: \.self){ index in
                                        Button {
                                            self.chooseSecondQuestion(index: index)
                                        } label: {
//                                                Spacer()
                                            if secondChosen == index{
                                                Circle()
                                                    .fill(AppColor.lovolOrange)
                                                    .frame(width: geo.size.width * 0.15, height: 15)

                                            }
                                            else{
                                                Circle()
                                                    .fill(AppColor.lovolDarkPurple)
                                                    .frame(width: geo.size.width * 0.15, height: 15)

                                            }

//                                                Spacer()
                                        }
                                    }

                                }

                                .padding(.top,10)
                                .padding(.bottom,10)
                            }

                            HStack{
                                Text(model.ownLeftAnswer[1])
                                Spacer()
                                Text(model.ownRightAnswer[1])
                            }
                            .frame(width:geo.size.width * 0.8)

                            .font(.custom("Rubik Regular", size: 12))
                            .padding(.leading,5)
                            .padding(.trailing,5)
                            .padding(.bottom, 20)
                        }

                        .foregroundColor(AppColor.lovolDarkPurple)

                        .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan).frame(width:geo.size.width * 0.9))

                        .padding(.bottom,5)
                        
                        
                        Group{
                            if !isTestProfile {
                                VStack(spacing:0){
                                    Text("Compatibility based on initial questions.")
                                        .padding(.vertical,5)
                                        .font(.custom("Rubik Regular", size: 16))
                                        .foregroundColor(AppColor.lovolDarkPurple).frame(width:geo.size.width * 0.6).multilineTextAlignment(.center)
                                    if model.isATeam{
                                        VStack{
                                            ForEach(model.nameAndPic!.indices, id: \.self){
                                                index in
                                                VStack{
                                                    HStack{
                                                        CircleProgressView(progress: calculatePercentage(modelsAnswers: model.nameAndPic![index].answers))
                                                            .frame(width:geo.size.width * 0.35)                                            .padding(25.0)                                                            .padding(10.0)
                                                            .padding(.leading,10)

                                                  
                                                        Spacer()
                                                        VStack{
                                                            Image(uiImage: model.nameAndPic![index].pictures)
                                                                .centerCropped()
                                                                .clipShape(Circle())
                                                                .frame(width: geo.size.width * 0.2, height: geo.size.width * 0.2)
                                                                .overlay(
                                                                    Circle().stroke(AppColor.lovolPrettyPurple,lineWidth: 2)
                                                                    
                                                                )
                                                            Text(model.nameAndPic![index].names)
                                                                .font(.custom("Rubik Regular", size: 16))
                                                                .foregroundColor(AppColor.lovolDarkPurple)
                                                        }
                                                        Spacer()
                                                    }
                                                    .frame(width:geo.size.width * 0.9)

                                                }


                                            }

                                        }
                                        .padding(.top,10)
                                    }
                                    else{
                                        CircleProgressView(progress: calculatePercentage(modelsAnswers: model.answersToGlobalQuestions))
                                            .frame(width:geo.size.width * 0.6)                                            .padding(25.0)
                                    }

                                }
//
                                .padding(.vertical,5)

                                .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan).frame(width:geo.size.width * 0.9))


                            }
                        
                        
                        
                        
                            Image(uiImage: model.pictures[2])
                                .centerCropped()
                                .aspectRatio(contentMode: .fill)
                                .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.8)                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.bottom,5)
                                .background(RoundedRectangle(cornerRadius: 20).fill(.clear))
                        VStack{

                            Text(model.ownQuestions[2])
                                .padding(.leading,35)
                                .padding(.trailing,35)
                                .padding(.top,10)
                                .font(.custom("Rubik Regular", size: 16))

                            ZStack{
                                Rectangle()
                                    .frame(width:geo.size.width * 0.67,height: 3)

                                HStack{
                                    ForEach(0...4, id: \.self){ index in
                                        Button {
                                            self.chooseThirdQuestion(index: index)
                                        } label: {
//                                                Spacer()
                                            if thirdChosen == index{
                                                Circle()
                                                    .fill(AppColor.lovolOrange)
                                                    .frame(width: geo.size.width * 0.15, height: 15)

                                            }
                                            else{
                                                Circle()
                                                    .fill(AppColor.lovolDarkPurple)
                                                    .frame(width: geo.size.width * 0.15, height: 15)

                                            }

//                                                Spacer()
                                        }
                                    }

                                }

                                .padding(.top,10)
                                .padding(.bottom,10)
                            }

                            HStack{
                                Text(model.ownLeftAnswer[2])
                                Spacer()
                                Text(model.ownRightAnswer[2])
                            }
                            .frame(width:geo.size.width * 0.8)

                            .font(.custom("Rubik Regular", size: 12))
                            .padding(.leading,5)
                            .padding(.trailing,5)
                            .padding(.bottom, 20)
                        }

                        .foregroundColor(AppColor.lovolDarkPurple)

                        .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan).frame(width:geo.size.width * 0.9))

                        .padding(.bottom,5)

//
                       
//
//
//
//
//
//
                            Button {
                                reportUser(id: model.userId)
                            } label: {
                                //Report profile
                                Text("Report profile").font(.custom("Rubik Regular", size: 10)).underline().foregroundColor(Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 1))).tracking(0.6).multilineTextAlignment(.center)
                            }
                            .padding(.top,10)
                        }
//
                        
                        
                        
                        
                   
                        
                    }
                    

//                }
//
//                .frame(width:geo.size.width * 0.80, height:geo.size.height*0.85)
//                .padding(.bottom,10)
//                .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))

//                .position(x:geo.frame(in:.global).midX,y:geo.frame(in:.global).minY )
                




                .sheet(isPresented: $reportSheetPopUp){
                    ReportSheetView(reportId: model.userId)
                }
            }
            .cornerRadius(20)
            .frame(width:geo.size.width * 0.95, height:geo.size.height * 0.9)

            .padding(.vertical,10)
            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple))
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)




        }
    }
     
    private func calculatePercentage(modelsAnswers: [Int]) -> Float{
        
        if isTestProfile {
            return 0.0
        }
        
        
        var percent : Float = 0.0
        for index in 0...14{
            var changedNumber : Int = 0

            changedNumber = abs(personalAnswers[index]-modelsAnswers[index])
            if changedNumber == 0 {
                percent += 0.066
            }
            else if changedNumber == 1{
                percent += 0.048

            }
            else if changedNumber == 2 {
                percent += 0.032

            }
            else if changedNumber == 3 {
                percent += 0.016

            }
            else if changedNumber == 4{
                percent += 0.0

            }
            
            
        }
        return Float(percent)

        
    }
    private func reportUser(id: String){
        
        
        reportSheetPopUp = true

    }

     func chooseFirstQuestion(index: Int){
        print("1 tapped")
        firstChosen = index
        chosenAnswers[0] = firstChosen + 1
        chosenQuestions[0] = model.ownQuestions[0]
        leftQuestions[0] = model.ownLeftAnswer[0]
        rightQuestions[0] = model.ownRightAnswer[0]

    }
     func chooseSecondQuestion(index: Int){
        print("2 tapped")

        secondChosen = index
        chosenAnswers[1] = secondChosen + 1
        chosenQuestions[1] = model.ownQuestions[1]
        leftQuestions[1] = model.ownLeftAnswer[1]
        rightQuestions[1] = model.ownRightAnswer[1]

    }
    private func chooseThirdQuestion(index: Int){
        print("3 tapped")

        thirdChosen = index
        chosenAnswers[2] = thirdChosen + 1
        chosenQuestions[2] = model.ownQuestions[2]
        leftQuestions[2] = model.ownLeftAnswer[2]
        rightQuestions[2] = model.ownRightAnswer[2]

    }
 

}

struct InfiniteSwipeCardView_Previews: PreviewProvider {

    static let ownQuestions : [String] = [
        "Where do I enjoy the room's attention being casted on?",
        "How often am I on my phone?",
        "How do I view exercise?",
        "How do I handle conflict?",
        "How do I recharge my battery?"
    ]
    static let answerToGlobalQuestions : [Int] = [1,1,2,5,5,2,5,4,3,2,2,1,2,3,4,5,5,1,1,1]
    static let answerToGlobalQuestions1 : [Int] = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    static let answerToGlobalQuestions2: [Int] = [1,1,2,4,4,4,5,4,3,2,2,4,2,3,4,5,5,3,3,4]
    static let answerToGlobalQuestions3 : [Int] = [1,1,2,1,2,2,5,4,3,2,2,1,2,3,4,5,5,3,3,2]

    static let ownLeftQuestions: [String] = ["1 left", "2 left", "3 left", "4 left", "5 left"]
    static let ownRightQuestions: [String] = ["1 right", "2 right", "3 right", "4 right", "5 right"]
    @State static var chosenAnswers : [Int] = []
    @State static var chosenQuestions: [String] = []
    @State static var leftQuestions: [String] = []
    @State static var rightQuestions: [String] = []
    static let nameAndPic : [NameAndProfilePic] = [NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions1),NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions2),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions3),NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions2),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions)]


    static var previews: some View {
        InfiniteSwipeCardView(model: NewUserProfile(userId: "", name: "Annabelle", age: 22, bio: "I am a goofy goober hehehe", amountOfUsers: 6, isATeam: true, interests: ["snowboarding!!","snowboarding!!?", "snowboarding!!", "snowboarding!!","snowboarding!!","snowboarding!!"], college: "Santa Clara University", occupation: "Soul Brother", formPreference: 1, interactionPreference: 1, maxDistancePreference: 1, maxYearPreference: 1, minYearPreference: 1, answersToGlobalQuestions: answerToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftQuestions, ownRightAnswer: ownRightQuestions, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!], nameAndPic: nameAndPic, city: "Virtual"), chosenAnswers: $chosenAnswers, chosenQuestions:$chosenQuestions, leftQuestions: $leftQuestions, rightQuestions: $rightQuestions, personalAnswers: [1,2,3,4,5,1,2,3,4,5,1,2,3,4,5], isTestProfile: false)
                              }
}
                             
