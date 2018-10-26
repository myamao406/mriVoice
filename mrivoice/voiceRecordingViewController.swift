//
//  voiceRecordingViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/23.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit
import EZAudio
import FirebaseAuth
import AVFoundation

class voiceRecordingViewController: UIViewController,UINavigationBarDelegate,CountDownDelegate {

    @IBOutlet weak var returnBarButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var textSizeButton: UIButton!
    @IBOutlet weak var voiceTextView: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var plotView: UIView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    @IBOutlet weak var beforeRecLabel: UILabel!
    @IBOutlet weak var onAirLabel: UILabel!
    
    // The microphone component
    var microphone: EZMicrophone?
    // The recorder component
    var recorder: EZRecorder?
    var audioPlot: EZAudioPlot?
    var startTime = Date()
    var contentOffset = CGPoint.zero //init
    var view_flag = true
    var ageID = 0
    var genderID = 0
    
    var countDownView:CountDownView = CountDownView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    
    var baseView:UIView!
    
    var isOnAir: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.delegate = self
        navBar.barTintColor = vColor.titleBlueColor
        
        countDownView.delegate = self
        
        // 戻るボタン
        returnBarButton.image = FontAwesome.returnImage()
        // マイクボタン
        micButton.setImage(FontAwesome.micImage(), for: UIControl.State())
        // 背景色
        micButton.backgroundColor = vColor.silverColoer
        // 角丸
        micButton.layer.cornerRadius = micButton.frame.height / 2
        
        // テキストサイズ変更ボタン
        changeText.SizeColor(size: text_size_mode,btn:textSizeButton)
        voiceTextView.font = UIFont.systemFont(ofSize: voice_text_size[text_size_mode])
        
        beforeRecLabel.backgroundColor = vColor.bargainsYellowColor
        beforeRecLabel.textColor = UIColor.white
        onAirLabel.backgroundColor = UIColor.white
        onAirLabel.textColor = UIColor.black
        
        //baseView作成
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        self.baseView = UIView(frame: CGRect(x: 0, y: 0, width: myBoundSize.width, height: myBoundSize.height))
        //画面centerに
        self.baseView.center = self.view.center
        self.baseView.alpha = 0.5
        
        setContents()
        
        checkMicrophoneAuthorizationStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
        var iconImage : UIImage!
        if isOnAir {
            // 録音終了ボタン
            iconImage = FontAwesome.pauseImage()
        } else {
            // マイクボタン
            iconImage = FontAwesome.micImage()
        }
        micButton.setImage(iconImage, for: UIControl.State())

//        if view_flag {
//            view_flag = false
//            print(#function)
//            // Create an instance of the microphone and tell it to use this view controller instance as the delegate
//            if microphone?.delegate == nil {
//                print(#function + ": microphone nil")
//                microphone = EZMicrophone(microphoneDelegate: self)
//            }
//            self.record()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        voiceTextView.contentOffset = contentOffset //set
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        contentOffset = voiceTextView.contentOffset //keep
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentOffset = CGPoint.zero //init
    }
    
    // MARK: Dealloc
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // ステータスバーとナビゲーションバーの色を同じにする
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    // ステータスバーの文字を白にする
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    func setPlotView() {
        
    }
    
    func setContents() {
        ageLabel.text = ""
        genderLabel.text = ""
        titleLabel.text = ""
        createdLabel.text = ""
        deadLineLabel.text = ""
        voiceTextView.text = ""
        
        for vList in voiceLists {
            let contents = vList.filter({$0.vID == SELECT_VOICE_NO && $0.projectID == SELECT_PROJECT_NO})
            if contents.count > 0 {
                for content in contents {
                    ageID = content.Age
                    genderID = content.Gender
//                    ageLabel.text = listLabel.ageLabel[ageID]
//                    genderLabel.text = listLabel.genderLabel[genderID]
                    ageLabel.text = getLabel.age(ageID: ageID)
                    genderLabel.text = getLabel.gender(genderID: genderID)

                    titleLabel.text = content.Title
                    createdLabel.text = content.Created
                    deadLineLabel.text = content.Deadline
                    voiceTextView.text = content.contents
                    break;
                }
            }
        }
    }
    
    // MARK: - Navigation

    @IBAction func textSizeChangeButtonTap(_ sender: Any) {
        switch text_size_mode{
        case tSize.smallText:
            text_size_mode = tSize.middleText
        case tSize.middleText:
            text_size_mode = tSize.largeText
        case tSize.largeText:
            text_size_mode = tSize.smallText
        default:
            break
        }
        // テキストサイズ変更ボタン
        changeText.SizeColor(size: text_size_mode,btn:textSizeButton)
        
        voiceTextView.font = UIFont.systemFont(ofSize: voice_text_size[text_size_mode])
    }
    
    @IBAction func micButtonTap(_ sender: Any) {
        // 録音しているとき
        if isOnAir {
            isOnAir = !isOnAir
            // 録音終了
            
            audioPlot?.removeFromSuperview()
            microphone?.stopFetchingAudio()
            // Close the audio file
            if let recorder = recorder {
                recorder.closeAudioFile()
            }
            if voice_timer.isValid {
                voice_timer.invalidate()
                timerLabel.text = ""
            }
            self.performSegue(withIdentifier: "toVoiceCheckViewSegue",sender: nil)
            
        } else {
            isOnAir = !isOnAir
            
            onAirLabel.backgroundColor = vColor.bargainsYellowColor
            onAirLabel.textColor = UIColor.white
            beforeRecLabel.backgroundColor = UIColor.white
            beforeRecLabel.textColor = UIColor.black

            if isCountDown {
                countDownView.center = CGPoint(x: view.bounds.size.width / 2.0, y: view.bounds.height / 2.0)
                view.addSubview(baseView)
                baseView.addSubview(countDownView)
                countDownView.start(max: 3)

            } else {
                self.onRec()
            }

        }
        
    }
    
    // 録音するファイルのパスを取得(録音時、再生時に参照)
    func documentFilePath()-> URL {
        let urls = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
        let dirURL = urls[0]
        
        let now = Date() // 現在日時の取得
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP") // ロケールの設定
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        
        let usrID = uid == "" ? "???" : uid
        let genderStr = gender == "" ? "m" : gender
        let countryStr = country == "" ? "jp" : country
        
        let contentID = String(format: "%08d", SELECT_VOICE_NO)
        let ageIDs = String(format: "%02d", ageID)
        let genderIDs = String(format: "%02d", genderID)
        
        let fileName = usrID + "_" + contentID + "_" + ageIDs + "_" + genderIDs + "_" + genderStr + "_" + countryStr + "_ip_" + dateFormatter.string(from: now) + ".aiff"
        AudioFileName =  dirURL.appendingPathComponent(fileName)
        print(#function,dirURL.appendingPathComponent(fileName))
        return AudioFileName!
    }
    
    // 次の画面から戻ってくるときに必要なsegue情報
    @IBAction func unwindToVoiceRecording(_ segue: UIStoryboardSegue) {
    }
    
    func record(){
        // Create the recorder
        audioPlot?.clear()
        guard let microphone = microphone else {
            print("return")
            return
        }
        self.audioPlot = EZAudioPlot(frame: plotView.frame)
        self.audioPlot?.backgroundColor = UIColor.clear
        self.audioPlot?.color = UIColor.white
        self.audioPlot?.plotType = .rolling
        self.audioPlot?.gain = 5.0
        self.audioPlot?.shouldFill = true
        self.audioPlot?.shouldMirror = true
        
        //Viewに追加
        self.plotView.addSubview(audioPlot!)
        
        let idx = asbds.index(where: {$0.projectNo == SELECT_PROJECT_NO})
        
        var tempAsbd:asbd?
        var mBytesPerFrame:UInt32?
        var mBytesPerPacket:UInt32?
        if idx == nil {
            tempAsbd = asbd(projectNo:SELECT_PROJECT_NO)
            
        } else {
            tempAsbd = asbds[idx!]
        }
        mBytesPerFrame = tempAsbd!.bitsPerChannel / 8 * tempAsbd!.channelsPerFrame
        mBytesPerPacket = mBytesPerFrame! * tempAsbd!.channelsPerFrame
        
        let fType = tempAsbd?.getFileType(ext: tempAsbd!.ext)
        
        let lasbd = AudioStreamBasicDescription(
            mSampleRate: tempAsbd!.sampleRate,
            mFormatID: fType!.formatID,
            mFormatFlags: AudioFormatFlags(kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger),
            mBytesPerPacket: mBytesPerPacket!,
            mFramesPerPacket: tempAsbd!.framesPerPacket,
            mBytesPerFrame: mBytesPerFrame!,
            mChannelsPerFrame: tempAsbd!.channelsPerFrame,
            mBitsPerChannel: tempAsbd!.bitsPerChannel,
            mReserved: 0)

//        let asbd = AudioStreamBasicDescription(
//            mSampleRate: sampleRate,
//            mFormatID: kAudioFormatLinearPCM,
//            mFormatFlags: AudioFormatFlags(kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger),
//            mBytesPerPacket: bytesPerPacket,
//            mFramesPerPacket: framesPerPacket,
//            mBytesPerFrame: bytesPerFrame,
//            mChannelsPerFrame: channelsPerFrame,
//            mBitsPerChannel: bitsPerChannel,
//            mReserved: 0)

        microphone.setAudioStreamBasicDescription(lasbd)

        microphone.startFetchingAudio()
        print(microphone.audioStreamBasicDescription().mSampleRate)
        recorder = EZRecorder(url: self.documentFilePath(),
                              clientFormat: (microphone.audioStreamBasicDescription()),
                              fileType: fType!.fileType )
//        recorder = EZRecorder(url: self.documentFilePath(),
//                              clientFormat: (microphone.audioStreamBasicDescription()),
//                              fileType: EZRecorderFileType.WAV )

        self.updating()
    }

    
    @objc func updating()  {
        if voice_timer.isValid {
            voice_timer.invalidate()
        }
        
        voice_timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
        startTime = Date()
//        voice_time += 1
        
    }
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTime)

        let hour = (Int)(fmod((currentTime/60/60), 60))
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        let msec = (Int)((currentTime - floor(currentTime))*100)
        
        // %02d： ２桁表示、0で埋める
        let sHour = String(format:"%02d", hour)
        let sMinute = String(format:"%02d", minute)
        let sSecond = String(format:"%02d", second)
        let sMsec = String(format:"%02d", msec)
        
        timerLabel.text = sHour + ":" + sMinute + ":" + sSecond + "." + sMsec
        
        if second >= 5 {
            micButtonTap(micButton)
        }
        
    }

    // MARK: - CountDownView
    
    func didCount(count: Int) {
        print("didiCount(\(count))")
        TapSound.buttonTap(countDownchime.sFile , type: countDownchime.sType)
    }
    
    func didFinish() {
        print("didFinish")
        self.baseView.removeFromSuperview()
        
        onRec()
        
    }
    
    func onRec() {
        // 録音終了ボタン
        micButton.setImage(FontAwesome.pauseImage(), for: UIControl.State())
        
        print(#function)
        // Create an instance of the microphone and tell it to use this view controller instance as the delegate
        if microphone?.delegate == nil {
            print(#function + ": microphone nil")
            microphone = EZMicrophone(microphoneDelegate: self)
        }
        self.record()
    }
    
//    func checkMicrophoneAuthorizationStatus() {
//        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
//
//        switch (status) {
//        case .authorized:
//            // ユーザーがアクセス許可を承認
//            print("ユーザーがアクセス許可を承認")
//
//            break;
//        case .restricted:
//            // まだアクセスが許可されていない
//            print("まだアクセスが許可されていない")
//            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {(granted: Bool) in})
//            break;
//        case .notDetermined:
//            // ユーザーがまだ選択を行っていない
//            print("ユーザーがまだ選択を行っていない")
//            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {(granted: Bool) in})
//            break;
//        case .denied:
//            // ユーザーがデータへアクセスすることを拒否
//            print("ユーザーがデータへアクセスすることを拒否")
//            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: {(granted: Bool) in})
//            break;
//        }
//    }
    
}
// MARK: EZMicrophoneDelegate
extension voiceRecordingViewController: EZMicrophoneDelegate {
    func microphone(_ microphone: EZMicrophone!,
                    hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!,
                    withBufferSize bufferSize: UInt32,
                    withNumberOfChannels numberOfChannels: UInt32) {
        DispatchQueue.main.async(execute: {
//            self.audioPlot?.updateBuffer(buffer.pointee, withBufferSize: bufferSize)
            self.audioPlot?.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func microphone(_ microphone: EZMicrophone!,
                    hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>!,
                    withBufferSize bufferSize: UInt32,
                    withNumberOfChannels numberOfChannels: UInt32) {
        recorder?.appendData(from: bufferList, withBufferSize: bufferSize)
    }
}

// MARK: EZRecorderDelegate
extension voiceRecordingViewController: EZRecorderDelegate {
    
    func recorderDidClose(_ recorder: EZRecorder!) {
        print("recorder.delegate = nil")
        recorder.delegate = nil
    }
    
    func recorderUpdatedCurrentTime(_ recorder: EZRecorder!) {
        print(#function)
        let formattedCurrentTime = recorder.formattedCurrentTime
        print(String(describing: formattedCurrentTime))
        DispatchQueue.main.async(execute: {
            print(String(describing: formattedCurrentTime))
            self.timerLabel.text = formattedCurrentTime
        })
    }
    
}



