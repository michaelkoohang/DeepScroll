//
//  CommentCell.swift
//  DeepScroll_Example
//
//  Created by Michael on 11/17/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "commentcell")
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Function that adds the UI components to the cell and sets their constraints.
    func setup() {
        self.addSubview(avatar)
        self.addSubview(postTime)
        self.addSubview(commentView)
        self.addSubview(likeLabel)
        self.addSubview(replyLabel)
        commentView.addSubview(name)
        commentView.addSubview(postLabel)
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            avatar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            avatar.heightAnchor.constraint(equalToConstant: 40),
            avatar.widthAnchor.constraint(equalToConstant: 40),
            
            commentView.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 8),
            commentView.topAnchor.constraint(equalTo: avatar.topAnchor, constant: 0),
            commentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            name.leftAnchor.constraint(equalTo: commentView.leftAnchor, constant: 16),
            name.topAnchor.constraint(equalTo: commentView.topAnchor, constant: 12),
            
            postTime.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            postTime.leftAnchor.constraint(equalTo: commentView.leftAnchor, constant: 4),
            postTime.topAnchor.constraint(equalTo: self.commentView.bottomAnchor, constant: 4),
            
            postLabel.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            postLabel.leftAnchor.constraint(equalTo: commentView.leftAnchor, constant: 16),
            postLabel.rightAnchor.constraint(equalTo: commentView.rightAnchor, constant: -16),
            postLabel.bottomAnchor.constraint(equalTo: commentView.bottomAnchor, constant: -16),
            
            likeLabel.leftAnchor.constraint(equalTo: postTime.rightAnchor, constant: 16),
            likeLabel.centerYAnchor.constraint(equalTo: postTime.centerYAnchor, constant: 0),
            
            replyLabel.leftAnchor.constraint(equalTo: likeLabel.rightAnchor, constant: 16),
            replyLabel.centerYAnchor.constraint(equalTo: likeLabel.centerYAnchor, constant: 0),
            
        ])
    }
    
    // Function that sets the data for the cell.
    func configureCell(post: Post) {
        self.name.text = post.name
        self.postLabel.text = post.data
    }
    
    // UI components for the cell.
    
    let avatar: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let name: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let postTime: UILabel = {
        let l = UILabel()
        l.text = "16 hr"
        l.textColor = .darkGray
        l.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let commentView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        v.layer.cornerRadius = 16
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let postLabel: UILabel = {
        let l = UILabel()
        l.layoutIfNeeded()
        l.numberOfLines = 0
        l.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.85)
        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let likeLabel: UILabel = {
        let l = UILabel()
        l.text = "Like"
        l.textColor = UIColor(red:0.39, green:0.40, blue:0.42, alpha:1.00)
        l.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let replyLabel: UILabel = {
        let l = UILabel()
        l.text = "Reply"
        l.textColor = UIColor(red:0.39, green:0.40, blue:0.42, alpha:1.00)
        l.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
}
