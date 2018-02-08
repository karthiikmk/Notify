//
//  NotifyHelper.swift
//  Notify
//
//  Created by Karthik on 1/14/18.
//

import Foundation

public enum NotifyIcon: String {
    
    case closeGray
    case closeWhite
    
    var name: String {
        
        switch self {
            
        case .closeGray:
            return "Close-Gray"
            
        case .closeWhite:
            return "Close-White"
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
            return UIColor(hexStr: "#43a047")
        case .gray:
            return UIColor(hexStr: "#607d8b")
        case .red:
            return UIColor(hexStr: "##F44336")
        case .orange:
            return UIColor(hexStr: "#ff5722")
        case .purple:
            return UIColor(hexStr: "#7c4dff")
        case .lightBlue:
            return UIColor(hexStr: "#29b6f6")
        case .orchid:
            return UIColor(hexStr: "#6666FF")
        case .salmon:
            return UIColor(hexStr: "#FF6666")
        }
    }
}

extension UIView {
    
    static func loadFromXib(withOwner: Any? = nil, options: [AnyHashable : Any]? = nil) -> NotifyView? {
        
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "Notify", bundle: bundle)
        guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? NotifyView else {
            return nil
        }        
        return view
    }
}

extension UIColor {
    convenience init(hexStr: String) {
        let hex = hexStr.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

class NotifyHelper {
    
    static func getBundle() -> Bundle? {
        
        let podBundle = Bundle(for: self)
        
        guard let bundleUrl = podBundle.url(forResource: "Notify", withExtension: "bundle") else {
            return nil
        }
        
        guard let bundle = Bundle(url: bundleUrl) else {
            return nil
        }
        
        return bundle
    }
    
    static func getImageFromBundle(name: String = "Notify") -> UIImage {
        
        guard let podBundle = self.getBundle(), let image = UIImage(named: name, in: podBundle, compatibleWith: nil) else {
            return UIImage()
        }
        
        return image
    }
}
