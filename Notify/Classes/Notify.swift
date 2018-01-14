//
//  Zingle.swift
//  Zingle
//
//  Created by Hemang on 28/12/17.
//  Copyright © 2017 Hemang Shah. All rights reserved.
//

import UIKit
import PodAsset

extension UIView{
    
    static func view(FromNib nib: String? = "Notify") -> UIView? {
        guard let podBundle = PodAsset.bundle(forPod: "Notify"), let nib = podBundle.loadNibNamed("Notify", owner: self, options: nil)  else{
            fatalError()
        }
        return nib.first as! UIView
    }
}

public class NotifyConfig {
    ///Set delay to hide Zingle. Default: 2.0.
    public var delay: TimeInterval = 2.0
    ///Set duration of Zingle visible animation. Default: 0.3.
    public var duration: TimeInterval = 0.3
    ///Set Zingle message color. Default: white.
    public var messageColor: UIColor = UIColor.white
    ///Set Zingle message font. Default: UIFont.systemFont(ofSize: 15).
    public var messageFont: UIFont = UIFont.systemFont(ofSize: 15)
    ///Set Zingle message icon. Default: Empty UIImage.
    public var messageIcon: UIImage! = UIImage.init()
    ///Set Zingle background color. Default: red.
    public var backgroundColor: UIColor = UIColor.red
    
    public var notifyHeight: CGFloat = 40.0
}

open class NotifyView: UIView {
    
    @IBOutlet weak var message: UILabel! {
        didSet {
            message.textColor = UIColor.white
            message.font = UIFont.systemFont(ofSize: 15)
            message.backgroundColor = UIColor.clear
            message.textAlignment = .center
            message.text = ""
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public static func loadNotifyView() -> NotifyView {
        let instance: NotifyView = NotifyView.view(FromNib: "Notify") as! NotifyView
        return instance
    }
}


public class Notify: NSObject {
    
    typealias CompletionBlock = () -> Void
    
    fileprivate var notifyView: NotifyView!
    fileprivate var isShowing: Bool = false
    fileprivate var delay: TimeInterval
    fileprivate var duration: TimeInterval
    
    fileprivate var messageColor: UIColor = UIColor.white
    fileprivate var messageFont: UIFont = UIFont.systemFont(ofSize: 15)
    fileprivate let notifyHeight: CGFloat = 30.0
    
    fileprivate var completion: CompletionBlock? = nil
    
    public var navigationController: UINavigationController?
    
    fileprivate var yPosition: CGFloat {
        
        guard let navController = self.navigationController else {
            print("Error: Navigation controller not found")
            return 0.0
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        print("status bar height: \(statusBarHeight)")
        
        return (navController.navigationBar.intrinsicContentSize.height + statusBarHeight)
    }
    
    
    
    fileprivate var yPosWhenShowing: CGFloat {
        return self.yPosition
    }
    
    fileprivate var yPosWhenHidden: CGFloat {
        let yPos = self.yPosition - notifyHeight
        return yPos
    }

    public required init(duration: TimeInterval = 0.3, delay: TimeInterval = 2.0) {
        
        self.notifyView = NotifyView.loadNotifyView()
        
        self.delay = delay
        self.duration = duration
        
        super.init()
        
        self.setupNotify()
    }
}

// MARK: setup function
extension Notify {
    
    fileprivate func setupNotify() {
        self.setupView()
    }

    fileprivate func setupView() {
        notifyView.backgroundColor = UIColor.backgroundColor
        notifyView.frame = CGRect(x: 0, y: self.yPosWhenHidden, width: UIScreen.main.bounds.width, height: notifyHeight)
    }
    
    fileprivate func setupMessageButton() {
        
        notifyView.message.then {
            $0.textColor = self.messageColor
            $0.font = self.messageFont
            $0.backgroundColor = UIColor.clear
            $0.textAlignment = .center
            $0.text = ""
        }
    }
}

// MARK: chaning function and show / hide functions
public extension Notify {
    
    ///Set Zingle message to display.
    public func message(message: String!) -> Self {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration/4.0) {
            self.notifyView.message.text = message
        }
        return self
    }
    
    ///Set Zingle message icon.
    public func messageIcon(icon: UIImage!) -> Self {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration/1.5) {
            //self.messageButton.setImage(icon, for: .normal)
        }
        return self
    }
    
    ///Set Zingle message color.
    public func messageColor(color: UIColor!) -> Self {
        notifyView.message.textColor = color
        return self
    }
    
    ///Set Zingle background color.
    public func backgroundColor(color: UIColor!) -> Self {
        notifyView.message.backgroundColor = color
        return self
    }
    
    ///Set Zingle message font.
    public func messageFont(font: UIFont!) -> Self {
        self.notifyView.message.font = font
        return self
    }
    
    ///Handle Zinlge completion.
    public func completion(_ completion: @escaping () -> Void) -> Self {
        self.completion = completion
        return self
    }
    
    ///Show Zingle.
    public func show() -> Self {
        
        self.adjustView()
        
        self.startAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                
            }
        }
        
        return self
    }
    
    public func hide() {
        self.finishAnimating()
    }
}

// MARK: animation functions
extension Notify {
    
    fileprivate func startAnimation(completion: @escaping () -> Void) {
        
        guard !self.isShowing else {
            return
        }
        
        self.isShowing = true
        notifyView.alpha = 1.0
        
        UIView.animate(withDuration: duration, animations: {
            self.notifyView.frame.origin.y = self.yPosWhenShowing
            self.notifyView.layoutIfNeeded()
        }) { _ in
            completion()
        }
    }
    
    fileprivate func finishAnimating() {
        UIView.animate(withDuration: duration, animations: {
            self.notifyView.frame.origin.y = self.yPosWhenHidden
            self.notifyView.alpha = 0.0
            self.notifyView.layoutIfNeeded()
        }) { _ in
            self.isShowing = false
            self.completion?()
        }
    }
}

// MARK: manage window hierarchy functions
extension Notify {
    
    fileprivate func adjustView() {
        self.addZingleViewInWindow()
    }
    
    fileprivate func addZingleViewInWindow() {
        guard let keyWindow = UIApplication.shared.keyWindow,
            let rootViewController = keyWindow.rootViewController as? UINavigationController else {
                return
        }
        let navigationBar = rootViewController.navigationBar
        rootViewController.view.insertSubview(self.notifyView, belowSubview: navigationBar)
    }
}

// MARK: Extensions
fileprivate extension UIColor {
    static var backgroundColor: UIColor {
        return .blue
    }
}
