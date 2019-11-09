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
    private let stackViewMaker: CellMaker
    private let tableViewData: [Decodable]
    private var touchSection: TouchSection = .none
    
    convenience override public init() {
        self.init()
    }
    
    
    init(lanedScrollerId: Int, tableViewData: [Decodable], stackViewMaker: @escaping CellMaker) {
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
        var cell = tableView.dequeueReusableCell(withIdentifier: String(lanedScrollerId), for: indexPath)
        cell = stackViewMaker(cell, tableViewData[indexPath.row])
        
        for subview in cell.contentView.subviews {
            if (subview.isKind(of: UIStackView.self)) {
                switch self.touchSection {
                case .right:
                    subview.viewWithTag(0)?.isHidden = false
                    subview.viewWithTag(1)?.isHidden = false
                    subview.viewWithTag(2)?.isHidden = false
                case .center:
                    subview.viewWithTag(0)?.isHidden = false
                    subview.viewWithTag(1)?.isHidden = false
                    subview.viewWithTag(2)?.isHidden = true
                case .left:
                    subview.viewWithTag(0)?.isHidden = false
                    subview.viewWithTag(1)?.isHidden = true
                    subview.viewWithTag(2)?.isHidden = true
                default:
                    break
                }
            }
        }
        return cell
    }
}

