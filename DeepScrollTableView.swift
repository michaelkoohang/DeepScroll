//
//  DeepScrollTableView.swift
//  DeepScroll
//
//  Created by Parth Tamane on 14/11/19.
//

import Foundation
import UIKit

final class DeepScrollTableView: UITableView {
    private var reloadDataCompletionBlock: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        reloadDataCompletionBlock = completion
        self.reloadData()
    }
}
