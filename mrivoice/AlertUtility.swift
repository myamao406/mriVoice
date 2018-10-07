//
//  AlertUtility.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/26.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation
import UIKit

struct AlertUtility
{
    /**
     アラートを表示する
     - parameter title タイトル
     - parameter message メッセージ
     - parameter okButtonTitle OKボタンの表示タイトル
     - parameter okHandler OKボタン押下後の処理ハンドラ
     - parameter cancelButtonTitle キャンセルボタンの表示タイトル
     - parameter cancelHandler キャンセルボタン押下後の処理ハンドラ
     - parameter viewController:アラートを表示するViewController
     */
    static private func showAlert(
        title: String,
        message: String?,
        okButtonTitle: String,
        okButtonHandler: ((UIAlertAction) -> Void)?,
        cancelButtonTitle: String? = nil,
        cancelButtonHandler: ((UIAlertAction) -> Void)? = nil,
        viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okButtonAction = UIAlertAction(title: okButtonTitle, style: .default, handler: okButtonHandler)
        alert.addAction(okButtonAction)
        if let buttonTitle = cancelButtonTitle {
            let cancelButtonAction = UIAlertAction(title: buttonTitle, style: .cancel, handler: cancelButtonHandler)
            alert.addAction(cancelButtonAction)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showNoticeAlert(
        title: String,
        message: String,
        okButtonTitle: String = NSLocalizedString("okButtonTitle", comment: "okButtonTitle"),
        okButtonHandler: ((UIAlertAction) -> Void)? = nil,
        cancelButtonTitle: String = NSLocalizedString("cancelButtonTitle", comment: "cancelButtonTitle"),
        cancelButtonHandler: ((UIAlertAction) -> Void)? = nil,
        viewController: UIViewController) {
        self.showAlert(
            title: title,
            message: message,
            okButtonTitle: okButtonTitle,
            okButtonHandler: okButtonHandler,
            cancelButtonTitle: cancelButtonTitle,
            cancelButtonHandler:cancelButtonHandler,
            viewController: viewController)
    }

    /**
     エラーアラートを表示する
     - parameter message:エラーメッセージ
     - parameter okButtonTitle:OKボタンの表示タイトル
     - parameter okHandler:OKボタン押下後の処理ハンドラ
     - parameter viewController:アラートを表示するViewController
     */
    static func showErrorAlert(
        title: String,
        message: String,
        okButtonTitle: String = NSLocalizedString("okButtonTitle", comment: "okButtonTitle"),
        okButtonHandler: ((UIAlertAction) -> Void)? = nil,
        viewController: UIViewController) {
        self.showAlert(
            title: title,
            message: message,
            okButtonTitle: okButtonTitle,
            okButtonHandler: okButtonHandler,
            viewController: viewController)
    }
    
    static func showErrorAlert(error: NSError?, viewController: UIViewController){
        guard let error = error else {
            return
        }
        let title: String = error.localizedDescription
        let message: String = error.localizedRecoverySuggestion ?? NSLocalizedString("connect_err_msg", comment: "")
        self.showErrorAlert(title: NSLocalizedString("error", comment: ""),message: message, okButtonTitle: title, viewController: viewController)
    }
}
