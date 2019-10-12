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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        addTableView()
//        tableView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        tableView.layoutIfNeeded()
//        tableView.reloadData()
    }
    
    func addTableView() {
       let laneScroller = LaneScroller(size: UIScreen.main.bounds.size)
        tableView = laneScroller.makeTable()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        print("Content Size: ",tableView.contentSize)
        print("Table View Size: ",tableView.bounds.size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

