//
//  FirestoreUser.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//

import Foundation
import FirebaseFirestoreSwift


 struct FirestoreUser {
    
//     @DocumentID var id : String? = UUID().uuidString
    var name: String
    let birthDate: Date
    var bio: String
    let isMale: Bool
//    let orientation: Orientation
     let interests : [String]
     let college: String
     let occupation: String
     
     var amountOfPeoplePreference : Int
     var formPreference : Int
     var genderPreference: Int
     var interactionPreference: Int
     var maxDistancePreference : Double
     var maxYearPreference : Int
     var minYearPreference: Int
     
     var answersToGlobalQuestions : [Int]
     var ownQuestions: [String]
     var ownLeftAnswer: [String]
     var ownRightAnswer: [String]
     var longitude : Double?
     var latitude : Double?
//     var filters: FilterModel

    let liked: [String]
    let passed: [String]
          
     let groupId : String?
     
     let isATeam: Bool
     let isDiscoverable: Bool
     let amountOfUsers: Int
     
     let completedMatchData : Bool
     let swipeForTeam: Bool?
     
     let swipeId : String?
     
     let teamNames : [String]?
     
     let city: String
   
    
    var age: Int{
        return Date().years(from: birthDate)
    }
     var dictionary: [String: Any] {
            let data = (try? JSONEncoder().encode(self)) ?? Data()
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
        }
    
    func contains(_ string: String) -> Bool {
        let properties = [name].map { $0.lowercased() }
        let query = string.lowercased()
        
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
     


}
extension FirestoreUser: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case bio
        case isMale = "male"
//        case orientation
        case interests
        case college
        case occupation
        
        case amountOfPeoplePreference
        case formPreference
        case genderPreference
        case interactionPreference
        case maxDistancePreference
        case maxYearPreference
        case minYearPreference
        
        case answersToGlobalQuestions
        case ownQuestions
        case ownLeftAnswer
        case ownRightAnswer
        case longitude
        case latitude
//        case filters
        case liked
        case passed
//        case inTeam = "true"
        case groupId
        case isATeam
        case isDiscoverable
        case amountOfUsers
        case completedMatchData
        case swipeForTeam
        case swipeId
        case teamNames
        case city
        
    }
}

//public enum Orientation: String, Codable, CaseIterable{
//    case men, women, both
//}

//extension FirestoreUser {
//    static let testUser = FirestoreUser(name: "Anthony", birthDate: Date(), bio: "I like cheese", isMale: true, orientation: Orientation.women, interests: [], college: "", occupation: "", amountOfPeoplePreference: 1, formPreference: 2, genderPreference: 2, interactionPreference: 2, maxDistancePreference: 2, maxYearPreference: 100, minYearPreference: 18, answersToGlobalQuestions: [], ownQuestions: [], ownLeftAnswer: [], ownRightAnswer: [], liked: [], passed: [], groupId:"" ,isATeam: false, isDiscoverable: false, amountOfUsers: 1, completedMatchData: false, swipeForTeam: false, swipeId: "", teamNames: ["Anthony"], city: "San Jose")
//}
//
//struct Root: Decodable {
//    let answer : FirestoreUser
//}
