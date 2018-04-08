//
//  voiceRecordingViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/23.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit
import EZAudio

class voiceRecordingViewController: UIViewController,UINavigationBarDelegate {

    @IBOutlet weak var returnBarButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var textSizeButton: UIButton!
    @IBOutlet weak var voiceTextView: UITextView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var plotView: EZAudioPlotGL!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!

    
    // The microphone component
    var microphone: EZMicrophone?
    
    // The recorder component
    var recorder: EZRecorder?

    var voice_time = 0
    var startTime = Date()
    
    var contentOffset = CGPoint.zero //init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navBar.delegate = self
        navBar.barTintColor = vColor.titleBlueColor
        
        // 戻るボタン
        returnBarButton.image = FontAwesome.returnImage()
        // 終了ボタン
        stopButton.setImage(FontAwesome.pauseImage(), for: UIControlState())
        
        // 背景色
        stopButton.backgroundColor = vColor.bargainsYellowColor
        // 角丸
        stopButton.layer.cornerRadius = stopButton.frame.height / 2
        
        // テキストサイズ変更ボタン
        changeText.SizeColor(size: text_size_mode,btn:textSizeButton)
        voiceTextView.font = UIFont.systemFont(ofSize: voice_text_size[text_size_mode])
        
        setContents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function)
        // Create an instance of the microphone and tell it to use this view controller instance as the delegate
        microphone = EZMicrophone(microphoneDelegate: self)

        self.record()
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

    func setContents() {
        ageLabel.text = ""
        genderLabel.text = ""
        titleLabel.text = ""
        createdLabel.text = ""
        deadLineLabel.text = ""
        voiceTextView.text = ""
        
        let contents = voiceLists.filter({$0.vID == SELECT_VOICE_NO})
        if contents.count > 0 {
            for content in contents {
                ageLabel.text = listLabel.ageLabel[content.Age]
                genderLabel.text = listLabel.genderLabel[content.Gender]
                titleLabel.text = content.Title
                createdLabel.text = content.Created
                deadLineLabel.text = content.Deadline
                voiceTextView.text = content.contents
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
    
    @IBAction func stopButtonTap(_ sender: Any) {
        // 録音終了
        plotView?.backgroundColor = UIColor.clear
        microphone?.stopFetchingAudio()
        // Close the audio file
        if let recorder = recorder {
            recorder.closeAudioFile()
        }
        
        self.performSegue(withIdentifier: "toVoiceCheckViewSegue",sender: nil)
    }
    
    // 録音するファイルのパスを取得(録音時、再生時に参照)
    func documentFilePath()-> URL {
        let urls = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
        let dirURL = urls[0]
        
        let now = Date() // 現在日時の取得
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP") // ロケールの設定
        dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        
        let fileName = dateFormatter.string(from: now) + ".m4a"
//        let fileName = dateFormatter.string(from: now) + ".wav"
        AudioFileName = dirURL.appendingPathComponent(fileName)
        print(#function,dirURL.appendingPathComponent(fileName))
        return AudioFileName!
    }
    
    // 次の画面から戻ってくるときに必要なsegue情報
    @IBAction func unwindToVoiceRecording(_ segue: UIStoryboardSegue) {
    }
    
    func record(){
        
        // Create the recorder
        plotView.clear()
        guard let microphone = microphone else {
            return
        }
        
        plotView?.backgroundColor = UIColor.clear
        plotView?.color = UIColor.orange
        plotView?.plotType = .rolling
        plotView?.gain = 5.0
        plotView?.shouldFill = true
        plotView?.shouldMirror = true
        
        microphone.startFetchingAudio()
        recorder = EZRecorder(url: self.documentFilePath(),
                              clientFormat: (microphone.audioStreamBasicDescription()),
                              fileType: .M4A)

        self.updating()
    }

    
    @objc func updating()  {
        if voice_timer.isValid {
            voice_timer.invalidate()
        }
        
        voice_timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
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
        
        // %02d： ２桁表示、0で埋める
        let sHour = String(format:"%02d", hour)
        let sMinute = String(format:"%02d", minute)
        let sSecond = String(format:"%02d", second)
        
        timerLabel.text = sHour + ":" + sMinute + ":" + sSecond
        
    }

}
// MARK: EZMicrophoneDelegate
extension voiceRecordingViewController: EZMicrophoneDelegate {
    func microphone(_ microphone: EZMicrophone!,
                    hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!,
                    withBufferSize bufferSize: UInt32,
                    withNumberOfChannels numberOfChannels: UInt32) {
        DispatchQueue.main.async(execute: {
            self.plotView.updateBuffer(buffer.pointee, withBufferSize: bufferSize)
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



