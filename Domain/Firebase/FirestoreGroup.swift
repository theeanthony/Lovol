//
//  FirestoreGroup.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/24/22.
//

import Foundation

struct FirestoreGroup: Identifiable {
    let id : String
    let teamName : String
    var bio: String
    let usersInGroup: [String]
    let liked: [String]
    let passed: [String]
    let isMale: Bool
//    let orientation: Orientation
    
    let groupInterests : [String]
    var answersToGlobalQuestions: [Int]
    let groupCollege: String
    let groupOccupation: String
    
    var amountOfPeoplePreference : Int
    var formPreference : Int
    var genderPreference : Int
    var interactionPreference : Int
    var maxDistancePreference: Double
    var maxYearPreference : Int
    var minYearPreference : Int
    
    var ownLeftAnswer: [String]
    var ownRightAnswer: [String]
    var ownQuestions: [String]
//    var filters : FilterModel
    
    
    let isPartOfSwipe: Bool
    
    let birthDate: Date
    
    let completeMatchData : Bool
    let teamNames : [String]
    
    let points: Int
    let city: String
    
    var dictionary: [String: Any] {
           let data = (try? JSONEncoder().encode(self)) ?? Data()
           return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
       }
    init() {
        self.id = ""
        self.teamName = ""
        self.bio = ""
        self.usersInGroup = []
        self.liked = []
        self.passed = []
        self.isMale = false
//        self.orientation = .both
        self.groupInterests = []
        self.answersToGlobalQuestions = []
        self.groupCollege = ""
        self.groupOccupation = ""
        self.amountOfPeoplePreference = 0
        self.formPreference = 0
        self.genderPreference = 0
        self.interactionPreference = 0
        self.maxDistancePreference = 0
        self.maxYearPreference = 0
        self.minYearPreference = 0
        self.ownLeftAnswer = []
        self.ownRightAnswer = []
        self.ownQuestions = []
        self.isPartOfSwipe = false
        self.birthDate = Date()
        self.completeMatchData = false
        self.teamNames = []
        self.points = 0
        self.city = ""
    }
    
}

extension FirestoreGroup: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case teamName
        case bio
        case usersInGroup
        case liked
        case passed
        case isMale
//        case orientation
        case groupInterests
        case answersToGlobalQuestions
        case groupCollege
        case groupOccupation
        case amountOfPeoplePreference
        case formPreference
        case genderPreference
        case interactionPreference
        case maxDistancePreference
        case maxYearPreference
        case minYearPreference
        
        case ownLeftAnswer
        case ownRightAnswer
        case ownQuestions
//        case filters
        case isPartOfSwipe
        case birthDate
        case completeMatchData
        case teamNames
        case points
        case city

        
    }
}
