//
//  ViewController.swift
//  Notify
//
//  Created by karthikAdaptavant on 01/14/2018.
//  Copyright (c) 2018 karthikAdaptavant. All rights reserved.
//

import UIKit
import Notify

class ViewController: UIViewController, NotifyProtocol {

    var alert: Notify!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func show(_ sender: Any) {
        
        Notify.shared.add(on: self.navigationController!)
            .delegate(for: self)
            .message(message: "This is example")
            .closeIcon(icon: .closeWhite)
            .show()
        
    }
    
    @IBAction func hide(_ sender: Any) {
        Notify.shared.hide()
    }
    
    func didTapNotifyClose() {
        Notify.shared.hide()
    }
}

