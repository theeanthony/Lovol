//
//  FetchedEvent.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/27/22.
//

import Foundation


struct FetchedEvent: Hashable {
    
    let photoURLS : [String]
    let groupId: String
    let eventName: String
    let eventType: String
    let eventMonth : String
    let teamName : String
    
    let id: String
    let documentId : String
    
    let likes : Int
    let comments: Int 
    let didILike : Bool
    
    let timeStamp : String
    let caption: String
    var showCaption : Bool = false
    
    static func == (lhs: FetchedEvent, rhs: FetchedEvent) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
}
extension FetchedEvent : Codable {
    enum CodingKeys: String, CodingKey {
        case photoURLS
        case groupId
        case eventName
        case eventType
        case eventMonth
        case teamName
        case documentId
        case id
        case likes
        case comments
        case didILike
        case timeStamp
        case caption
        case showCaption 
    }
}

struct CompletedEvent: Hashable {
    
    let photoURL : [String]
    let eventName: String
    let eventMonth : String
    let eventPoints : Int
    let id: String
    let submittedForPoints : Bool
    let eventType : String

    
    static func == (lhs: CompletedEvent, rhs: CompletedEvent) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
}
extension CompletedEvent : Codable {
    enum CodingKeys: String, CodingKey {
        
        case photoURL
        case eventName
        case eventMonth
        case eventPoints
        case id
        case submittedForPoints
        case eventType
        
    }

    
}
