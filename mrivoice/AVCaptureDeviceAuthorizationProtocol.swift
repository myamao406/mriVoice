//
//  AVCaptureDeviceAuthorizationProtocol.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/26.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import AVFoundation
import UIKit

protocol AVCaptureDeviceAuthorizationProtocol {
    // マイクを起動する
    func launchMic(successHandler:(() -> Void), viewController: UIViewController)
}

extension AVCaptureDeviceAuthorizationProtocol {
    func launchMic(successHandler:@escaping (() -> Void), viewController: UIViewController) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        switch status {
        case .authorized:
            successHandler()
        case .denied:
            self.showCamereAlert(viewController: viewController)
        case .restricted:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio) { (isGranted: Bool) -> () in
                if isGranted {
                    successHandler()
                }
            }
        }
    }
    
    private func showCamereAlert(viewController: UIViewController) {
        let okButtonHandler = { (action: UIAlertAction) -> () in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler:  { result in
                    print(result)
                })
            }
        }

        AlertUtility.showNoticeAlert(
            title:"アクセス許可設定",
            message: "カメラへのアクセスを許可してください",
            okButtonTitle: "設定する",
            okButtonHandler: okButtonHandler,
            cancelButtonTitle: "キャンセル",
            cancelButtonHandler: nil,
            viewController: viewController)
    }
}
