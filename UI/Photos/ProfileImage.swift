//
//  ProfileImage.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//

import Foundation
import SwiftUI

struct ProfileImage: View {
    let url: URL?
 
    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.clear
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.red.opacity(0.25)))
        }
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(url: URL(string: "https://source.unsplash.com/lw9LrnpUmWw/480x480"))
    }
}


