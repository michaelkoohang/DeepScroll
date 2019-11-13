//
//  ScrollStateHandlers.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//

import Foundation
import UIKit

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

func getLaneXBounds(with ratio: ScrollLaneWidthRatio, for lane: TouchSection) ->[LaneXBound:CGFloat] {
    var bounds: [LaneXBound: CGFloat] = [:]
    switch ratio {
    case .equal:
        switch lane {
        case .left:
            bounds[LaneXBound.lower] = CGFloat(0.0)
            bounds[LaneXBound.upper] = EqualLaneXUpperBound.left.rawValue
            return bounds

        case .center:
            bounds[LaneXBound.lower] = EqualLaneXUpperBound.left.rawValue
            bounds[LaneXBound.upper] = EqualLaneXUpperBound.center.rawValue
            return bounds
            
        case .right:
            bounds[LaneXBound.lower] = EqualLaneXUpperBound.center.rawValue
            bounds[LaneXBound.upper] = EqualLaneXUpperBound.right.rawValue
            return bounds
            
        case .none:
            break
        }
    case .increasing:
        switch lane {
        case .left:
            bounds[LaneXBound.lower] = CGFloat(0.0)
            bounds[LaneXBound.upper] = IncreasingLaneXUpperBound.left.rawValue
            return bounds

        case .center:
            bounds[LaneXBound.lower] = IncreasingLaneXUpperBound.left.rawValue
            bounds[LaneXBound.upper] = IncreasingLaneXUpperBound.center.rawValue
            return bounds
            
        case .right:
            bounds[LaneXBound.lower] = IncreasingLaneXUpperBound.center.rawValue
            bounds[LaneXBound.upper] = IncreasingLaneXUpperBound.right.rawValue
            return bounds
            
        case .none:
            break
        }
    }
    bounds[LaneXBound.lower] = EqualLaneXUpperBound.center.rawValue
    bounds[LaneXBound.upper] = EqualLaneXUpperBound.right.rawValue
    return bounds
}

func getLaneWidth(with ratio: ScrollLaneWidthRatio, for lane: TouchSection) -> CGFloat {
    switch ratio {
    case .equal:
        switch lane {
        case .left:
            return (EqualLaneXUpperBound.left.rawValue - CGFloat(0.0))

        case .center:
            return (EqualLaneXUpperBound.center.rawValue - EqualLaneXUpperBound.left.rawValue)
            
        case .right:
            return (EqualLaneXUpperBound.right.rawValue - EqualLaneXUpperBound.center.rawValue)
        
        case .none:
            break
        }
    case .increasing:
        switch lane {
        case .left:
            return (IncreasingLaneXUpperBound.left.rawValue - CGFloat(0.0))
        
        case .center:
            return (IncreasingLaneXUpperBound.center.rawValue - IncreasingLaneXUpperBound.left.rawValue)
            
        case .right:
            return (IncreasingLaneXUpperBound.right.rawValue - IncreasingLaneXUpperBound.center.rawValue)
            
        case .none:
            break
        }
    }
    return (EqualLaneXUpperBound.left.rawValue - CGFloat(0.0))
}
