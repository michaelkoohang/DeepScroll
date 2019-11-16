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
//    private var tapToExpandCell = true
//    private var autoResetCellState = false
    
    public init(tableViewData: [Decodable], cellMaker: @escaping CellMaker) {
        self.tableViewData = tableViewData
        self.cellMaker = cellMaker
        tableView = DeepScrollTableView()
        super.init()
        dataSource = LanedScrollerDataSource(lanedScrollerId: self.hashValue, tableViewData: tableViewData, cellMaker: cellMaker)
        delegate = LanedScrollerDelegate(lanedScrollerId: self.hashValue)
        setTapToExpandCell(to: true)
        setAutoResetCellState(to: false)
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
    
    /**
     Reload tableview when scroll lane changes
     
     - Parameter notification: Notification object containing the id of table view that was interacted with
     */
    @objc
    func listenScrollState(notifcation: Notification) {
        guard let userInfo = notifcation.userInfo as? [String:String] else { return }
        guard let _ = userInfo[String(self.hashValue)] else { return }
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.layoutIfNeeded()
        tableView.endUpdates()
        AudioServicesPlaySystemSound(1057);
    }
    
    /**
     Get an instance of the tableview.
     
     - Returns: Tableview instance with custom delegate and data source set.
     */
    
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
        switch delegate.compressionDirection {
        case .RTL:
            delegate.compressionDirection = .LTR
            dataSource.compressionDirection = .LTR
        case .LTR:
            delegate.compressionDirection = .RTL
            dataSource.compressionDirection = .RTL
        }
//        dataSource.setCompressionDirection(to: compressionDirection)
//        delegate.setCompressionDirection(to: compressionDirection)
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
//        delegate.setLaneWidthRatio(to: .equal)
        delegate.laneWidthRatio = .equal
    }
    
    /**
     Sets the width of lanes to increasing ratio from left to right.
     */
    public func setWidthRatioIncreasing() {
//        delegate.setLaneWidthRatio(to: .increasing)
        delegate.laneWidthRatio = .increasing
    }
    
    /**
     Tells if all lanes have equal width.
     */
    public func isLaneWidthRationEqual() -> Bool {
//        return delegate.isLaneWidthRationEqual()
        return delegate.laneWidthRatio == .equal
    }
    
    /**
     Set value for tap to expand.
     
     - Parameter to: Value to set tapToExpandCell to.
     */
    
    public func setTapToExpandCell(to: Bool) {
//        delegate.setTapToExpandCell(to: to)
        delegate.tapToExpandCell = to
    }
    
    /**
     Get if tap to expand cell is enabled.
     
     - Returns: true if tap to expand cell is true else false.
     */
    public func isTapToExpandCellEnabled() -> Bool {
//        return delegate.isTapToExpandCellEnabled()
        return delegate.tapToExpandCell
    }
    
    /**
     Set value for auto reset cell state.
     
     - Parameter to: Value to set autoResetCellState to.
     */
    
    public func setAutoResetCellState(to: Bool) {
//        delegate.setAutoResetCellState(to: to)
        delegate.autoResetCellState = to
    }
    
    /**
     Get if auto reset cell state is enabled.
     
     - Returns: true if auto reset cell state is true else false.
     */
    public func isAutoResetCellStateEnabled() -> Bool {
//        return delegate.isAutoResetCellStateEnabled()
        return delegate.autoResetCellState
    }
}
