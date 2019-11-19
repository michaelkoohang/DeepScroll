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
    
    // Adds stackview to cell and sets constraints.
    func setup() {
        self.cellView.addSubview(stackview)
        self.contentView.addSubview(cellView)
        NSLayoutConstraint.activate([
            
            cellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            cellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            cellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            cellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            
        ])
    }
    
    // UI components for cell.
    
    var cellView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var stackview: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tag = Int.max
        return v
    }()
    
    // Adds array of views to stackview.
    public func addViews(views: [UIView]) {
        for view in views {
            stackview.addArrangedSubview(view)
        }
    }
    
    // Returns number of views inside of the cell.
    public func getViewsCount() -> Int {
        return stackview.arrangedSubviews.count
    }
    
    // Returns the views inside of the cell.
    public func getViews() -> [UIView] {
        return stackview.arrangedSubviews
    }
    
    // Sets padding on cell.
    public func setPadding(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        print("\(top) + \(right) + \(bottom) + \(left)")
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: self.cellView.leadingAnchor, constant: left),
            stackview.trailingAnchor.constraint(equalTo: self.cellView.trailingAnchor, constant: -right),
            stackview.topAnchor.constraint(equalTo: self.cellView.topAnchor, constant: top),
            stackview.bottomAnchor.constraint(equalTo: self.cellView.bottomAnchor, constant: -bottom)
        ])
    }
    
    // Adds spacing after specificed view in the cell.
    public func addSpaceAfter(view: UIView, value: CGFloat) {
        stackview.setCustomSpacing(value, after: view)
    }
    
}
