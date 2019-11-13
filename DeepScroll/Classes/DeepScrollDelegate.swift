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
    private var leftLaneBounds: [LaneXBound: CGFloat]
    private var centerLaneBounds: [LaneXBound: CGFloat]
    private var rightLaneBounds: [LaneXBound: CGFloat]
    
    convenience override public init() {
        self.init()
    }
    
    init(lanedScrollerId: Int) {
        self.lanedScrollerId = lanedScrollerId
        
        //Setting up lane ratio properties
        leftLaneBounds = getLaneXBounds(with: laneWidthRatio, for: .left)
        centerLaneBounds = getLaneXBounds(with: laneWidthRatio, for: .center)
        rightLaneBounds = getLaneXBounds(with: laneWidthRatio, for: .right)
        leftLane.frame = CGRect(x: leftLaneBounds[.lower]!, y: 0, width: getLaneWidth(with: laneWidthRatio, for: .left), height: UIScreen.main.bounds.height)
        centerLane.frame = CGRect(x: centerLaneBounds[.lower]!, y: 0, width: getLaneWidth(with: laneWidthRatio, for: .center), height: UIScreen.main.bounds.height)
        rightLane.frame = CGRect(x: rightLaneBounds[.lower]!, y: 0, width: getLaneWidth(with: laneWidthRatio, for: .right), height: UIScreen.main.bounds.height)
        
        super.init()
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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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

extension LanedScrollerDelegate {
    func setCompressionDirection(to compressionDirection: CompressionDirection) {
        self.compressionDirection = compressionDirection
        touchSection = .none
    }
}

