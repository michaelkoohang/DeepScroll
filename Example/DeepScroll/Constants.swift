//
//  Constants.swift
//  DeepScroll_Example
//
//  Created by Parth Tamane on 06/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct Post: Decodable {
    let id: Int
    let name: String
    let profileUrl: String
    let data: String
    let likes: Int
    let comments: Int
}

struct Feed: Decodable {
    let posts: [Post]
}
