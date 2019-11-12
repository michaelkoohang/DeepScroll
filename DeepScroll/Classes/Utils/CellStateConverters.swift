//
//  CellStateConverters.swift
//  DeepScroll
//
//  Created by Parth Tamane on 11/11/19.
//

import Foundation

func getCellState(compressionDirection: CompressionDirection, touchSection: TouchSection) -> CellState {
    switch compressionDirection {
    case .LTR:
        switch touchSection {
        case .right:
            return .condensed
        case .center:
            return .collapsed
        case .left:
            return .normal
        default:
            return .normal
        }
    case .RTL:
        switch touchSection {
        case .right:
            return .normal
        case .center:
            return .collapsed
        case .left:
            return .condensed
        default:
            return .normal
        }
    default:
        return .normal
    }
}
