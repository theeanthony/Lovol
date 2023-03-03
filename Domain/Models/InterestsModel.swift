//
//  InterestsModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/7/22.
//

import Foundation

struct InterestsModel: Codable{
   
    let category : String
    
    let specifics : [String]
    
}


struct InterestData : Codable {
    let interests : [InterestsModel]
    

}
func loadInterestJson() -> [InterestsModel] {
        print("loading interest JSON")
        if let url = Bundle.main.url(forResource: "interests", withExtension: "json") {
            do {
                print("deoding information")
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(InterestData.self, from: data)
                return jsonData.interests
            } catch {
                print("error:\(error)")
            }
        }
        return []
}
