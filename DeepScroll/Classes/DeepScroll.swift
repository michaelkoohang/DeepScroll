import UIKit

public class LanedScroller: NSObject {
    
    private var tableView: UITableView
    private var dataSource: LanedScrollerDataSource!
    private var delegate: LanedScrollerDelegate!
    private let stackViewMaker: (Decodable) -> UIStackView
    private let tableViewData: [Decodable]
    
    public init(tableViewData: [Decodable], stackViewMaker: @escaping (Decodable) -> UIStackView) {
        self.tableViewData = tableViewData
        self.stackViewMaker = stackViewMaker
        tableView = UITableView()
        super.init()
        dataSource = LanedScrollerDataSource(lanedScrollerId: self.hashValue, tableViewData: tableViewData, stackViewMaker: stackViewMaker)
        delegate = LanedScrollerDelegate(lanedScrollerId: self.hashValue)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(self.hashValue))
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(listenScrollState), name: NSNotification.Name(rawValue: "scrollState"), object: nil)
        print("IN LANED SCROLLER")
        stackViewMaker(tableViewData[0])
    }
    
    convenience override public init() {
        self.init()
    }
    
    
    @objc
    func listenScrollState(notifcation: Notification) {
        guard let userInfo = notifcation.userInfo as? [String:String] else { return }
        guard let _ = userInfo[String(self.hashValue)] else { return }
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.endUpdates()
    }
    
    
    public func getTableView() -> UITableView {
        return tableView
    }
}

