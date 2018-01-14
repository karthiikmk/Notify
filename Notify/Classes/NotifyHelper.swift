//
//  NotifyHelper.swift
//  Notify
//
//  Created by Karthik on 1/14/18.
//

import Foundation
import PodAsset

public enum NotifyIcon: String {
    
    case closeGray
    case closeWhite
    
    var name: String {
        
        switch self {
            
        case .closeGray:
            return "close_gray"
            
        case .closeWhite:
            return "close_white"
        }
    }
    
    var icon: UIImage {
        return NotifyHelper.getImageFromBundle(name: self.name)
    }
}

extension UIView {
    
    static func view(FromNib nib: String? = "Notify") -> UIView? {
        guard let podBundle = PodAsset.bundle(forPod: "Notify"), let nib = podBundle.loadNibNamed("Notify", owner: self, options: nil)  else{
            fatalError()
        }
        return nib.first as! UIView
    }
}

class NotifyHelper {
    
    public static func getImageFromBundle(name: String = "Notify") -> UIImage {
        
        let podBundle = PodAsset.bundle(forPod: name)
        
        guard let image = UIImage(named: name, in: podBundle, compatibleWith: nil) else {
            return UIImage()
        }
        
        return image
    }
}
