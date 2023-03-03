//
//  FirestoreSquad.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import Foundation

struct FirestoreSquad: Identifiable{
    let id : String
    let teamName : String
    var bio: String
    var birthDate : Date
    let usersInGroup: [String]
    let liked: [String]
    let passed: [String]
    let groupInterests : [String]
    var answers: [Int]
    let groupCollege: String
    let groupOccupation: String
    
    var formPreference : Int
    var interactionPreference : Int
    var maxDistancePreference: Double
    var maxYearPreference : Int
    var minYearPreference : Int
    var ownLeftAnswer: [String]
    var ownRightAnswer: [String]
    var ownQuestions: [String]
    let isPartOfSwipe: Bool
    let points: Int
    let city: String
    let longitude: Double
    let latitude: Double
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
extension FirestoreSquad: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case teamName
        case bio
        case birthDate 
        case usersInGroup
        case liked
        case passed
        case groupInterests
        case answers
        case groupCollege
        case groupOccupation
        case formPreference
        case interactionPreference
        case maxDistancePreference
        case maxYearPreference
        case minYearPreference
        
        case ownLeftAnswer
        case ownRightAnswer
        case ownQuestions
//        case filters
        case isPartOfSwipe
        case points
        case city
        case longitude
        case latitude 

        
    }
}
