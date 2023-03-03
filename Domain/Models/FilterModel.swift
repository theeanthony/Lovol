//
//  FilterModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/16/22.
//

import Foundation

struct FilterModel {
    
    var amountOfPeoplePreference : Int
    var genderPreference : Int
    var interactionPreference : Int
    var formPreference : Int
    var minYear : Int
    var maxYear : Int
    var maxDistance : Double
    
    var dictionary: [String: Any] {
           let data = (try? JSONEncoder().encode(self)) ?? Data()
           return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
       }
}

extension FilterModel: Codable {
    enum CodingKeys: String, CodingKey {
        case amountOfPeoplePreference
        case genderPreference
        case interactionPreference
        case formPreference
        case minYear
        case maxYear
        case maxDistance
        
    }
}
