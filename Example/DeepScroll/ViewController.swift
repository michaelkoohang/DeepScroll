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

    private var tableView: UITableView!
    private var dataSource = LanedScrollerDataSource()
    private var delegate = LanedScrollerDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(listenScrollState), name: NSNotification.Name(rawValue: "scrollState"), object: nil)
    }
    
    override func loadView() {
        super.loadView()
        addTableView()
    }
    
    @objc
    func listenScrollState(notifcation: Notification) {
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.endUpdates()
        //        tableView.reloadData()
    }
    
    func addTableView() {

        tableView = UITableView()
        view.addSubview(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: dataSource.cellId)
                
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

//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        50
//    }
//}
//
//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
//        cell.textLabel!.text = "Cell"
//        return cell
//    }
//}

