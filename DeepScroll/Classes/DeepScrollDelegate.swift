//
//  DeepScrollDelegate.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//
import Foundation
import UIKit

public class LanedScrollerDelegate: NSObject, UITableViewDelegate {
    var touchSection: TouchSection = .none
    var resetTimer: Timer = Timer()
    let lanedScrollerId: Int
        
    convenience override public init() {
        self.init(lanedScrollerId: 0)
    }
    
    
    init(lanedScrollerId: Int) {
        self.lanedScrollerId = lanedScrollerId
        super.init()
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        resetTimer.invalidate()
        let hapticfeedback = UIImpactFeedbackGenerator()
        let containerView = UIApplication.shared.windows.first!.rootViewController?.view
        let width = (containerView?.bounds.width)!
        let touchLocation = scrollView.panGestureRecognizer.location(in: containerView)
        let touchX = touchLocation.x
        var scrollLaneChanged = false
        
        if (touchSection == .none) {
            touchSection = .right
        } else if ( 0 <= touchX && touchX <= (1/3) * width) {
            resetTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                resetScrollState(for: self.lanedScrollerId)
            })
            scrollLaneChanged = touchSection != .left
            touchSection = .left
        } else if ( (1/3) * width <= touchX && touchX <= (2/3) * width) {
            resetTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                resetScrollState(for: self.lanedScrollerId)
            })
            scrollLaneChanged = touchSection != .center
            touchSection = .center
        } else {
            scrollLaneChanged = touchSection != .right
            touchSection = .right
        }
        
        if scrollLaneChanged {
            hapticfeedback.impactOccurred()
            sendScrollStateNotification(for: lanedScrollerId, touchSection: touchSection)
        }
    }
}
