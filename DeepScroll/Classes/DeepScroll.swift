import UIKit
import Foundation
import AVFoundation

public class LanedScroller: NSObject {
    
    private var tableView: UITableView
    private var dataSource: LanedScrollerDataSource!
    private var delegate: LanedScrollerDelegate!
    private let cellMaker: CellMaker
    private let tableViewData: [Decodable]
    private var compressionDirection: CompressionDirection = .RTL
    
    public init(tableViewData: [Decodable], cellMaker: @escaping CellMaker) {
        self.tableViewData = tableViewData
        self.cellMaker = cellMaker
//        tableView = UITableView()
        tableView = DeepScrollTableView()
        super.init()
        dataSource = LanedScrollerDataSource(lanedScrollerId: self.hashValue, tableViewData: tableViewData, cellMaker: cellMaker)
        delegate = LanedScrollerDelegate(lanedScrollerId: self.hashValue)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.register(DeepScrollCell.self, forCellReuseIdentifier: "deepscrollcell")
        NotificationCenter.default.addObserver(self, selector:#selector(listenScrollState), name: NSNotification.Name(rawValue: "scrollState"), object: nil)
    }
    
    convenience override public init() {
        self.init()
    }
    
    @objc
    func listenScrollState(notifcation: Notification) {
        guard let userInfo = notifcation.userInfo as? [String:String] else { return }
        guard let _ = userInfo[String(self.hashValue)] else { return }
        guard let reset = userInfo["reset"] else { return }
        if reset == "true" { return }
        
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.layoutIfNeeded()
        tableView.endUpdates()
        AudioServicesPlaySystemSound(1057);
        print("Selected Called in DeepScroll")
    }
    
    public func getTableView() -> UITableView {
        return tableView
    }
    
}

//MARK: Extension to handle configuration functions

extension LanedScroller {
    
    /**
     Toggles the compression direction beteen Left to Right and Right to left
     */
    public func toggleCompressionDirection() {
        switch compressionDirection {
        case .RTL:
            compressionDirection = .LTR
        case .LTR:
            compressionDirection = .RTL
        }
        dataSource.setCompressionDirection(to: compressionDirection)
        delegate.setCompressionDirection(to: compressionDirection)
        tableView.reloadData()
    }
    
    /**
     Tells if the compression direction is Right to Left
     
     - Returns: True if compression direction is RTL else false.
     */
    public func isCompressionRTL() -> Bool {
        return compressionDirection == .RTL
    }
    
    /**
     Sets the width of lanes to equal ration.
     */
    public func setWidthRatioEqual() {
        delegate.setLaneWidthRatio(to: .equal)
    }
    
    /**
     Sets the width of lanes to increasing ratio from left to right.
     */
    public func setWidthRatioIncreasing() {
        delegate.setLaneWidthRatio(to: .increasing)
    }
    
    public func isLaneWidthRationEqual() -> Bool {
        return delegate.isLaneWidthRationEqual()
    }
}
