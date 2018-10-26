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
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler:  { result in
                    print(result)
                })
            }
        }

        AlertUtility.showNoticeAlert(
            title:NSLocalizedString("access_permission", comment: "title"),
            message: NSLocalizedString("camera_access", comment: "message"),
            okButtonTitle: NSLocalizedString("setting", comment: "okButtonTitle"),
            okButtonHandler: okButtonHandler,
            cancelButtonTitle: NSLocalizedString("cancel", comment: "cancelButtonTitle"),
            cancelButtonHandler: nil,
            viewController: viewController)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
