import UIKit

public class LaneScroller: NSObject {
    private var size: CGSize
    public init(size: CGSize) {
        self.size = size
    }
    
    public func makeView() -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }
    
    public func makeTable() -> UITableView {
        print("Size: ",size)
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutIfNeeded()
        return tableView
    }
}

extension LaneScroller: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("Setting height")
        return 150
    }
}

extension LaneScroller: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Called for cell")
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        print("Called for sections")
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Called for rows")
        return 2
    }
}
