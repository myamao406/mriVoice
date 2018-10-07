//
//  changeTextSizeColor.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/23.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit

open class changeText {
    class func SizeColor(size:Int = 0, btn:UIButton) {
        // テキストサイズ変更ボタン
        let attrText = NSMutableAttributedString(attributedString: btn.attributedTitle(for: .normal)!)
        
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, 3))
        btn.setAttributedTitle(attrText, for: .normal)
        
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSMakeRange(size, 1))
        
        btn.setAttributedTitle(attrText, for: .normal)
    }
    
}
