//
//  MatchModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//

import UIKit

struct MatchModel: Identifiable{
    let id: String
    let userId: String
    let name: String
    let birthDate: Date
    let picture: UIImage
    let lastMessage: String?
    let isGroup: Bool 
    
    var age: Int{
        Date().years(from: birthDate)
    }
}
