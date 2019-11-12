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
    private var menuView: UITableView = UITableView()
    private var menuViewContiner: UIView!
    private let switchView = UISwitch()
    private var downloadedImages: [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        addTableView()
        addMenuTableView()
        switchView.setOn(false, animated: true)
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
                            self.setAvatar(profileUrl: post.profileUrl, avatar: (subview.subviews[0].subviews[0] as! UIImageView))
                            //                            (subview.subviews[0].subviews[0] as! UIImageView).image = UIImage()
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
                        iv.layer.masksToBounds = true
                        iv.translatesAutoresizingMaskIntoConstraints = false
                        return iv
                    }()
                    self.setAvatar(profileUrl: post.profileUrl, avatar: avatar)
                    
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
    
    func setAvatar(profileUrl: String, avatar: UIImageView) {
        if downloadedImages[profileUrl] != nil {
            avatar.image = self.downloadedImages[profileUrl]
        } else {
            self.fetchProfileImage(from: profileUrl) { (image) in
                guard let image = image else { return }
                self.downloadedImages[profileUrl] = image
                DispatchQueue.main.async {
                    avatar.image = image
                }
            }
        }
    }
    
    func fetchProfileImage(from profileLink: String, completion: @escaping (UIImage?)->()) {
        guard let url =  URL(string: profileLink) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            completion(UIImage(data: data))
        }.resume()
    }
    
}

extension ViewController {
    
    func addMenuTableView() {
        menuViewContiner = UIView(frame: CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 2/3 * view.bounds.height))
        view.addSubview(menuViewContiner)
        menuViewContiner.translatesAutoresizingMaskIntoConstraints = false
        menuViewContiner.backgroundColor = .white
        NSLayoutConstraint.activate([
            menuViewContiner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuViewContiner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuViewContiner.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 50),
            menuViewContiner.heightAnchor.constraint(equalToConstant: 2/3 * view.bounds.height)
        ])

        switchView.addTarget(self, action: #selector(switched), for: .valueChanged)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        menuViewContiner.addSubview(switchView)
        NSLayoutConstraint.activate([
            switchView.topAnchor.constraint(equalTo: menuViewContiner.topAnchor, constant: 5),
            switchView.trailingAnchor.constraint(equalTo: menuViewContiner.trailingAnchor, constant: -35),
            switchView.widthAnchor.constraint(equalToConstant: 40),
            switchView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let settingsText = UILabel()
        settingsText.text = "Settings"
        settingsText.textColor = .black
        settingsText.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        settingsText.textAlignment = .center
        settingsText.baselineAdjustment = .alignCenters
        menuViewContiner.addSubview(settingsText)
        settingsText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsText.leadingAnchor.constraint(equalTo: menuViewContiner.leadingAnchor, constant: 5),
            settingsText.topAnchor.constraint(equalTo: menuViewContiner.topAnchor, constant: -10),
            settingsText.heightAnchor.constraint(equalToConstant: 60),
            settingsText.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        menuView = UITableView()
        menuViewContiner.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: menuViewContiner.leadingAnchor),
            menuView.topAnchor.constraint(equalTo: menuViewContiner.topAnchor, constant: 40),
            menuView.bottomAnchor.constraint(equalTo: menuViewContiner.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: menuViewContiner.trailingAnchor)
        ])
        
    }
    
    @objc
       func switched(s: UISwitch){
           let origin: CGFloat = s.isOn ?  view.bounds.height - view.bounds.height/3 : view.bounds.height - 50
           print(origin)
           UIView.animate(withDuration: 0.35) {
               self.menuViewContiner.frame.origin.y = origin
           }
       }
}
