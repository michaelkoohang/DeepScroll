//
//  Enums.swift
//  DeepScroll
//
//  Created by Parth Tamane on 31/10/19.
//

import Foundation
import UIKit

//let containerView = UIApplication.shared.windows.first!.rootViewController?.view
let width = UIScreen.main.bounds.width

enum TouchSection {
    case left
    case center
    case right
    case none
}

enum CellState {
    case normal
    case collapsed
    case condensed
}

enum CompressionDirection {
    case LTR
    case RTL
}

enum ScrollLaneWidthRatio {
    case equal
    case increasing
}

enum LaneXBound {
    case lower
    case upper
}

enum EqualLaneXUpperBound {
    case left, center, right
    
    var rawValue: CGFloat {
        get {
            switch self {
            case .left:
                return (1/3*width)
            case .center:
                return (2/3*width)
            case .right:
                return width
            }
        }
    }
}

enum IncreasingLaneXUpperBoundRTL {
    case left, center, right
    
    var rawValue: CGFloat {
        get {
            switch self {
            case .left:
                return (2/9*width)
            case .center:
                return (5/9*width)
            case .right:
                return width
            }
        }
    }
}

enum IncreasingLaneXUpperBoundLTR {
    case left, center, right
    
    var rawValue: CGFloat {
        get {
            switch self {
            case .left:
                return (4/9*width)
            case .center:
                return (7/9*width)
            case .right:
                return width
            }
        }
    }
}
