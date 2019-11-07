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
        lanedScroller = LanedScroller(tableViewData: unwrappedFeed.posts, stackViewMaker: {(post: Decodable) in
            if let post = post as? Post {
                let nameLbl = UILabel()
                nameLbl.text = post.name
                nameLbl.tag = 0
                let profileImageView = UIImageView()
                if let profileUrl = URL(string: post.profileUrl) {
                    URLSession.shared.dataTask(with: profileUrl) { (data, response, error) in
                        guard let data = data, error == nil else {return}
                        DispatchQueue.main.async {
                            profileImageView.image = UIImage(data: data)
                        }
                    }.resume()
                }
                profileImageView.tag = 1
                let postLbl = UILabel()
                postLbl.text = post.post
                postLbl.tag = 2
                
                let stackView = UIStackView(arrangedSubviews: [nameLbl, profileImageView, postLbl])
                stackView.axis = .vertical
                
                print("Printing data from callback")
                print("Name: \(post.name)")
                print("URL: \(post.profileUrl)")
                print("Post: \(post.post)")
                
                return stackView
            }
      
            return UIStackView()
            
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
