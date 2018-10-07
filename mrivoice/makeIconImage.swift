//
//  makeIconImage.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/23.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation
import FontAwesomeKit

open class FontAwesome {
    
    class func returnImage() -> UIImage {
        // 戻るボタン

//        let iconImage = FAKIonIcons.iosArrowLeftIcon(withSize: iconFont.s24)
        let iconImage = FAKFontAwesome.arrowLeftIcon(withSize: iconFont.s24)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        let Image = iconImage?.image(with: CGSize(width: iconSize.w24, height: iconSize.h24))
        
        return Image!
    }
    
    class func micImage() -> UIImage {
        // マイクボタン
//        let micImage = FAKIonIcons.iosMicOutlineIcon(withSize: iconFont.s50)
//        micImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
//        let micIcon = micImage?.image(with: CGSize(width: iconSize.w50, height: iconSize.h50))
        
        let iconImage = FAKFontAwesome.circleIcon(withSize: iconFont.s36)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: vColor.recButtonRed)
        let Image = iconImage?.image(with: CGSize(width: iconSize.w36, height: iconSize.h36))
        return Image!
    }

    class func pauseImage() -> UIImage {
        // ポーズボタン
        let iconImage = FAKFoundationIcons.stopIcon(withSize: iconFont.s50)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: vColor.recButtonRed)

//        let iconImage = FAKIonIcons.iosPauseIcon(withSize: iconFont.s50)
//        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        let Image = iconImage?.image(with: CGSize(width: iconSize.w50, height: iconSize.h50))
        
        return Image!
    }
    
    class func checkImage() -> UIImage {
        // OKボタン
        let iconImage = FAKFontAwesome.checkCircleIcon(withSize: iconFont.s36)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: vColor.redColor)
        let Image = iconImage?.image(with: CGSize(width: iconSize.w36, height: iconSize.h36))
        
        return Image!
    }
    
    class func redoImage() -> UIImage {
        // やり直しボタン
//        let iconImage = FAKIonIcons.iosReloadIcon(withSize: iconFont.s36)
        let iconImage = FAKFontAwesome.undoIcon(withSize: iconFont.s36)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: vColor.blackColor)
        let Image = iconImage?.image(with: CGSize(width: iconSize.w36, height: iconSize.h36))
        
        return Image!
    }
    
    class func playImage() -> UIImage {
        // プレイボタン
        let iconImage = FAKFontAwesome.playIcon(withSize: iconFont.s36)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: vColor.greenColor)
        let Image = iconImage?.image(with: CGSize(width: iconSize.w36, height: iconSize.h36))

        return Image!
    }

    class func pauseImage2() -> UIImage {
        // ポーズボタン
        let iconImage = FAKIonIcons.iosPauseIcon(withSize: iconFont.s36)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: vColor.blackColor)
        let Image = iconImage?.image(with: CGSize(width: iconSize.w36, height: iconSize.h36))
        
        return Image!
    }

    class func logoutImage() -> UIImage {
        // ログアウト
        let iconImage = FAKFontAwesome.signOutIcon(withSize: iconFont.s36)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: vColor.blackColor)
        let Image = iconImage?.image(with: CGSize(width: iconSize.w36, height: iconSize.h36))
        
        return Image!
    }
    
    class func userImage() -> UIImage {
        // ユーザーイメージ
        let iconImage = FAKFontAwesome.userIcon(withSize: iconFont.s50)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
        let Image = iconImage?.image(with: CGSize(width:iconSize.w50,height:iconSize.h50))
        return Image!
    }
    
    class func phoneImage() -> UIImage {
        // ポーズボタン
        let iconImage = FAKIonIcons.iphoneIcon(withSize: iconFont.s24)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: vColor.blackColor)
        let Image = iconImage?.image(with: CGSize(width:iconSize.w24,height:iconSize.h24))
        return Image!
    }

    class func signInImage() -> UIImage {
        let iconImage = FAKFontAwesome.signInIcon(withSize: iconFont.s24)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value:UIColor.white)
        let Image = iconImage?.image(with: CGSize(width:iconSize.w24,height:iconSize.h24))
        return Image!
    }
    
    class func cogImage() -> UIImage {
        let iconImage = FAKFontAwesome.cogIcon(withSize: iconFont.s36)
        iconImage?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value:vColor.blackColor)
        let Image = iconImage?.image(with: CGSize(width:iconSize.w36,height:iconSize.h36))
        return Image!
    }
}
