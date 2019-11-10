//
//  DeepScrollCell.swift
//  DeepScroll
//
//  Created by Michael on 11/4/19.
//

import UIKit

public class DeepScrollCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "deepscrollcell")
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.addSubview(stackview)
        
        NSLayoutConstraint.activate([
            stackview.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            stackview.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            stackview.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    var stackview: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tag = Int.max
        return v
    }()
    
    public func addViews(views: [UIView]) {
        for view in views {
            stackview.addArrangedSubview(view)
        }
    }
    
    public func getViewsCount() -> Int {
        return stackview.arrangedSubviews.count
    }

}
