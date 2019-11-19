//
//  Constants.swift
//  DeepScroll_Example
//
//  Created by Parth Tamane on 06/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

// Struct used to store data for posts in Facebook feed UI.
struct Post: Decodable {
    let id: Int
    let name: String
    let profileUrl: String
    let data: String
    let likes: Int
    let comments: Int
}

// Struct used to store posts for feed in Facebook feed UI.
struct Feed: Decodable {
    let posts: [Post]
}
