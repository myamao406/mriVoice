//
//  TapSound.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/04/17.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox

open class TapSound {
    open class func buttonTap(_ file:String,type:String){
        // タップ音設定
        AVAudioPlayerUtil.setValue(
            URL(
                fileURLWithPath: Bundle.main.path(
                    forResource: file,
                    ofType: type)!
            )
        )
        // 音設定（ボリューム）
        AVAudioPlayerUtil.audioPlayer.volume = 1.0

        AVAudioPlayerUtil.play()
    }
    
    open class func errorBeep(_ file:String,type:String){
        
        if file == "" || type == "" {return}
        
        // タップ音設定
        AVAudioPlayerUtil.setValue_loop(
            URL(
                fileURLWithPath: Bundle.main.path(
                    forResource: file,
                    ofType: type)!
            )
        )
        // 音設定（ボリューム）
        AVAudioPlayerUtil.audioPlayer.volume = 1.0
        
        AVAudioPlayerUtil.play()
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    open class func errorBeep_stop(){
        AVAudioPlayerUtil.stop()
    }
}
