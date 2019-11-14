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
    private let cellMaker: CellMaker
    private let tableViewData: [Decodable]
    private var touchSection: TouchSection = .none
    private var compressionDirection: CompressionDirection = .RTL
    
    convenience override public init() {
        self.init()
    }
    
    
    init(lanedScrollerId: Int, tableViewData: [Decodable], cellMaker: @escaping CellMaker) {
        self.lanedScrollerId = lanedScrollerId
        self.tableViewData = tableViewData
        self.cellMaker = cellMaker
        super.init()
        NotificationCenter.default.addObserver(self, selector:#selector(listenScrollState), name: NSNotification.Name(rawValue: "scrollState"), object: nil)
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
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if var cell = tableView.dequeueReusableCell(withIdentifier: "deepscrollcell", for: indexPath) as? DeepScrollCell {
            cell = cellMaker(cell, tableViewData[indexPath.section])
            
            if let sv = cell.contentView.subviews[0].subviews[0] as? UIStackView {
                let cellState = getCellState(compressionDirection: compressionDirection, touchSection: touchSection)
                switch cellState {
                case .normal:
                    sv.viewWithTag(0)?.isHidden = false
                    sv.viewWithTag(1)?.isHidden = false
                    sv.viewWithTag(2)?.isHidden = false
                case .collapsed:
                    sv.viewWithTag(0)?.isHidden = false
                    sv.viewWithTag(1)?.isHidden = false
                    sv.viewWithTag(2)?.isHidden = true
                case .condensed:
                    sv.viewWithTag(0)?.isHidden = false
                    sv.viewWithTag(1)?.isHidden = true
                    sv.viewWithTag(2)?.isHidden = true
                }
                
            }
            
            return cell
        }
        
        return DeepScrollCell()
        
    }
}

extension LanedScrollerDataSource {
    func setCompressionDirection(to compressionDirection: CompressionDirection) {
        self.compressionDirection = compressionDirection
        switch touchSection {
        case .left:
            touchSection = .right
        case .right:
            touchSection = .left
        default:
            break
        }
    }
}
