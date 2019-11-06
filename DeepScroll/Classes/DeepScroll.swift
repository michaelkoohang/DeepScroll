import UIKit

func makeScrollStateObject() -> [String:String] {
    return ["scrollLane":"\(touchSction)"]
}

func sendScrollStateNotification() {
    let scrollState = makeScrollStateObject()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollState"), object: nil, userInfo: scrollState)
}

func resetScrollState() {
    touchSction = .right
    sendScrollStateNotification()
}

var touchSction: TouchSection = .none
var resetTimer: Timer = Timer()


public class LanedScroller: NSObject {
    
    private var tableView: UITableView
    private var dataSource: LanedScrollerDataSource
    private var delegate: LanedScrollerDelegate
    
    override public init() {
        tableView = UITableView()
        dataSource = LanedScrollerDataSource()
        delegate = LanedScrollerDelegate()
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        super.init()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: dataSource.cellId)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(listenScrollState), name: NSNotification.Name(rawValue: "scrollState"), object: nil)
    }
    
    
    @objc
    func listenScrollState(notifcation: Notification) {
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.endUpdates()
        //        tableView.reloadData()
    }
    
    
    public func getTableView() -> UITableView {
        return tableView
    }
}


public class LanedScrollerDelegate: NSObject, UITableViewDelegate {
    
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
                resetScrollState()
            })
            scrollLaneChanged = touchSction != .left
            touchSction = .left
        } else if ( (1/3) * width <= touchX && touchX <= (2/3) * width) {
            resetTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                resetScrollState()
            })
            scrollLaneChanged = touchSction != .center
            touchSction = .center
        } else {
            scrollLaneChanged = touchSction != .right
            touchSction = .right
        }
        
        if scrollLaneChanged {
            hapticfeedback.impactOccurred()
            sendScrollStateNotification()
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
        return 200
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        switch touchSction {
            //        case .right:
            //            cell.backgroundColor = .blue
            //        case .center:
            //            cell.backgroundColor = .brown
            //        case .left:
        //            cell.backgroundColor = .yellow
        default:
            cell.backgroundColor = .yellow
        }
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
