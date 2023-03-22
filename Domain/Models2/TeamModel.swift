//
//  TeamModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import Foundation
import SwiftUI

struct TeamModel {
    
    
    var teamName : String
    var teamDescription: String
    var teamRule : Bool
    
    var city : String?
    var long: Double?
    var lat: Double?
    
}

struct RSVPTeam {
    
    var teamName : String
    var teamId : String
    var rsvps : [String]
}
