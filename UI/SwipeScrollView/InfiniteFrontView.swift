//
//  InfiniteFrontView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/10/22.
//


import SwiftUI

struct InfiniteScrollView: View {

    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var profileViewModel : ProfilesViewModel
    @State private var profiles: [NewUserProfile] = []
    @State private var swipeViewLoading = true
    @State private var anim = false
    @State private var showMatchView = false
    @State private var matchName = ""
    @State private var matchImage: UIImage = UIImage()
    @State private var matchId = ""
    @State private var swipeForTeam : Bool = false
    @State private var showFilters = false
    @State private var showQuestionsView = false
    
    @State private var chosenAnswers : [Int] = [-1,-1,-1]
    @State private var chosenQuestions: [String] = ["","",""]
    @State private var leftQuestions : [String] = ["","",""]
    @State private var rightQuestions : [String] = ["","",""]
    @State private var groupId : String = ""
    @State private var name : String = ""
    @State private var personalAnswers : [Int] = []
    
    @State private var showError : Bool = false
    @State private var refreshFetch : Bool = false
    
    @State private var mainImage : UIImage = UIImage()
    @State private var mainName : String = ""
    


    var body: some View {
        NavigationStack{
            
            ZStack{
                VStack{
                    if(swipeViewLoading){
                        ProgressView()
                    } else {
                        InfiniteSwipeView(profiles: $profiles, showMatchView: $showMatchView, matchName: $matchName, matchImage: $matchImage, matchId: $matchId, chosenAnswers: $chosenAnswers, chosenQuestions:$chosenQuestions,leftQuestions: $leftQuestions, rightQuestions:$rightQuestions, refreshFetch: $refreshFetch, personalAnswers: personalAnswers, onSwiped: { userModel, hasLiked in
                            firestoreViewModel.swipeUser(teamSwipe:swipeForTeam, groupId: groupId, name: name, swipedUserId: userModel.userId, hasLiked: hasLiked, chosenAnswers: chosenAnswers, chosenQuestions:chosenQuestions,leftQuestions: leftQuestions, rightQuestions:rightQuestions, onMatch: {
                                matchName = userModel.name
                                matchId = userModel.userId
                                matchImage = userModel.pictures.first!
                                withAnimation{
                                    showMatchView.toggle()
                                }
                            })
                            
                            
                        })
                    }
                }
                .onAppear(perform: performOnAppear)
                .onDisappear(perform: clearQuery)
                .onChange(of: refreshFetch) { newValue in
                    fetchNextProfiles()
      
                }
        
                
                
                if(showMatchView){
                    
                    MatchView(matchName: matchName, matchImage: matchImage, mainName: mainName, mainImage: mainImage, onSendMessageButtonClicked: {
                        withAnimation{
                            showMatchView.toggle()
                        }
                    },
                              onKeepSwipingClicked: {
                        withAnimation{
                            showMatchView.toggle()
                        }
                    }, checkOutQuestionsClicked: {
                        withAnimation{
                            showMatchView.toggle()
                            showQuestionsView.toggle()
                            
                        }
                    })
                }
                
                if(showQuestionsView){
                    MatchQuestionsView(matchName: matchName, matchId: matchId, matchImage: matchImage, mainImage: mainImage){
                        withAnimation{
                            showQuestionsView.toggle()
                            
                        }
                    } onKeepSwipingClicked: {
                        withAnimation{
                            showQuestionsView.toggle()
                        }
                    }
                    
                }
                
                
                
                
            }
        }
    }
    private func fetchNextProfiles(){
        print("called to fetch new profiles")

//        if groupId != "" {
//            firestoreViewModel.fetchGroupProfile(groupId:groupId) { result in
//                switch result {
//                case .success(let group):
//                    if group.isPartOfSwipe {
//                        populateData(groupInfo: group)
//                        firestoreViewModel.fetchGroupNewProfiles(initialFetch: false, profiles: profiles, groupId: group.id, onCompletion: {result in
//
//                            switch(result){
//                            case .success(let newProfiles):
//
//                                self.profiles.insert(contentsOf: newProfiles, at: 0)
//                                swipeViewLoading = false
//                                return
//                            case .failure(_):
//                                print("big ol error for fetching amtches")
//                                return
//                            }
//                        })
//
//                    }
//                    print("not is swipe, should be going into single fetching new profiles")
//
//                case .failure(let error):
//                    print("Error retrieving group for checking of discoverable \(error)")
//                    //show error
//                    return
//                }
//            }
//        }
        print("checking single profiles")
        firestoreViewModel.fetchNewProfiles(initialFetch: false, profiles: profiles, onCompletion: {result in
            switch(result){
            case .success(let newProfiles):
                
                self.profiles.insert(contentsOf: newProfiles, at: 0)

                swipeViewLoading = false
                return
            case .failure(_):
                print("massive error fetching")
                return
            }
        })
    }


    private func clearQuery(){
        firestoreViewModel.clearQuery()
        firestoreViewModel.setProfiles(profiles: profiles)
        self.profiles = []
    }
    private func populateData(groupInfo : FirestoreSquad){
        print("GROUP INFO \(groupInfo.isPartOfSwipe)")
            swipeForTeam = groupInfo.isPartOfSwipe
        name = groupInfo.teamName
    }
    private func performOnAppear(){
        let completedProfiles = firestoreViewModel.fetchCompltetedProfiles()
        if completedProfiles.isEmpty{
            fetchProfiles()
        }else{
            profiles = completedProfiles
        }
    }

    private func fetchProfiles(){
        swipeViewLoading = true
        
 
        profileViewModel.fetchUserWO { result in
            switch result {
            case .success(let user):
                let username = user.name
                let groupId = user.groupId ?? ""
                let userAnswers = user.answersToGlobalQuestions
                personalAnswers = userAnswers
                profileViewModel.fetchMainPicture(profileId: profileViewModel.fetchUserId()) { result in
                    switch result{
                    case .success(let image):
                        mainImage = image
                    case .failure(let error):
                        print("error retrieving users profile picture \(error)")
                        
                    }
                }
                
//                if groupId != "" {
//                    firestoreViewModel.fetchGroupProfile(groupId:groupId) { result in
//                        switch result {
//                        case .success(let group):
//                            if group.isPartOfSwipe {
//                                print("for part of swipe ")
//                                populateData(groupInfo: group)
//                                firestoreViewModel.fetchGroupNewProfiles(initialFetch: true, profiles: profiles, groupId: group.id, onCompletion: {result in
//                                   
//                                    switch(result){
//                                    case .success(let profiles):
//                                        print("success fetching profiles")
//                                        self.profiles = profiles
//                                        swipeViewLoading = false
//                                        return
//                                    case .failure(_):
//                                        print("big ol error for fetching amtches")
//                                        return
//                                    }
//                                })
//                                
//                            }
//                            print("not is swipe, should be going into single fetching new profiles")
//
//                        case .failure(let error):
//                            print("Error retrieving group for checking of discoverable \(error)")
//                            //show error
//                            return
//                        }
//                    }
//                }
                print("checking single profiles")
                firestoreViewModel.fetchNewProfiles(initialFetch: true, profiles: profiles, onCompletion: {result in
                    switch(result){
                    case .success(let profiles):
                        self.profiles = profiles
                        swipeViewLoading = false
                        return
                    case .failure(_):
                        print("massive error fetching")
                        return
                    }
                })
                
                
            case .failure(let error):
                print("MAssive error fetching")
                showError = true
                return
                
            }
        }
    }
}

//
struct InfiniteScrollView_Previews: PreviewProvider {
    static let ownQuestions : [String] = [
        "Where do I enjoy the room's attention being casted on?",
        "How often am I on my phone?",
        "How do I view exercise?",
        "How do I handle conflict?",
        "How do I recharge my battery?"
    ]
    static let answerToGlobalQuestions : [Int] = [1,1,2,7,7,6,5,4,3,2,2,1,2,3,4,5,5,6,7,7]
    static let ownLeftQuestions: [String] = ["1 left", "2 left", "3 left", "4 left", "5 left"]
    static let ownRightQuestions: [String] = ["1 right", "2 right", "3 right", "4 right", "5 right"]
//    static let nameAndPic : [NameAndProfilePic] = [NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions1),NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions2),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions3),NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions2),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions)]
    static let profile1 =   NewUserProfile(userId: "", name: "Annabelle", age: 22, bio: "I am a goofy goober hehehe", amountOfUsers: 6, isATeam: true, interests: ["snowboarding!!","snowboarding!!?", "snowboarding!!", "snowboarding!!","snowboarding!!","snowboarding!!"], college: "Santa Clara University", occupation: "Soul Brother", formPreference: 1, interactionPreference: 1, maxDistancePreference: 1, maxYearPreference: 1, minYearPreference: 1, answersToGlobalQuestions: answerToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftQuestions, ownRightAnswer: ownRightQuestions, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!], nameAndPic: [], city: "Virtual")
    static let profile2 =  NewUserProfile(userId: "", name: "bob", age: 22, bio: "I am a goofy goober hehehe", amountOfUsers: 6, isATeam: true, interests: ["snowboarding!!","snowboarding!!?", "snowboarding!!", "snowboarding!!","snowboarding!!","snowboarding!!"], college: "Santa Clara University", occupation: "Soul Brother", formPreference: 1, interactionPreference: 1, maxDistancePreference: 1, maxYearPreference: 1, minYearPreference: 1, answersToGlobalQuestions: answerToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftQuestions, ownRightAnswer: ownRightQuestions, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!], nameAndPic: [], city: "Virtual")
    @State static var profiles : [NewUserProfile] = [ profile1, profile2]


    static var previews: some View {
        InfiniteScrollView()
    }
}

