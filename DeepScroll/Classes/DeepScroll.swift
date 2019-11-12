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
        tableView = UITableView()
        super.init()
        dataSource = LanedScrollerDataSource(lanedScrollerId: self.hashValue, tableViewData: tableViewData, cellMaker: cellMaker)
        delegate = LanedScrollerDelegate(lanedScrollerId: self.hashValue)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
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
        tableView.reloadData()
        tableView.beginUpdates()
        tableView.endUpdates()
        AudioServicesPlaySystemSound(1057);
    }
    
    public func getTableView() -> UITableView {
        return tableView
    }
    
    public func toggleCompressionDirection() {
        switch compressionDirection {
        case .RTL:
            compressionDirection = .LTR
        case .LTR:
            compressionDirection = .RTL
        }
        dataSource.setCompressionDirection(to: compressionDirection)
        tableView.reloadData()
    }
    
    public func isCompressionRTL() -> Bool {
        return compressionDirection == .RTL
    }

}

