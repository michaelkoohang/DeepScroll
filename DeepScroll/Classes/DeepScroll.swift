import UIKit

var touchSction: TouchSection = .none

public class LanedScrollerDelegate: NSObject, UITableViewDelegate {
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let containerView = UIApplication.shared.windows.first!.rootViewController?.view
        let width = (containerView?.bounds.width)!
        let touchLocation = scrollView.panGestureRecognizer.location(in: containerView)
        let touchX = touchLocation.x
        if ( 0 <= touchX && touchX <= 1/3 * width) {
            touchSction = .left
        } else if ( 1/3 * width <= touchX  && touchX <= 2/3*width) {
            touchSction = .center
        } else {
            touchSction = .right
        }
    }
}

public class LanedScrollerDataSource: NSObject, UITableViewDataSource {
    
    public var cellId: String = ""
    
    override public init() {
        super.init()
        cellId = "LanedScrollerCellId_\(NSDate().timeIntervalSince1970)"
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        switch touchSction {
        case .right:
            cell.backgroundColor = .blue
        case .center:
            cell.backgroundColor = .brown
        case .left:
            cell.backgroundColor = .yellow
        default:
            cell.backgroundColor = .black
        }
        return cell
  }
}
