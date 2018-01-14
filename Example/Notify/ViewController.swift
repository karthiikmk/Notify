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
        
        self.title = "Chats"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func show(_ sender: Any) {
        
        Notify.shared.add(on: self.navigationController!)
            .delegate(for: self)
            .message(message: "No network connection")
            .closeIcon(icon: .closeWhite)
            .backgroundColor(color: .orange)
            .show()
    }
    
    @IBAction func hide(_ sender: Any) {
        Notify.shared.hide()
    }
    
    @IBAction func change(_sender: UIButton) {
    
        Notify.shared.message(message: "Connected...")
            .backgroundColor(color: .green)
            .change()
    }
    
    func didTapNotifyClose() {
        Notify.shared.hide()
    }
}
