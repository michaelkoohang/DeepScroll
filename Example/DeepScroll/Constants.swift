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
    let post: String
}

struct Feed: Decodable {
    let posts: [Post]
}
