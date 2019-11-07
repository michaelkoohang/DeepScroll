//
//  DeepScrollDelegate.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//

public class LanedScrollerDelegate: NSObject, UITableViewDelegate {
    var touchSction: TouchSection = .none
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
        switch touchSction {
        case .left:
            return 60
        case .center:
            return 100
        case .right:
            return 150
        default:
            return 150
        }
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        resetTimer.invalidate()
        let hapticfeedback = UIImpactFeedbackGenerator()
        let containerView = UIApplication.shared.windows.first!.rootViewController?.view
        let width = (containerView?.bounds.width)!
        let touchLocation = scrollView.panGestureRecognizer.location(in: containerView)
        let touchX = touchLocation.x
        var scrollLaneChanged = false
        
        if (touchSction == .none) {
            touchSction = .right
        } else if ( 0 <= touchX && touchX <= (1/3) * width) {
            resetTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                resetScrollState(for: self.lanedScrollerId)
            })
            scrollLaneChanged = touchSction != .left
            touchSction = .left
        } else if ( (1/3) * width <= touchX && touchX <= (2/3) * width) {
            resetTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                resetScrollState(for: self.lanedScrollerId)
            })
            scrollLaneChanged = touchSction != .center
            touchSction = .center
        } else {
            scrollLaneChanged = touchSction != .right
            touchSction = .right
        }
        
        if scrollLaneChanged {
            hapticfeedback.impactOccurred()
            sendScrollStateNotification(for: lanedScrollerId, touchSection: touchSction)
        }
        
    }
}
