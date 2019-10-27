import UIKit


public class LanedScrollerDelegate: NSObject, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        cell.backgroundColor = .blue
        return cell
  }
}
