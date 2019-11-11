//
//  ViewController.swift
//  DeepScroll
//
//  Created by parthv21 on 10/11/2019.
//  Copyright (c) 2019 parthv21. All rights reserved.
//

import UIKit
import DeepScroll

class ViewController: UIViewController {

    private var lanedScroller: LanedScroller!
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        addTableView()
    }
    
    func addTableView() {
        var feed: Feed?
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                feed = try decoder.decode(Feed.self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
        guard let unwrappedFeed = feed else { return }
        lanedScroller = LanedScroller(tableViewData: unwrappedFeed.posts, cellMaker: {(cell: DeepScrollCell, post: Decodable) in

            if let post = post as? Post {

                if (cell.getViewsCount() > 0) {

                    for subview in cell.contentView.subviews {
                        if (subview.isKind(of: UIStackView.self)) {
                            (subview.subviews[0].subviews[0] as! UIImageView).image = UIImage()
                            (subview.subviews[0].subviews[1] as! UILabel).text = post.name
                            (subview.subviews[0].subviews[2] as! UILabel).text = "DATE"
                            
                            (subview.subviews[1] as! UILabel).text = post.post
                        }
                    }
                    return cell
                }
                else {

                    // If the cell doesn't have any views inside of its stack view, create a new one
                    
                    let avatar: UIImageView = {
                        let iv = UIImageView()
                        iv.backgroundColor = .black
                        iv.layer.cornerRadius = 25
                        iv.translatesAutoresizingMaskIntoConstraints = false
                        return iv
                    }()
                    
                    let name: UILabel = {
                        let l = UILabel()
                        l.text = post.name
                        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                        l.translatesAutoresizingMaskIntoConstraints = false
                        return l
                    }()
                    
                    let postDate: UILabel = {
                        let l = UILabel()
                        l.text = "DATE"
                        l.textColor = .lightGray
                        l.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                        l.translatesAutoresizingMaskIntoConstraints = false
                        return l
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
                        l.translatesAutoresizingMaskIntoConstraints = false
                        return l
                    }()
                    
                    let like: UIButton = {
                        let b = UIButton()
                        b.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                        b.backgroundColor = .systemBlue
                        b.setTitle("Like", for: .normal)
                        b.setTitleColor(.white, for: .normal)
                        b.layer.cornerRadius = 5
                        b.translatesAutoresizingMaskIntoConstraints = false
                        return b
                    }()
                    
                    let comment: UIButton = {
                        let b = UIButton()
                        b.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                        b.backgroundColor = .systemRed
                        b.setTitle("Comment", for: .normal)
                        b.setTitleColor(.white, for: .normal)
                        b.layer.cornerRadius = 5
                        b.translatesAutoresizingMaskIntoConstraints = false
                        return b
                    }()
                    
                    let share: UIButton = {
                        let b = UIButton()
                        b.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                        b.backgroundColor = .systemYellow
                        b.setTitle("Share", for: .normal)
                        b.setTitleColor(.white, for: .normal)
                        b.layer.cornerRadius = 5
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
                    view1.addSubview(postDate)
                    
                    view2.addSubview(like)
                    view2.addSubview(comment)
                    view2.addSubview(share)
                                        
                    cell.addViews(views:[view1, postLabel, view2])
                    
                    NSLayoutConstraint.activate([
                        view1.heightAnchor.constraint(equalToConstant: 70),
                        view2.heightAnchor.constraint(equalToConstant: 40),
                                                
                        avatar.centerYAnchor.constraint(equalTo: view1.centerYAnchor, constant: 0),
                        avatar.leftAnchor.constraint(equalTo: view1.leftAnchor, constant: 8),
                        avatar.heightAnchor.constraint(equalToConstant: 50),
                        avatar.widthAnchor.constraint(equalToConstant: 50),
                        
                        name.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 8),
                        name.centerYAnchor.constraint(equalTo: avatar.centerYAnchor, constant: -12),
                        
                        postDate.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 8),
                        postDate.centerYAnchor.constraint(equalTo: avatar.centerYAnchor, constant: 12),
                        
                        postLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 16),
                        postLabel.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -16),
                        
                        like.leftAnchor.constraint(equalTo: view2.leftAnchor, constant: 8),
                        like.centerYAnchor.constraint(equalTo: view2.centerYAnchor, constant: 0),
                        like.widthAnchor.constraint(equalToConstant: 80),
                        
                        comment.centerXAnchor.constraint(equalTo: view2.centerXAnchor, constant: 0),
                        comment.centerYAnchor.constraint(equalTo: view2.centerYAnchor, constant: 0),
                        comment.widthAnchor.constraint(equalToConstant: 100),

                        share.centerYAnchor.constraint(equalTo: view2.centerYAnchor, constant: 0),
                        share.rightAnchor.constraint(equalTo: view2.rightAnchor, constant: -8),
                        share.widthAnchor.constraint(equalToConstant: 80)

                                    
                    ])
                    
                    
                    return cell

                }

            }
            
            return DeepScrollCell()
            
        })
        tableView = lanedScroller.getTableView()
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ])
        
    }
    
}
