//
//  FirestoreUser2.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//
import Foundation


 struct FirestoreUser2 {
    
//     @DocumentID var id : String? = UUID().uuidString
    var name: String
    let birthDate: Date
    var bio: String
    let gender: String
     let interests : [String]
     let college: String
     let occupation: String
     
     var formPreference : Int
//     var genderPreference: Int
     var interactionPreference: Int
     var maxDistancePreference : Double
     var maxYearPreference : Int
     var minYearPreference: Int
     var pronouns : String
     var answersToGlobalQuestions : [Int]
     var ownQuestions: [String]
     var ownAnswers : [Int]
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
     
     let swipeForTeam: Bool?
     
     let city: String
   
    
    var age: Int{
        return Date().years(from: birthDate)
    }
     var dictionary: [String: Any] {
            let data = (try? JSONEncoder().encode(self)) ?? Data()
            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
        }
//     var dictionaryForNumbers: [String: Any] {
//            let data = (try? JSONEncoder().encode(self)) ?? Data()
//            return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
//        }
    
    func contains(_ string: String) -> Bool {
        let properties = [name].map { $0.lowercased() }
        let query = string.lowercased()
        
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
     


}
extension FirestoreUser2: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case bio
        case gender 
        case interests
        case college
        case occupation
        
        case formPreference
//        case genderPreference
        case interactionPreference
        case maxDistancePreference
        case maxYearPreference
        case minYearPreference
        case pronouns
        case answersToGlobalQuestions
        case ownQuestions
        case ownAnswers
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
        case swipeForTeam
        case city
        
    }
}


extension FirestoreUser2 {
    static let testUser = FirestoreUser2(name: "Anthony", birthDate: Date(), bio: "I like cheese", gender: "male", interests: [], college: "", occupation: "",  formPreference: 2, interactionPreference: 2, maxDistancePreference: 2, maxYearPreference: 100, minYearPreference: 18, pronouns: "he/him/his", answersToGlobalQuestions: [], ownQuestions: [], ownAnswers: [], ownLeftAnswer: [], ownRightAnswer: [], liked: [], passed: [], groupId:"" ,isATeam: false, isDiscoverable: false, amountOfUsers: 1,  swipeForTeam: false, city: "San Jose")
}

struct Root2: Decodable {
    let answer : FirestoreUser2
}
