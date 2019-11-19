//
//  FeedVC.swift
//  DeepScroll
//
//  Created by parthv21 on 10/11/2019.
//  Copyright (c) 2019 parthv21. All rights reserved.
//

import UIKit
import DeepScroll

class FeedVC: UIViewController {
    
    private var lanedScroller: LanedScroller!
    private var tableView: UITableView!
    private var menuView: UITableView!
    private var menuOpen = false
    private let settingsCellId = "ExampleAppSettingsCellId"
    private var menuViewContainer: UIView!
    private var downloadedImages: [String: UIImage] = [:]
    
    private let whiteShade = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    private let blackShade = UIColor(red:0.10, green:0.13, blue:0.16, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configures navigation bar appearance if iOS 13 is available.
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
                
                // If the cell has views inside of it.
                if (cell.getViewsCount() > 0) {
            
                    // Set the content of all the views inside of the cells that exist.
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
                } else {
                    
                    // Create a cell with new views inside of it.
                    setPostCellContent(cell: cell, post: post) { (profileUrl, avatarIv) in
                        self.setAvatar(profileUrl: profileUrl, avatar: avatarIv)
                    }
                    return cell
                }
            }
            return DeepScrollCell()
        })
        
        // Callback for when user taps on cell. Presents new view controller of comments.
        lanedScroller.setDidSelectCallback(didSelectCallback: { (post) in
            self.navigationController?.pushViewController(CommentsVC(posts: Array(unwrappedFeed.posts[0...20])), animated: true)
        })
        
        //STEP 4: Get the instance of Table View Created by Laned Scroller and configure.
        tableView = lanedScroller.getTableView()
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        //STEP 5: Add the Table View to view and set constraints.
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ])
        
    }
    
    // Function for setting image of avatar.
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
    
    // Function for retrieving image data from URL.
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

extension FeedVC {
    
    // Function for creating settings menu.
    func addMenuTableView() {
        
        // Setup menu view container.
        menuViewContainer = UIView(frame: CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 2/3 * view.bounds.height))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.toggleSettingsPane(_:)))
        menuViewContainer.addGestureRecognizer(tap)
        view.addSubview(menuViewContainer)
        menuViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // If iOS 13 is available, handle dark and light mode colors.
        if #available(iOS 13.0, *) {
            menuViewContainer.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? blackShade : whiteShade
        } else {
            // Leave color white if dark mode not available.
            menuViewContainer.backgroundColor = whiteShade
        }
        
        // Setup constraints for menu view container.
        NSLayoutConstraint.activate([
            menuViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuViewContainer.heightAnchor.constraint(equalToConstant: 2/3 * view.bounds.height),
        ])
        
        // Adjust constraints if the menu is open or closed.
        if !menuOpen {
            NSLayoutConstraint.activate([
                menuViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 50),
            ])
        } else {
            NSLayoutConstraint.activate([
                menuViewContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - view.bounds.height/3 - 20)
            ])
        }
        
        // Setup settings title text.
        let settingsText = UILabel()
        settingsText.text = "Settings"
        settingsText.font = UIFont(name: "HelveticaNeue-Bold", size: 25.0)
        settingsText.textAlignment = .center
        settingsText.baselineAdjustment = .alignCenters
        menuViewContainer.addSubview(settingsText)
        settingsText.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints for settings title text.
        NSLayoutConstraint.activate([
            settingsText.leadingAnchor.constraint(equalTo: menuViewContainer.leadingAnchor, constant: 5),
            settingsText.topAnchor.constraint(equalTo: menuViewContainer.topAnchor, constant: -10),
            settingsText.heightAnchor.constraint(equalToConstant: 60),
            settingsText.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        menuView = UITableView()
        
        // If iOS 13 is available, handle dark and light mode colors.
        if #available(iOS 13.0, *) {
            menuView.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? blackShade : whiteShade
        } else {
            // Leave color white if dark mode not available.
            menuView.backgroundColor = whiteShade
        }
        
        // Configure menu view.
        menuView.delegate = self
        menuView.dataSource = self
        menuView.register(UITableViewCell.self, forCellReuseIdentifier: settingsCellId)
        menuViewContainer.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup contraints for menu view.
        NSLayoutConstraint.activate([
            menuView.leadingAnchor.constraint(equalTo: menuViewContainer.leadingAnchor),
            menuView.topAnchor.constraint(equalTo: menuViewContainer.topAnchor, constant: 40),
            menuView.bottomAnchor.constraint(equalTo: menuViewContainer.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: menuViewContainer.trailingAnchor)
        ])
        
    }
    
    // Toggles slide up and slide down of settings menu view.
    @objc func toggleSettingsPane(_ sender: UITapGestureRecognizer? = nil) {
        menuOpen = self.menuViewContainer.frame.origin.y == view.bounds.height - 50
        let origin: CGFloat = menuOpen ?  view.bounds.height - view.bounds.height/3 - 20 : view.bounds.height - 50
        UIView.animate(withDuration: 0.25) {
            self.menuViewContainer.frame.origin.y = origin
        }
    }
    
    // Functions for setting configuration options in the settings menu.
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

//MARK: Extension to handle settings menu.

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    // Sets the number of rows inside of the UITableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // Configures cell at each row in the UITableView.
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
    
    // Sets height for rows inside of UITableView.
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
        
        // Settings description label setup.
        let settingDescLbl = UILabel()
        settingDescLbl.translatesAutoresizingMaskIntoConstraints = false
        settingDescLbl.text = title
        settingDescLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
        
        // Right label setup.
        let rightLbl = UILabel()
        rightLbl.translatesAutoresizingMaskIntoConstraints = false
        rightLbl.text = rightTitle
        rightLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
        
        // Left label setup.
        let leftLbl = UILabel()
        leftLbl.translatesAutoresizingMaskIntoConstraints = false
        leftLbl.text = leftTitle
        leftLbl.font = UIFont(name: "HelveticaNeue", size: 13.0)
        
        // Settings switch setup.
        let settingSwitch = UISwitch()
        settingSwitch.translatesAutoresizingMaskIntoConstraints = false
        settingSwitch.addTarget(self, action: action, for: .valueChanged)
        settingSwitch.setOn(switchState, animated: false)
        
        // Stackview setup.
        let containerSv = UIStackView(arrangedSubviews: [settingDescLbl, leftLbl, settingSwitch, rightLbl])
        containerSv.translatesAutoresizingMaskIntoConstraints = false
        containerSv.axis = .horizontal
        containerSv.distribution = .fill
        containerSv.spacing = 5
        cell.contentView.addSubview(containerSv)
        
        // Set up constraints for menu.
        NSLayoutConstraint.activate([
            settingSwitch.topAnchor.constraint(equalTo: containerSv.topAnchor, constant: 10),
            
            containerSv.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            containerSv.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant:  -10),
            containerSv.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            containerSv.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        
        // If iOS 13 is available, handle dark and light mode colors.
        if #available(iOS 13.0, *) {
            cell.backgroundColor = UITraitCollection.current.userInterfaceStyle == .dark ? blackShade : whiteShade
        } else {
            // Leave color white if dark mode not available.
            cell.backgroundColor = whiteShade
        }
    }
}
