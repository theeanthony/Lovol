//
//  LeaderBoardModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/29/23.
//

import Foundation
import SwiftUI

struct LeaderBoardModel {
    
    let teamName : String
    
    let teamPoints : Int
    
    let teamPic : UIImage
    
    
}

struct BoardModel  {
    
    let teamName : String
    
    let teamPoints : Int
    
    let ranking : Int
    
    let id : String
    
//    func compareTypes(_ inA: BoardModel, _ inB: BoardModel) -> String {
//        if inA.teamPoints == inB.teamPoints { // We compare UUIDs.
//            return ""
//        }
//        return "not "
//    }
    
    
}
