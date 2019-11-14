//
//  PostsView.swift
//  DeepScroll_Example
//
//  Created by Parth Tamane on 14/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepScroll

func setPostCellContent(cell: DeepScrollCell, post: Post, avatarSetter: @escaping (String, UIImageView)->())  {

    // If the cell doesn't have any views inside of its stack view, create a new one
    cell.setPadding(top: 16, right: 16, bottom: 16, left: 16)
    cell.selectionStyle = .none
    
    let avatar: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    avatarSetter(post.profileUrl, avatar)
    
    let name: UILabel = {
        let l = UILabel()
        l.text = post.name
        l.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let postTime: UILabel = {
        let l = UILabel()
        l.text = "45 mins •"
        l.textColor = .darkGray
        l.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let options: UIButton = {
        let b = UIButton()
        let i = UIImage(named: "options")
        b.setImage(i, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let friends: UIButton = {
        let b = UIButton()
        let i = UIImage(named: "friends")
        b.setImage(i, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let view1: UIView = {
        let v = UIView()
        v.tag = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let postLabel: UILabel = {
        let l = UILabel()
        l.text = post.post
        l.tag = 2
        l.layoutIfNeeded()
        l.numberOfLines = 0
        l.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.85)
        l.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let seperator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let like: UIButton = {
        let b = UIButton()
        let i = UIImage(named: "like")
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        b.setImage(i, for: .normal)
        b.setTitle("Like", for: .normal)
        b.setTitleColor(UIColor(red: 93/255, green: 104/255, blue: 112/255, alpha: 1), for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 22,left: 15,bottom: 22,right: 60)
        b.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let comment: UIButton = {
        let b = UIButton()
        let i = UIImage(named: "comment")
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        b.setImage(i, for: .normal)
        b.setTitle("Comment", for: .normal)
        b.setTitleColor(UIColor(red: 93/255, green: 104/255, blue: 112/255, alpha: 1), for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 20,left: 10,bottom: 20,right:100)
        b.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let share: UIButton = {
        let b = UIButton()
        let i = UIImage(named: "share")
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        b.setImage(i, for: .normal)
        b.setTitle("Share", for: .normal)
        b.setTitleColor(UIColor(red: 93/255, green: 104/255, blue: 112/255, alpha: 1), for: .normal)
        b.imageEdgeInsets = UIEdgeInsets(top: 20,left: 15,bottom: 20,right: 70)
        b.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let view2: UIView = {
        let v = UIView()
        v.tag = 1
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    view1.addSubview(avatar)
    view1.addSubview(name)
    view1.addSubview(postTime)
    view1.addSubview(options)
    view1.addSubview(friends)
    
    view2.addSubview(seperator)
    view2.addSubview(like)
    view2.addSubview(comment)
    view2.addSubview(share)
    
    cell.addViews(views:[view1, postLabel, view2])
    cell.addSpaceAfter(view: view1, value: 10)
    cell.addSpaceAfter(view: postLabel, value: 10)
    
    NSLayoutConstraint.activate([
        view1.heightAnchor.constraint(equalToConstant: 40),
        view2.heightAnchor.constraint(equalToConstant: 40),
        
        avatar.centerYAnchor.constraint(equalTo: view1.centerYAnchor, constant: 0),
        avatar.leftAnchor.constraint(equalTo: view1.leftAnchor, constant: 0),
        avatar.heightAnchor.constraint(equalToConstant: 40),
        avatar.widthAnchor.constraint(equalToConstant: 40),
        
        name.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 8),
        name.centerYAnchor.constraint(equalTo: avatar.centerYAnchor, constant: -9),
        
        postTime.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 8),
        postTime.centerYAnchor.constraint(equalTo: avatar.centerYAnchor, constant: 9),
        
        friends.leftAnchor.constraint(equalTo: postTime.rightAnchor, constant: 4),
        friends.centerYAnchor.constraint(equalTo: postTime.centerYAnchor, constant: 0),
        friends.heightAnchor.constraint(equalToConstant: 12),
        friends.widthAnchor.constraint(equalToConstant: 12),
        
        options.rightAnchor.constraint(equalTo: view1.rightAnchor, constant: 0),
        options.centerYAnchor.constraint(equalTo: name.centerYAnchor, constant: 0),
        options.heightAnchor.constraint(equalToConstant: 10),
        options.widthAnchor.constraint(equalToConstant: 22),
        
        postLabel.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 399),
        
        seperator.topAnchor.constraint(equalTo: view2.topAnchor, constant: 0),
        seperator.leadingAnchor.constraint(equalTo: view2.leadingAnchor, constant: 0),
        seperator.trailingAnchor.constraint(equalTo: view2.trailingAnchor, constant: 0),
        seperator.heightAnchor.constraint(equalToConstant: 1),
                                
        like.leftAnchor.constraint(equalTo: view2.leftAnchor, constant: 0),
        like.centerYAnchor.constraint(equalTo: view2.centerYAnchor, constant: 0),
        
        comment.centerXAnchor.constraint(equalTo: view2.centerXAnchor, constant: 0),
        comment.centerYAnchor.constraint(equalTo: view2.centerYAnchor, constant:0),

        share.centerYAnchor.constraint(equalTo: view2.centerYAnchor, constant: 0),
        share.rightAnchor.constraint(equalTo: view2.rightAnchor, constant: 0),
    ])
}
