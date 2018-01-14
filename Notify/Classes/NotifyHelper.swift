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

public enum NotifyColor {
    
    case green
    case gray
    case red
    case orange
    case purple
    case lightBlue
    case orchid
    case salmon
    
    var color: UIColor {
        switch self {
        case .green:
            return UIColor(hexString: "#43a047")
        case .gray:
            return UIColor(hexString: "#607d8b")
        case .red:
            return UIColor(hexString: "##F44336")
        case .orange:
            return UIColor(hexString: "#ff5722")
        case .purple:
            return UIColor(hexString: "#7c4dff")
        case .lightBlue:
            return UIColor(hexString: "#29b6f6")
        case .orchid:
            return UIColor(hexString: "#6666FF")
        case .salmon:
            return UIColor(hexString: "#FF6666")
        }
    }
}

extension UIView {
    
    static func view(FromNib nib: String? = "Notify") -> UIView? {
        guard let podBundle = PodAsset.bundle(forPod: "Notify"), let nib = podBundle.loadNibNamed("Notify", owner: self, options: nil)  else{
            fatalError()
        }
        return nib.first as? UIView
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
