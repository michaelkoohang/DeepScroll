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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let laneScroller = LaneScroller(size: 100)
        let dummyView = laneScroller.makeView()
        dummyView.backgroundColor = .black
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dummyView)

//        let tableView = laneScroller.makeTable()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

