//
//  DeepScrollDelegate.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//

import Foundation
import UIKit

public class LanedScrollerDelegate: NSObject, UITableViewDelegate {
    
    let lanedScrollerId: Int
    private var touchSection: TouchSection = .none
    private var leftLaneBounds: [LaneXBound: CGFloat] = [:]
    private var centerLaneBounds: [LaneXBound: CGFloat] = [:]
    private var rightLaneBounds: [LaneXBound: CGFloat] = [:]
    private var resettingLanedScroller = false
    private var resetTimer: Timer = Timer()
    internal var compressionDirection: CompressionDirection = .RTL
    internal var laneWidthRatio: ScrollLaneWidthRatio = .equal
    internal var tapToExpandCell = true
    internal var autoResetCellState = false
    
    convenience override public init() {
        self.init()
    }
    
    init(lanedScrollerId: Int) {
        self.lanedScrollerId = lanedScrollerId
        super.init()
        
        //Setting up lane ratio properties
        setLaneProperties()
        
    }
    
    var leftLane: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.alpha = 0
        v.isUserInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var centerLane: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.alpha = 0
        v.isUserInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var rightLane: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.alpha = 0
        v.isUserInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let v = UIView()
            v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            return v
        }
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 10
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellState = getCellState(compressionDirection: compressionDirection, touchSection: touchSection)
        switch cellState {
            //        case .normal:
            //            return 600
            //        case .collapsed:
            //            return 100
            //        case .condensed:
        //            return 100
        default:
            return UITableView.automaticDimension
        }
    }
    
    /**
     Listen for scroll action and change cell size.
     */
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resetTimer.invalidate()
        if resettingLanedScroller { return }
        
        let hapticfeedback = UIImpactFeedbackGenerator()
        let containerView = UIApplication.shared.windows.first!.rootViewController?.view
        let touchLocation = scrollView.panGestureRecognizer.location(in: containerView)
        let touchX = touchLocation.x
        var scrollLaneChanged = false
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(leftLane)
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(centerLane)
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(rightLane)
        
        if (touchSection == .none) {
            touchSection = getNormalStateLane(compressionDirection: compressionDirection)
        } else if (leftLaneBounds[.lower]! <= touchX && touchX < leftLaneBounds[.upper]!) {
            scrollLaneChanged = touchSection != .left
            touchSection = .left
        } else if (centerLaneBounds[.lower]! <= touchX && touchX < centerLaneBounds[.upper]!) {
            scrollLaneChanged = touchSection != .center
            touchSection = .center
        } else {
            scrollLaneChanged = touchSection != .right
            touchSection = .right
        }
        
        if autoResetCellState {
            if touchSection != getNormalStateLane(compressionDirection: compressionDirection) {
                resetTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                    self.resetScrollState()
                })
            }
        }
        
        if scrollLaneChanged {
            hapticfeedback.impactOccurred()
            sendScrollStateNotification(for: lanedScrollerId, touchSection: touchSection)
            switch touchSection {
            case .left:
                UIView.animate(withDuration: 0.4) {
                    self.leftLane.alpha = 0.3
                    self.leftLane.alpha = 0
                }
            case .center:
                UIView.animate(withDuration: 0.4) {
                    self.centerLane.alpha = 0.3
                    self.centerLane.alpha = 0
                }
            case .right:
                UIView.animate(withDuration: 0.4) {
                    self.rightLane.alpha = 0.3
                    self.rightLane.alpha = 0
                }
            default:
                break
            }
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollingFinish()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollingFinish()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollingFinish()
        }
    }
    
    
    /**
     Send notification to reset cell state.
     */
    
    @objc
    func resetScrollState() {
        resettingLanedScroller = true
        touchSection = getNormalStateLane(compressionDirection: compressionDirection)
        sendScrollStateNotification(for: lanedScrollerId, touchSection: touchSection)
        self.resettingLanedScroller = false
    }
    
    /**
     After scorlling is over set the reset flag to false.
     */
    
    private func scrollingFinish() {
        resettingLanedScroller = false
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tapToExpandCell {
            if getCellState(compressionDirection: compressionDirection, touchSection: touchSection) == .normal { return }
            resettingLanedScroller = true
            let normalLane = getNormalStateLane(compressionDirection: compressionDirection)
            sendScrollStateNotification(for: lanedScrollerId, touchSection: normalLane)
            
            //            switch compressionDirection {
            //            case .RTL:
            //            case .LTR:
            //                sendScrollStateNotification(for: lanedScrollerId, touchSection: .left)
            //            }
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            //            switch compressionDirection {
            //            case .RTL:
            //                touchSection = .right
            //            case .LTR:
            //                touchSection = .left
            //            }
            touchSection = normalLane
        }
        //Default did select action listner.
    }
    
}

//MARK: Extension to handle configuration changes
extension LanedScrollerDelegate {
//    /**
//     Function to set a compression direction.
//
//     - Parameter compressionDirection: The new compression direction to be set.
//     */
//    func setCompressionDirection(to compressionDirection: CompressionDirection) {
//        self.compressionDirection = compressionDirection
//        touchSection = .none
//        setLaneProperties()
//    }
//
//    /**
//     Function to set the ratio of widths of scroll lanes
//
//     - Parameter laneWidthRation: The new width ration mode for lanes.
//     */
//    func setLaneWidthRatio(to laneWidthRatio: ScrollLaneWidthRatio) {
//        self.laneWidthRatio = laneWidthRatio
//        setLaneProperties()
//    }
//
//    /**
//     Function to check if width of lanes is equal
//
//     - Returns: True if lane widths are equal else false.
//     */
//
//    public func isLaneWidthRationEqual() -> Bool {
//        return laneWidthRatio == .equal
//    }
//
//    /**
//     Set value for tap to expand.
//
//     - Parameter to: Value to set tapToExpandCell to.
//     */
//
//    func setTapToExpandCell(to: Bool) {
//        self.tapToExpandCell = to
//    }
//
//    /**
//     Get if tap to expand cell is enabled.
//
//     - Returns: true if tap to expand cell is true else false.
//     */
//    func isTapToExpandCellEnabled() -> Bool {
//        return tapToExpandCell
//    }
//
//    /**
//     Set value for auto reset cell state.
//
//     - Parameter to: Value to set autoResetCellState to.
//     */
//
//    func setAutoResetCellState(to: Bool) {
//        self.autoResetCellState = to
//    }
//
//    /**
//     Get if auto reset cell state is enabled.
//
//     - Returns: true if auto reset cell state is true else false.
//     */
//    func isAutoResetCellStateEnabled() -> Bool {
//        return autoResetCellState
//    }
//
    /**
     Function to set properties dependent on scroll width ratio.
     */
    func setLaneProperties() {
        leftLaneBounds = getLaneXBounds(with: laneWidthRatio, for: .left, direction: compressionDirection)
        centerLaneBounds = getLaneXBounds(with: laneWidthRatio, for: .center, direction: compressionDirection)
        rightLaneBounds = getLaneXBounds(with: laneWidthRatio, for: .right, direction: compressionDirection)
        leftLane.frame = CGRect(x: leftLaneBounds[.lower]!, y: 0, width: getLaneWidth(with: laneWidthRatio, for: .left, direction: compressionDirection), height: UIScreen.main.bounds.height)
        centerLane.frame = CGRect(x: centerLaneBounds[.lower]!, y: 0, width: getLaneWidth(with: laneWidthRatio, for: .center, direction: compressionDirection), height: UIScreen.main.bounds.height)
        rightLane.frame = CGRect(x: rightLaneBounds[.lower]!, y: 0, width: getLaneWidth(with: laneWidthRatio, for: .right, direction: compressionDirection), height: UIScreen.main.bounds.height)
    }
}

