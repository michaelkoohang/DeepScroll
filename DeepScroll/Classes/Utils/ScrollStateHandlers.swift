//
//  ScrollStateHandlers.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//

import Foundation
import UIKit

/**
 Gives a notification object for scrolled laned scroller id.
 
 - Parameter for: Id of the laned scroller that was interacted with.
 - Parameter touchSection: The part of the screen that was touched.
 
 - Returns: Object with laned scroller id and touch section.
 */

func makeScrollStateObject(for lanedScrollerId: Int, touchSection: TouchSection) -> [String:String] {
    return [String(lanedScrollerId):"\(touchSection)"]
}

/**
 Sends a notification informing which laned scroller was scrolled.
 
 - Parameter for: Id of the laned scroller that was interacted with.
 - Parameter touchSection: The part of the screen that was touched.
 */

func sendScrollStateNotification(for lanedScrollerId: Int, touchSection: TouchSection) {
    let scrollState = makeScrollStateObject(for: lanedScrollerId, touchSection: touchSection)
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollState"), object: nil, userInfo: scrollState)
}

/**
Gives the x min and x max for a lane for distribution of widths and compression direction.

- Parameter with: Ratio of scroll lane's widths - Equal / Increasing.
- Parameter for: Touch section Left / Right / Center.
- Parameter direction: Compression direction of cells LTR / RTL.

- Returns: Dictionary of lower and upper x bounds of a lane.
*/

func getLaneXBounds(with ratio: ScrollLaneWidthRatio, for lane: TouchSection, direction: CompressionDirection ) ->[LaneXBound:CGFloat] {
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
        switch direction {
        case .RTL:
            switch lane {
            case .left:
                bounds[LaneXBound.lower] = CGFloat(0.0)
                bounds[LaneXBound.upper] = IncreasingLaneXUpperBoundRTL.left.rawValue
                return bounds
                
            case .center:
                bounds[LaneXBound.lower] = IncreasingLaneXUpperBoundRTL.left.rawValue
                bounds[LaneXBound.upper] = IncreasingLaneXUpperBoundRTL.center.rawValue
                return bounds
                
            case .right:
                bounds[LaneXBound.lower] = IncreasingLaneXUpperBoundRTL.center.rawValue
                bounds[LaneXBound.upper] = IncreasingLaneXUpperBoundRTL.right.rawValue
                return bounds
                
            case .none:
                break
            }
            
        case .LTR:
            switch lane {
            case .left:
                bounds[LaneXBound.lower] = CGFloat(0.0)
                bounds[LaneXBound.upper] = IncreasingLaneXUpperBoundLTR.left.rawValue
                return bounds
                
            case .center:
                bounds[LaneXBound.lower] = IncreasingLaneXUpperBoundLTR.left.rawValue
                bounds[LaneXBound.upper] = IncreasingLaneXUpperBoundLTR.center.rawValue
                return bounds
                
            case .right:
                bounds[LaneXBound.lower] = IncreasingLaneXUpperBoundLTR.center.rawValue
                bounds[LaneXBound.upper] = IncreasingLaneXUpperBoundLTR.right.rawValue
                return bounds
                
            case .none:
                break
            }
        }
    }
    bounds[LaneXBound.lower] = EqualLaneXUpperBound.center.rawValue
    bounds[LaneXBound.upper] = EqualLaneXUpperBound.right.rawValue
    return bounds
}

/**
 Gives the width a lane for distribution of widths and compression direction.
 
 - Parameter with: Ratio of scroll lane's widths - Equal / Increasing.
 - Parameter for: Touch section Left / Right / Center.
 - Parameter direction: Compression direction of cells LTR / RTL.

 - Returns: Width of a scroll lane.
 */

func getLaneWidth(with ratio: ScrollLaneWidthRatio, for lane: TouchSection, direction: CompressionDirection) -> CGFloat {
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
        switch direction {
        case .RTL:
            switch lane {
            case .left:
                return (IncreasingLaneXUpperBoundRTL.left.rawValue - CGFloat(0.0))
                
            case .center:
                return (IncreasingLaneXUpperBoundRTL.center.rawValue - IncreasingLaneXUpperBoundRTL.left.rawValue)
                
            case .right:
                return (IncreasingLaneXUpperBoundRTL.right.rawValue - IncreasingLaneXUpperBoundRTL.center.rawValue)
                
            case .none:
                break
            }
            
        case .LTR:
            switch lane {
            case .left:
                return (IncreasingLaneXUpperBoundLTR.left.rawValue - CGFloat(0.0))
                
            case .center:
                return (IncreasingLaneXUpperBoundLTR.center.rawValue - IncreasingLaneXUpperBoundLTR.left.rawValue)
                
            case .right:
                return (IncreasingLaneXUpperBoundLTR.right.rawValue - IncreasingLaneXUpperBoundLTR.center.rawValue)
                
            case .none:
                break
            }
        }
        
    }
    return (EqualLaneXUpperBound.left.rawValue - CGFloat(0.0))
}

/**
 Get the lane of normal cell state for a compression direction.
 
 - Returns: Lane of normal cell state.
 */

func getNormalStateLane(compressionDirection: CompressionDirection) -> TouchSection {
    switch compressionDirection {
    case .RTL:
        return .right
    case .LTR:
        return .left
    }
}
