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
                            (subview.viewWithTag(0) as! UILabel).text = String(post.id) + " " + post.name
                            (subview.viewWithTag(2) as! UILabel).text = post.post
                        }
                    }
                    return cell
                }
                else {
                    let nameLbl = UILabel()
                    let dummyView = UIView()
                    let postLbl = UILabel()
                    
                    nameLbl.text = String(post.id) + " " + post.name
                    nameLbl.tag = 0
                    nameLbl.translatesAutoresizingMaskIntoConstraints = false
                  
                    dummyView.translatesAutoresizingMaskIntoConstraints = false
                    dummyView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    dummyView.backgroundColor = .systemPink
                    dummyView.tag = 1
                    
                    postLbl.text = post.post
                    postLbl.tag = 2
                    postLbl.layoutIfNeeded()
                    postLbl.numberOfLines = 0
                    postLbl.translatesAutoresizingMaskIntoConstraints = false
                    
                    cell.addViews(views:[nameLbl, dummyView, postLbl])
                                        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
