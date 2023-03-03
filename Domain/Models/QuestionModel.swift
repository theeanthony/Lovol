//
//  QuestionModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/14/22.
//

import Foundation


struct QuestionModel: Codable{
   
    let id : String
    let question : String
    let leftAnswer: String
    let rightAnswer: String
    
    
}


struct QuestionData : Codable {
    let questions : [QuestionModel]
    

}
func loadQuestionJSON() -> [QuestionModel] {
        print("loading interest JSON")
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
            do {
                print("deoding information")
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(QuestionData.self, from: data)
                return jsonData.questions
            } catch {
                print("error:\(error)")
            }
        }
        return []
}
