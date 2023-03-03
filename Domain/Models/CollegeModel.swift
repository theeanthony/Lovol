//
//  CollegeModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/8/22.
//

import Foundation

struct CollegeModel: Codable{
   
    let institution : String
    
    
}


struct CollegeData : Codable {
    let institution : [CollegeModel]
    

}
func loadCollegeJson() -> [CollegeModel] {
        print("loading interest JSON")
        if let url = Bundle.main.url(forResource: "colleges", withExtension: "json") {
            do {
                print("deoding information")
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(CollegeData.self, from: data)
                return jsonData.institution
            } catch {
                print("error:\(error)")
            }
        }
        return []
}
