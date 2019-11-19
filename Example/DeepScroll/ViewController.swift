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
        
        //STEP 1: Add the laned scroller Table View to View Controller
        addTableView()
        addMenuTableView()
    }
    
    func addTableView() {
        //STEP 2: Read and pass data for the Table View
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
        
        //STEP 3: Create an instance of LanedScroller and define the callback to make cell
        lanedScroller = LanedScroller(tableViewData: unwrappedFeed.posts, cellMaker: {(cell: DeepScrollCell, post: Decodable) in
            
            if let post = post as? Post {
                
                if (cell.getViewsCount() > 0) {
                    
                    if let sv = cell.contentView.subviews[0].subviews[0] as? UIStackView {
                        if (sv.isKind(of: UIStackView.self)) {
                            self.setAvatar(profileUrl: post.profileUrl, avatar: (sv.subviews[0].subviews[0] as! UIImageView))
                            (sv.subviews[0].subviews[1] as! UILabel).text = post.name
                            (sv.subviews[0].subviews[2] as! UILabel).text = "45 min •"
                            (sv.subviews[1] as! UILabel).text = post.data
                            (sv.subviews[2].subviews[1] as! UILabel).text = String(post.likes)
                            (sv.subviews[2].subviews[2] as! UILabel).text = "\(post.comments) Comments"
                        }
                    }
                    return cell
                }
                else {
                    setPostCellContent(cell: cell, post: post) { (profileUrl, avatarIv) in
                        self.setAvatar(profileUrl: profileUrl, avatar: avatarIv)
                    }
                    return cell
                }
            }
            return DeepScrollCell()
        })
        lanedScroller.setDidSelectCallback(didSelectCallback: { (post) in
            self.navigationController?.pushViewController(CommentsVC(posts: Array(unwrappedFeed.posts[0...20])), animated: true)
        })
        
        //STEP 4: Get the instance of Table View Created by Laned Scroller
        tableView = lanedScroller.getTableView()
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        //STEP 5: Add the Table View to view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
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
            menuViewContiner.heightAnchor.constraint(equalToConstant: 2/3 * view.bounds.height),
        ])
        if !menuOpen {
            NSLayoutConstraint.activate([
                menuViewContiner.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 50),
            ])
        } else {
            NSLayoutConstraint.activate([
                menuViewContiner.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - view.bounds.height/3 - 20)
            ])
        }
        
        
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
        let origin: CGFloat = menuOpen ?  view.bounds.height - view.bounds.height/3 - 20 : view.bounds.height - 50
        UIView.animate(withDuration: 0.25) {
            self.menuViewContiner.frame.origin.y = origin
        }
    }
    
    @objc func toggleCompressionMode(s: UISwitch) {
        lanedScroller.toggleCompressionDirection()
    }
    
    @objc func toggleLaneWidth(s: UISwitch) {
        lanedScroller.toggleLaneWidthRatio()
    }
    
    @objc func toggleTapToExpandCell (s: UISwitch) {
        lanedScroller.setTapToExpandCell(to: s.isOn)
    }
    
    @objc func toggleAutoExpandCell (s: UISwitch) {
        lanedScroller.setAutoResetCellState(to: s.isOn)
    }
}

//MARK: Extension to handle settings menu table view methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
        
        if indexPath.row == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellId) {
                menuTableCellMaker(cell: cell, title: "Tap To Expand", leftTitle: "Off", rightTitle: "On", switchState: lanedScroller.isTapToExpandCellEnabled(), action: #selector(toggleTapToExpandCell(s:)))
                return cell
            }
        }
        
        if indexPath.row == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellId) {
                menuTableCellMaker(cell: cell, title: "Auto Expand", leftTitle: "Off", rightTitle: "On", switchState: lanedScroller.isAutoResetCellStateEnabled(), action: #selector(toggleAutoExpandCell(s:)))
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
