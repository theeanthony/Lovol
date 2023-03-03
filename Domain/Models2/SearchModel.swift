//
//  SearchModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import Foundation
import SwiftUI

struct SearchModel: Identifiable {
    let id : String
    let teamName : String
    let teamDescription : String
    let teamMemberNames : [String]
    let teamMemberIDS : [String]
    let teamMemberRoles : [String]
//    let teamMemberProfilePics : [String]
    let exists: Bool
//    let teamPic : Image
    
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    init(){
        self.id = ""
        self.teamName = ""
        self.teamDescription = ""
        self.teamMemberNames = []
        self.teamMemberIDS = []
        self.teamMemberRoles = []
//        self.teamMemberProfilePics = []
        self.exists = false 
    }
}
    

extension SearchModel: Codable {
        enum CodingKeys: String, CodingKey {
            case id
            case teamName
            case teamDescription
            case teamMemberNames
            case teamMemberIDS
            case teamMemberRoles
//            case teamMemberProfilePics
            case exists
//            case teamPic
            
        }
    }
    
