import UIKit

public class LaneScroller: NSObject {
    private var size: CGFloat
    public init(size: CGFloat) {
        self.size = size
    }
    
    public func makeView() -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    public func makeTable() -> UITableView {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }
}

extension LaneScroller: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension LaneScroller: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .blue
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
