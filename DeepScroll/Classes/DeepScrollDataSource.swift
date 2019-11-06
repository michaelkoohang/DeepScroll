//
//  DeepScrollDataSource.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//

public class LanedScrollerDataSource: NSObject, UITableViewDataSource {
    
    let lanedScrollerId: Int
    
    
    init(lanedScrollerId: Int) {
        self.lanedScrollerId = lanedScrollerId
        super.init()
    }
    
    
    convenience override public init() {
        self.init()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(lanedScrollerId), for: indexPath)
        cell.backgroundColor = .yellow
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

