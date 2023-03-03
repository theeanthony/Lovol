//
//  FirebaseEvents.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/4/22.
//

import Foundation


struct FirestoreEvents: Codable {
    
    
     let id : String
     let eventName: String
     let eventPoints: Int
    let eventCompleted: Bool
    let timestamp : Date
    
    var dictionary: [String: Any] {
           let data = (try? JSONEncoder().encode(self)) ?? Data()
           return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
       }
    
}
