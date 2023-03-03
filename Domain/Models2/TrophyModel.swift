//
//  TrophyModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/23/23.
//

import Foundation
import SwiftUI

struct TrophyModel:  Equatable, Identifiable{
    let id : String
    let name : String
    let description: String
    let image : String
   
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}
extension TrophyModel : Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case image
    }

}
struct TrophyResponse : Codable {
    let trophies : [TrophyModel]
    

}
func loadTrophyJSON() -> [TrophyModel] {
        if let url = Bundle.main.url(forResource: "Trophy", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                print(data)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(TrophyResponse.self, from: data)
                return jsonData.trophies
            } catch {
                print("error:\(error)")
            }
        }
        return []
}

struct FirebaseTrophyModel {
    
    let trophy : TrophyModel
    var completed : Bool = false
}
//struct FirebaseTrophiesModel {
//    var trophies : [FirebaseTrophyModel]
//}

