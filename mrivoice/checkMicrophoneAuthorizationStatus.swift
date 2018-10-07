//
//  checkMicrophoneAuthorizationStatus.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/08/24.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation
import AVFoundation

func checkMicrophoneAuthorizationStatus() {
    let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
    
    switch (status) {
    case .authorized:
        // ユーザーがアクセス許可を承認
        print("ユーザーがアクセス許可を承認")
        
        break;
    case .restricted:
        // まだアクセスが許可されていない
        print("まだアクセスが許可されていない")
        AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {(granted: Bool) in})
        break;
    case .notDetermined:
        // ユーザーがまだ選択を行っていない
        print("ユーザーがまだ選択を行っていない")
        AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {(granted: Bool) in})
        break;
    case .denied:
        // ユーザーがデータへアクセスすることを拒否
        print("ユーザーがデータへアクセスすることを拒否")
        AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {(granted: Bool) in})
        break;
    }
}
