//
//  FirestoreMatch.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//

import Foundation

struct FirestoreMatch: Codable {
    let usersMatched: [String]
    let timestamp: Date
    let isGroupMatch : Bool
    
    
    var dictionary: [String: Any] {
           let data = (try? JSONEncoder().encode(self)) ?? Data()
           return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
       }

}

//extension FirestoreMatch: Codable {
//    enum CodingKeys: String, CodingKey{
//        case usersMatched
//        case timeStamp
//    }
//}
