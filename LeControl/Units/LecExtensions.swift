//
//  LecExtensions.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    /*
     字符串转颜色
     "#f00".hexColor       // r 1.0 g 0.0 b 0.0 a 1.0
     "#be1337".hexColor    // r 0.745 g 0.075 b 0.216 a 1.0
     "#12345678".hexColor  // r 0.204 g 0.337 b 0.471 a 0.071
     格式错误会返回透明的颜色
     */
    
    var hexColor: UIColor {
        let hex = self.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        guard Scanner(string: hex).scanHexInt32(&int) else {
            return UIColor.clear
        }
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return UIColor.clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIButton {
    
    /**
     //button上面图文上下排列，spacing为图片与文字的距离
     */
    
    func setButtonSpacing(_ spacing: CGFloat) {
        if let imageSize = self.imageView?.image?.size, let label = self.titleLabel, let text = label.text  {
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
            let titleSize = text.size(withAttributes: [NSAttributedStringKey.font: label.font])
            self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
        }
    }
}
