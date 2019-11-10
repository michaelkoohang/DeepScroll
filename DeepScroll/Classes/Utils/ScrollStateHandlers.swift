//
//  ScrollStateHandlers.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//

import Foundation


func makeScrollStateObject(for lanedScrollerId: Int, touchSection: TouchSection) -> [String:String] {
    return [String(lanedScrollerId):"\(touchSection)"]
}


func sendScrollStateNotification(for lanedScrollerId: Int, touchSection: TouchSection) {
    let scrollState = makeScrollStateObject(for: lanedScrollerId, touchSection: touchSection)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollState"), object: nil, userInfo: scrollState)
}


func resetScrollState(for lanedScrollerId: Int) {
    let touchSction: TouchSection = .right
    sendScrollStateNotification(for: lanedScrollerId, touchSection: touchSction)
}
