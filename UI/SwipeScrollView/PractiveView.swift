//
//  InfiniteSwipeCardView.swift
//
//  InfiniteSwipeCardView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/10/22.
//

import SwiftUI

struct PracticeView: View {

    @State private var testing : [String] = []
    var body: some View {
        VStack{
            ForEach(testing.indices, id:\.self){
                index in
                Text(testing[index])
            }
        }
        .onAppear(perform: test)
        
    }
    private func test(){
        
        var test1 : [String ] = ["a","b","c"]
        var test2 : [String ] = ["a","b","c", "d", "e", "f", "a", "b","c"]
        
        var test3 : [String] = filters(newProfiles: test1, profiles: test2)
        test1.insert(contentsOf: test3, at: 0)
        self.testing = test3

    }
    private func filters(newProfiles : [String], profiles: [String]) -> [String]{
        var a = profiles
        a.reverse()
        var newProfile = a.removingDuplicates()

        newProfile.reverse()
        return newProfile
    }
     
   
}

struct PracticeView_Previews: PreviewProvider {

    


    static var previews: some View {
        PracticeView()
                              }
}
                             
