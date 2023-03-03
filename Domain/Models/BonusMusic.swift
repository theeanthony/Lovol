//
//  BonusMusic.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore


struct BonusMusicVideo {
    
    let name : String
    let description: String
    let rules : String
    let type : String
    let choices : [String]
    let example : String
    let points : Int
    
    
}
extension BonusMusicVideo: Codable {
    enum CodingKeys: String, CodingKey {
        
        case name
        case description
        case rules
        case type
        case choices
        case example
        case points 
        
    }
}
