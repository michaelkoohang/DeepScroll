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
    private var menuView: UITableView!
    private var menuOpen = false
    private let settingsCellId = "ExampleAppSettingsCellId"
    private var menuViewContiner: UIView!
    private var downloadedImages: [String: UIImage] = [:]
    
    private let whiteShade = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    private let blackShade = UIColor(red:0.10, green:0.13, blue:0.16, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(red:0.13, green:0.48, blue:0.93, alpha:1.00)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red:0.13, green:0.48, blue:0.93, alpha:1.00)]
            navBarAppearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        title = "facebook"
        addTableView()
        addMenuTableView()
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
                    
                    if let sv = cell.contentView.subviews[0].subviews[0] as? UIStackView {
                        if (sv.isKind(of: UIStackView.self)) {
                            self.setAvatar(profileUrl: post.profileUrl, avatar: (sv.subviews[0].subviews[0] as! UIImageView))
                            (sv.subviews[0].subviews[1] as! UILabel).text = post.name
                            (sv.subviews[0].subviews[2] as! UILabel).text = "45 min •"
                            (sv.subviews[1] as! UILabel).text = post.post
                            
                        }
                    }
                    return cell
                }
                else {
                    
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
                    self.setAvatar(profileUrl: post.profileUrl, avatar: avatar)
                    
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
                    return cell
                }
            }
            return DeepScrollCell()
        })
        tableView = lanedScroller.getTableView()
        tableView.separatorStyle = .none
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

// MARK: Extension to make settings menu

extension ViewController {
    
    func addMenuTableView() {
        menuViewContiner = UIView(frame: CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 2/3 * view.bounds.height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toggleSettingsPane(_:)))
        menuViewContiner.addGestureRecognizer(tap)
        view.addSubview(menuViewContiner)
        menuViewContiner.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            menuViewContiner.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? blackShade : whiteShade
        } else {
            // Fallback on earlier versions
            menuViewContiner.backgroundColor = whiteShade
        }
        NSLayoutConstraint.activate([
            menuViewContiner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuViewContiner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuViewContiner.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 50),
            menuViewContiner.heightAnchor.constraint(equalToConstant: 2/3 * view.bounds.height)
        ])
        
        let settingsText = UILabel()
        settingsText.text = "Settings"
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
        if #available(iOS 13.0, *) {
            menuView.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? blackShade : whiteShade
        } else {
            // Fallback on earlier versions
            menuView.backgroundColor = whiteShade
        }
        menuView.delegate = self
        menuView.dataSource = self
        menuView.register(UITableViewCell.self, forCellReuseIdentifier: settingsCellId)
        
        menuViewContiner.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: menuViewContiner.leadingAnchor),
            menuView.topAnchor.constraint(equalTo: menuViewContiner.topAnchor, constant: 40),
            menuView.bottomAnchor.constraint(equalTo: menuViewContiner.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: menuViewContiner.trailingAnchor)
        ])
        
    }
    
    @objc func toggleSettingsPane(_ sender: UITapGestureRecognizer? = nil) {
        menuOpen = self.menuViewContiner.frame.origin.y == view.bounds.height - 50
        let origin: CGFloat = menuOpen ?  view.bounds.height - view.bounds.height/3 : view.bounds.height - 50
        UIView.animate(withDuration: 0.35) {
            self.menuViewContiner.frame.origin.y = origin
        }
    }
    
    @objc func toggleCompressionMode(s: UISwitch) {
        lanedScroller.toggleCompressionDirection()
    }
    
    @objc func toggleLaneWidth(s: UISwitch) {
        if s.isOn {
            lanedScroller.setWidthRatioEqual()
        } else {
            lanedScroller.setWidthRatioIncreasing()
        }
    }
    
}

//MARK: Extension to handle settings menu table view methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellId) {
                menuTableCellMaker(cell: cell, title: "Compression Direction", leftTitle: "LTR", rightTitle: "RTL", switchState: lanedScroller.isCompressionRTL(), action: #selector(toggleCompressionMode(s:)))
                return cell
            }
        }
        
        if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellId) {
                menuTableCellMaker(cell: cell, title: "Lane Width", leftTitle: "1/9x", rightTitle: "1/3x", switchState: lanedScroller.isLaneWidthRationEqual(), action: #selector(toggleLaneWidth(s:)))
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    /**
     Function to make menu table view's cell.
     - Parameter cell: The dequeud tableview cell to configure.
     - Parameter title: Title of the setting being changed by this cell.
     - Parameter leftTitle: The label text when switch is off.
     - Parameter rightTitle: The label text when switch is on.
     - Parameter switchState: Value indicating if the setting is active or not.
     - Parameter action: Selector to function executed when switch toggled.
     */
    func menuTableCellMaker(cell: UITableViewCell, title: String, leftTitle: String, rightTitle: String, switchState: Bool, action: Selector) {
        let settingDescLbl = UILabel()
        settingDescLbl.translatesAutoresizingMaskIntoConstraints = false
        settingDescLbl.text = title
        settingDescLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        let rightLbl = UILabel()
        rightLbl.translatesAutoresizingMaskIntoConstraints = false
        rightLbl.text = rightTitle
        rightLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
        let leftLbl = UILabel()
        leftLbl.translatesAutoresizingMaskIntoConstraints = false
        leftLbl.text = leftTitle
        leftLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
        let settingSwitch = UISwitch()
        settingSwitch.translatesAutoresizingMaskIntoConstraints = false
        settingSwitch.addTarget(self, action: action, for: .valueChanged)
        settingSwitch.setOn(switchState, animated: false)
        let containerSv = UIStackView(arrangedSubviews: [settingDescLbl, leftLbl, settingSwitch, rightLbl])
        NSLayoutConstraint.activate([
            settingSwitch.topAnchor.constraint(equalTo: containerSv.topAnchor, constant: 10)
        ])
        containerSv.translatesAutoresizingMaskIntoConstraints = false
        containerSv.axis = .horizontal
        containerSv.distribution = .fill
        containerSv.spacing = 5
        cell.contentView.addSubview(containerSv)
        NSLayoutConstraint.activate([
            containerSv.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            containerSv.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant:  -10),
            containerSv.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            containerSv.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        if #available(iOS 13.0, *) {
            cell.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? blackShade : whiteShade
        } else {
            // Fallback on earlier versions
            cell.backgroundColor = whiteShade
        }
    }
}
