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
    private var compressionDirection: CompressionDirection = .RTL
    private var laneWidthRatio: ScrollLaneWidthRatio = .equal
    private var leftLaneBounds: [LaneXBound: CGFloat] = [:]
    private var centerLaneBounds: [LaneXBound: CGFloat] = [:]
    private var rightLaneBounds: [LaneXBound: CGFloat] = [:]
    
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
//        v.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var centerLane: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.alpha = 0
        v.isUserInteractionEnabled = false
//        v.frame = CGRect(x: UIScreen.main.bounds.width / 3, y: 0, width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var rightLane: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.alpha = 0
        v.isUserInteractionEnabled = false
//        v.frame = CGRect(x: UIScreen.main.bounds.width / 3 * 2, y: 0, width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height)
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
        
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let hapticfeedback = UIImpactFeedbackGenerator()
        let containerView = UIApplication.shared.windows.first!.rootViewController?.view
        let touchLocation = scrollView.panGestureRecognizer.location(in: containerView)
        let touchX = touchLocation.x
        var scrollLaneChanged = false
        
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(leftLane)
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(centerLane)
        UIApplication.shared.windows.first?.rootViewController?.view.addSubview(rightLane)
        
        if (touchSection == .none) {
            switch compressionDirection {
            case .RTL:
                touchSection = .right
            case .LTR:
                touchSection = .left
            }
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
}

//MARK: Extension to handle configuration changes
extension LanedScrollerDelegate {
    /**
     Function to set a compression direction.
     
     - Parameter compressionDirection: The new compression direction to be set.
     */
    func setCompressionDirection(to compressionDirection: CompressionDirection) {
        self.compressionDirection = compressionDirection
        touchSection = .none
        setLaneProperties()
    }
    
    /**
     Function to set the ratio of widths of scroll lanes
     
     - Parameter laneWidthRation: The new width ration mode for lanes.
     */
    func setLaneWidthRatio(to laneWidthRatio: ScrollLaneWidthRatio) {
        self.laneWidthRatio = laneWidthRatio
        setLaneProperties()
    }
    
    /**
     Function to check if width of lanes is equal
     
     - Returns: True if lane widths are equal else false.
     */
    public func isLaneWidthRationEqual() -> Bool {
        return laneWidthRatio == .equal
       }
    
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

