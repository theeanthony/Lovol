//
//  FirestoreRequest.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/26/22.
//

import Foundation


struct FirestoreRequest {
    
//    let id: String
    let groupId: String
    let sendingRequestId: String
    let nameOfSender: String
    let sendRole : String
    
    var isFriends = false
    var isATeam = false 
    
    var dictionary: [String: Any] {
           let data = (try? JSONEncoder().encode(self)) ?? Data()
           return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
       }
    func contains(_ string: String) -> Bool {
        let properties = [sendingRequestId, nameOfSender].map { $0.lowercased() }
        let query = string.lowercased()
        
        let matches = properties.filter { $0.contains(query) }
        return !matches.isEmpty
    }
}
extension FirestoreRequest: Codable{
    enum CodingKeys: String, CodingKey {
        case groupId
        case sendingRequestId
        case nameOfSender
        case sendRole
        case isFriends
        case isATeam
    }

}
