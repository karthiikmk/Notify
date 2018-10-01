//
//
//  Notify
//
//  Created by Karthik on 1/14/18.
//

import UIKit

public protocol NotifyDelegate: class {
    func didTapNotifyClose()
}

protocol NotifyViewDelegate: class {
    func didTapClose()
}

open class NotifyView: UIView {
    
    weak var delegate: NotifyViewDelegate?
    
    @IBOutlet weak var message: UILabel! {
        didSet {
            message.textColor = UIColor.white
            message.font = UIFont.systemFont(ofSize: 16)
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

    public static func loadNotifyView() -> NotifyView? {
        return NotifyView.loadFromXib()
    }
    
    @IBAction func close(_ sender: UIButton) {
        delegate?.didTapClose()
    }
}

public class Notify: NSObject, NotifyViewDelegate {
    
    public static let shared = Notify()
    
    open var notifyView: NotifyView? = nil
    
    ///UI'S
    fileprivate var isShowing: Bool = false
    fileprivate var canShowClose: Bool = false
    fileprivate var duration: TimeInterval = 0.4
    
    fileprivate var messageColor: UIColor = UIColor.white
    fileprivate var messageFont: UIFont = UIFont.systemFont(ofSize: 16)
    fileprivate var notifyHeight: CGFloat = 30
    fileprivate var customYPosition: CGFloat?
    
    public weak var delegate: NotifyDelegate? = nil
    fileprivate var navigationController: UINavigationController?
    
    fileprivate var yPosition: CGFloat {
        
        guard let navController = self.navigationController else {
            print("Error: Navigation controller not found")
            return 0.0
        }
        
        guard let yPos = customYPosition else {
            return (navController.navigationBar.intrinsicContentSize.height + UIApplication.shared.statusBarFrame.height)
        }
        return yPos
    }
    
    fileprivate var yPosWhenShowing: CGFloat {
        return self.yPosition
    }
    
    fileprivate var yPosWhenHidden: CGFloat {
        let yPos = self.yPosition - notifyHeight
        return yPos
    }
    
    public override init() {
        super.init()
    }
    
    // MARK: > Delegate
    func didTapClose() {
        delegate?.didTapNotifyClose()
    }
}

// MARK: chaning function and show / hide functions
public extension Notify {
    
    //Should be called first
    public func add(on navigationController: UINavigationController, withHeight height: CGFloat = 30, yPosition yPos: CGFloat? = nil) -> Self {
        
        self.navigationController = navigationController
        self.notifyHeight = height
        self.delegate = delegate
        self.customYPosition = yPos
        
        if let alreadyShowing = self.notifyView {
            self.isShowing = false
            alreadyShowing.removeFromSuperview()
        }
        
        self.setupNotify()
        
        return self
    }
    
    fileprivate func setupNotify() {
        
        self.notifyView = NotifyView.loadNotifyView()
        self.notifyView?.delegate = self
        self.notifyView?.backgroundColor = UIColor(hexStr: "6666FF")
        self.notifyView?.frame = CGRect(x: 0, y: self.yPosWhenHidden, width: UIScreen.main.bounds.width, height: notifyHeight)
    }
    
    public func delegate(for delegator: NotifyDelegate) -> Self {
        self.delegate = delegator
        return self
    }
    
    public func speed(speed: TimeInterval = 0.4) -> Self {
        self.duration = speed
        return self
    }
    
    public func message(message: String) -> Self {
        if let view = notifyView {
            view.message.text = message
        }
        return self
    }
    
    public func closeIcon(icon: UIImage) -> Self {
        if let view = notifyView {
            view.closeButton.setImage(icon, for: .normal)
            view.closeButton.setImage(icon, for: .highlighted)
            view.closeButton.setImage(icon, for: .selected)
        }
        canShowClose = true
        return self
    }
    
    public func closeIcon(icon: NotifyIcon) -> Self {
        if let view = notifyView {
            view.closeButton.setImage(icon.icon, for: .normal)
            view.closeButton.setImage(icon.icon, for: .highlighted)
            view.closeButton.setImage(icon.icon, for: .selected)
        }
        canShowClose = true
        return self
    }

    public func messageColor(color: UIColor!) -> Self {
        if let view = notifyView {
            view.message.textColor = color
        }
        return self
    }
    
    public func messageAlignment(alignment: NSTextAlignment = .center) -> Self {
        if let view = notifyView {
            view.message.textAlignment = alignment
        }
        return self
    }

    public func backgroundColor(color: UIColor!) -> Self {
        if let view = notifyView {
            view.backgroundColor = color
        }
        return self
    }
    
    public func backgroundColor(color: NotifyColor) -> Self {
        if let view = notifyView {
            view.backgroundColor = color.color
        }
        return self
    }
    
    public func messageFont(font: UIFont!) -> Self {
        if let view = notifyView {
            view.message.font = font
        }
        
        return self
    }

    public func show(hideAfter delay: TimeInterval = 0) {
    
        self.addNotifyInWindow()
        
        self.startAnimation {
            
            guard !delay.isZero else {
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.finishAnimating()
            }
        }
    }
    
    public func hide() {
        self.finishAnimating()
    }
    
    public func change() {
        
    }
}

// MARK: animation functions
extension Notify {
    
    fileprivate func startAnimation(completion: (() -> Void)? = nil) {
        
        guard let notifyView = self.notifyView else {
            return
        }
        
        guard !self.isShowing else {
            return
        }
        
        self.isShowing = true
        
        notifyView.alpha = 0
        notifyView.closeButton.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            
            notifyView.alpha = 1
            notifyView.frame.origin.y = self.yPosWhenShowing
            notifyView.layoutIfNeeded()
            
        }) { _ in
            notifyView.closeButton.alpha = self.canShowClose ? 1.0 : 0.0
            completion?()
        }
    }
    
    fileprivate func finishAnimating() {
        
        guard let notifyView = self.notifyView else {
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            notifyView.frame.origin.y = self.yPosWhenHidden
            notifyView.layoutIfNeeded()
        }) { _ in
            notifyView.alpha = 0.0
            self.isShowing = false
            notifyView.removeFromSuperview()
        }
    }
}

// MARK: manage window hierarchy functions
extension Notify {
    
    fileprivate func addNotifyInWindow() {
        
        guard let navController = self.navigationController else {
            print("Error: Navigation controller not found")
            return
        }
        
        guard let view = self.notifyView else {
            print("Error: NotifyView not available")
            return
        }
        
        let navigationBar = navController.navigationBar
        navController.view.insertSubview(view, belowSubview: navigationBar)
    }
}
