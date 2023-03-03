//
//  FireMember.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/18/23.
//

import Foundation

struct FireMember : Identifiable{
    
    let id : String
    let name : String
    let role : String
        
    let groupId : String
    let groupName : String
    
    var over21 : Bool
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    
    
}
extension FireMember : Codable {
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case role
        case groupId
        case groupName
        case over21
        
               
    }
}


