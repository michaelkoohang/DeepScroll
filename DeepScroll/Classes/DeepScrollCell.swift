//
//  DeepScrollCell.swift
//  DeepScroll
//
//  Created by Michael on 11/4/19.
//

import UIKit

open class DeepScrollCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "deepscrollcell")
        setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.addSubview(stackview)
//        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackview.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8),
            stackview.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8),
            stackview.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            stackview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
    }
    
    var stackview: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tag = Int.max
        v.spacing = 5
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
    
    public func getViews() -> [UIView] {
        return stackview.arrangedSubviews
    }

}
