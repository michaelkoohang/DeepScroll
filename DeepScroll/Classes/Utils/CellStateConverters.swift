//
//  CellStateConverters.swift
//  DeepScroll
//
//  Created by Parth Tamane on 11/11/19.
//

import Foundation

/**
 Gives the state of the cell based on touch location and compresion direction.
 
 - Parameter compressionDirection: The compression direction LTR / RTL.
 - Parameter touchSection: The section of the screen that was touched Left / Right / Center.
 
 - Returns: The state in which the cell is Condensed / Collapsed / Normal.
 */

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
    }
}
