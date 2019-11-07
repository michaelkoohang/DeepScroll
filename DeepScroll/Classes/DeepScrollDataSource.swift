//
//  DeepScrollDataSource.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//

public class LanedScrollerDataSource: NSObject, UITableViewDataSource {
    
    let lanedScrollerId: Int
    private let stackViewMaker: (Decodable) -> UIStackView
    private let tableViewData: [Decodable]
    
    
    convenience override public init() {
        self.init()
    }
    
    
    init(lanedScrollerId: Int, tableViewData: [Decodable], stackViewMaker: @escaping (Decodable) -> UIStackView) {
        self.lanedScrollerId = lanedScrollerId
        self.tableViewData = tableViewData
        self.stackViewMaker = stackViewMaker
        super.init()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(lanedScrollerId), for: indexPath)
        let contentStackView = stackViewMaker(tableViewData[indexPath.row % 2])
        contentStackView.backgroundColor = .black
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: cell.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: cell.bottomAnchor)
        ])
//        cell.backgroundColor = .yellow
//        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

