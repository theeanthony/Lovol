//
//  LocalUser.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/17/22.
//

import Foundation
import SwiftUI

struct LocalUser: Identifiable, Codable {

    var id : String
    var groupId: String
    var userInfo : FirestoreUser2



    init(id : String, groupId: String, userInfo: FirestoreUser2){
        self.id = id
        self.groupId = groupId
        self.userInfo = userInfo
    }

}

extension LocalUser {
    init(data: FirestoreUser2, userId: String) {
        id = userId
        groupId = data.groupId ?? ""
        userInfo = data
    }
    mutating func update(from data: FirestoreUser2, userId: String) {
        userInfo = data
        id = userId
        groupId = data.groupId ?? ""
    }
    struct Data {
        var id: String = ""
        var groupId : String = ""
        var userInfo = FirestoreUser2(name: "", birthDate: Date(), bio: "", gender: "", interests: [], college: "", occupation: "", formPreference: 0, interactionPreference: 0, maxDistancePreference: 0, maxYearPreference: 0, minYearPreference: 0, pronouns: "", answersToGlobalQuestions: [], ownQuestions: [], ownAnswers: [], ownLeftAnswer: [], ownRightAnswer: [], longitude: 0, latitude: 0, liked: [], passed: [], groupId: "", isATeam: false, isDiscoverable: false, amountOfUsers: 0, swipeForTeam: false, city: "")
    }
    
}

class LocalStore: ObservableObject{
    @Published var localUser : [LocalUser] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        .appendingPathComponent("localUser.data")

     }
    
    static func load(completion: @escaping (Result<[LocalUser], Error>)->Void) {
           DispatchQueue.global(qos: .background).async {
               do {
                   let fileURL = try fileURL()
                   guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                       DispatchQueue.main.async {
                           completion(.success([]))
                       }
                       return
                   }
                   let localUser = try JSONDecoder().decode([LocalUser].self, from: file.availableData)
                   DispatchQueue.main.async {
                       completion(.success(localUser))
                   }
               } catch {
                   DispatchQueue.main.async {
                       completion(.failure(error))
                   }
               }
           }
       }
    static func save(localUser: [LocalUser], completion: @escaping (Result<Int, Error>)->Void) {
           DispatchQueue.global(qos: .background).async {
               do {
                   let data = try JSONEncoder().encode(localUser)
                   let outfile = try fileURL()
                   try data.write(to: outfile)
                   DispatchQueue.main.async {
                       completion(.success(localUser.count))
                   }
               } catch {
                   DispatchQueue.main.async {
                       completion(.failure(error))
                   }
               }
           }
       }

}
