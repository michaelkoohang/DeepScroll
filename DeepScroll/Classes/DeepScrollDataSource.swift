//
//  DeepScrollDataSource.swift
//  DeepScroll
//
//  Created by Parth Tamane on 06/11/19.
//
import Foundation
import UIKit

public class LanedScrollerDataSource: NSObject, UITableViewDataSource {
    
    let lanedScrollerId: Int
    private let stackViewMaker: (Decodable) -> UIStackView
    private let tableViewData: [Decodable]
    private var touchSection: TouchSection = .none
    
    convenience override public init() {
        self.init()
    }
    
    
    init(lanedScrollerId: Int, tableViewData: [Decodable], stackViewMaker: @escaping (Decodable) -> UIStackView) {
        self.lanedScrollerId = lanedScrollerId
        self.tableViewData = tableViewData
        self.stackViewMaker = stackViewMaker
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(listenScrollState), name: NSNotification.Name(rawValue: "scrollState"), object: nil)
    }
    
    @objc
    func listenScrollState(notifcation: Notification) {
        guard let userInfo = notifcation.userInfo as? [String:String] else { return }
        guard let scrollState = userInfo[String(lanedScrollerId)] else { return }
        switch scrollState {
        case "\(TouchSection.center)":
            touchSection = TouchSection.center
        case "\(TouchSection.left)":
            touchSection = TouchSection.left
        case "\(TouchSection.right)":
            touchSection = TouchSection.right
        default:
            touchSection = TouchSection.none
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(lanedScrollerId), for: indexPath)
        if (cell.contentView.subviews.count > 0) {
            let addStackViewTag = cell.contentView.subviews[0].tag
            print(addStackViewTag)
            print(tableViewData[indexPath.row])
        } else {
            print("No Subview Added to table view cell")
        }
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        let contentStackView = stackViewMaker(tableViewData[indexPath.row])
        contentStackView.backgroundColor = .black
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.subviews.forEach({view in
            switch touchSection {
            case .center:
                if view.tag == 2 {
                    view.isHidden = true
                }
            case .left:
                if view.tag == 2 || view.tag == 1 {
                    view.isHidden = true
                }
            default:
                break
            }
        })
        cell.contentView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        return cell
    }
}

