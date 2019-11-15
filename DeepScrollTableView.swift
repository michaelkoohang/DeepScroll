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
        print("Selected Layout Subviews")
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        print("Selected Reload Data")
        reloadDataCompletionBlock = completion
        self.reloadData()
    }
}
