//
//  voiceCheckViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/26.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit
import EZAudio
import GradientCircularProgress
import FilesProvider
import Toast_Swift
import FirebaseFirestore

class voiceCheckViewController: UIViewController,UINavigationBarDelegate,FileProviderDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var progressCircleView: UIView!
    @IBOutlet weak var audioTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bitLabel: UILabel!
    @IBOutlet weak var bitUnitLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateUnitLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelUnitLabel: UILabel!
    
    // An EZAudioFile that will be used to load the audio file at the file path specified
    var audioFile: EZAudioFile?
    
    // The audio player that will play the recorded file
    var player: EZAudioPlayer?
    
    var timer: Timer?
    var v: Double = 0.0
    
    let progress = GradientCircularProgress()
    var progressView: UIView?
    
    var webdav: WebDAVFileProvider?
    
    var audioFileframe:Float64?
    
    var isPlaying: Bool?
    
    var defaultStore : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.delegate = self
        navBar.barTintColor = vColor.titleBlueColor
        
        defaultStore = Firestore.firestore()
        
        let session = AVAudioSession.sharedInstance()
        
        // OKボタン
        okButton.setImage(FontAwesome.checkImage() , for: UIControl.State())
        // やり直しボタン
        redoButton.setTitle(NSLocalizedString("retake", comment: ""), for: .normal)
        redoButton.setImage(FontAwesome.redoImage(), for: UIControl.State())
        
        // プレイ・ポーズボタン
        playButton.setImage(FontAwesome.pauseImage2(), for: UIControl.State())
        isPlaying = true
        
        let idx = asbds.index(where: {$0.projectNo == SELECT_PROJECT_NO})
        
        var tempAsbd:asbd?
        if idx == nil {
            tempAsbd = asbd(projectNo:SELECT_PROJECT_NO)
        } else {
            tempAsbd = asbds[idx!]
        }
        
        bitLabel.text = String(describing: tempAsbd!.bitsPerChannel)
        bitUnitLabel.text = NSLocalizedString("bit", comment: "")
        
        rateLabel.text = String(tempAsbd!.sampleRate / 1000)
        
        channelLabel.text = String(describing:tempAsbd!.channelsPerFrame)
        channelUnitLabel.text = NSLocalizedString("channel", comment: "")
        
        // データアップロード前準備
        let credential = URLCredential(user: username, password: password, persistence: .permanent)
        webdav = WebDAVFileProvider(baseURL: server, credential: credential)!
        webdav?.delegate = self as FileProviderDelegate
        
        // Create the audio player
        player = EZAudioPlayer(delegate: self)
        player?.shouldLoop = false
        
        //
        // Override the output to the speaker
        //
        do {
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error as NSError {
            print("Error overriding output to the speaker: \(error.localizedDescription)")
        }
        
        // Listen for EZAudioPlayer notifications
        setupNotifications()
        
        // Try opening the audio file
        print(#function,String(describing: AudioFileName))
        openFileWithFilePathURL(filePathURL: AudioFileName!)
        
        player?.play()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ステータスバーとナビゲーションバーの色を同じにする
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    // ステータスバーの文字を白にする
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let progressRect : CGRect = CGRect(x: 0,y: 0,width: progressCircleView.frame.size.width,height: progressCircleView.frame.size.height)
        
        progressView = progress.showAtRatio(frame: progressRect,
                                            style: MyStyle())
        progressCircleView.addSubview(progressView!)
        
        v = 0.0
        startProgressBasic()
        
        titleLabel.text = ""
        for vList in voiceLists {
            let contents = vList.filter({$0.vID == SELECT_VOICE_NO && $0.projectID == SELECT_PROJECT_NO})
            if contents.count > 0 {
                for content in contents {
                    titleLabel.text = content.Title
                    break;
                }
            }
        }
        
    }
    
    // MARK: Notifications
    func setupNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidChangeAudioFile), name: .EZAudioPlayerDidChangeOutputDevice , object: player)
 
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidChangeOutputDevice), name: .EZAudioPlayerDidChangeOutputDevice, object: player)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidChangePlayState), name: .EZAudioPlayerDidChangeOutputDevice, object: player)
    }
    
    @objc func audioPlayerDidChangeAudioFile(notification: NSNotification) {

        let player = notification.object as! EZAudioPlayer
        print("Player changed audio file: \(player.audioFile)")
    }
    
    @objc func audioPlayerDidChangeOutputDevice(notification: NSNotification) {
        
        let player = notification.object as! EZAudioPlayer
        print("Player changed audio file: \(player.audioFile)")
    }
    
    @objc func audioPlayerDidChangePlayState(notification: NSNotification) {
        
        let player = notification.object as! EZAudioPlayer
        print("Player changed audio file: \(player.audioFile)")
    }
    
    // MARK: Actions
    func openFileWithFilePathURL(filePathURL: URL) {
        
        // Create the EZAudioPlayer
        audioFile = EZAudioFile(url: filePathURL)
        
        // Update the UI
        guard let audioFile = audioFile, let player = player else {
            return
        }

        audioTimeLabel.text = String(audioFile.formattedDuration)
        print(String(audioFile.duration))
        audioFileframe = 1 / (Float64(audioFile.duration) / 0.01)
        print("\(String(describing: audioFileframe))")
        // Play the audio file
        player.audioFile = audioFile
    }
    
    func startProgressBasic() {
        if v <= 0.0 {
            v = audioFileframe!
        }
//        v = audioFileframe!
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateMessage),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    @objc func updateMessage() {

        v += audioFileframe!
//        print("v:","\(v)")
        if v > 1.0 {
            progress.updateMessage(message: "Download\n4 / 4")
            timer!.invalidate()
            
            AsyncUtil().dispatchOnMainThread({
                self.progress.updateMessage(message: "Completed!")
            }, delay: 0.8)
            self.isPlaying = false
            // プレイ・ポーズボタン
            playButton.setImage(FontAwesome.playImage(), for: UIControl.State())
            v = 0.0
            return
        }
        
        progress.updateRatio(CGFloat(v))
    }
    
    @IBAction func okButtonTap(_ sender: Any) {
        // クルクルスタート
        mriProgress.start()
        
        // フォルダが存在するか確認
        webdav?.contentsOfDirectory(path: ownCloudSaveFolder + SELECT_PROJECT_NO + "/", completionHandler: {
            contents, error in
            if let error = error {
                print("フォルダがありません:\(error.localizedDescription)")
                // フォルダ作成
                self.webdav?.create(folder: SELECT_PROJECT_NO, at: ownCloudSaveFolder, completionHandler: { error in
                    if let error = error {
                        print("フォルダ作成に失敗しました:\(error.localizedDescription)")
                        self.dispatch_async_main{
                            // クルクルストップ
                            mriProgress.stop()
                            self.view.makeToast(NSLocalizedString("fileCopyError", comment: ""), duration: 3.0, position: .top)

                            self.button_Control(true)
                        }
                    } else {
                        print("success")
                        self.wavFileCopy()
                    }
                })
            } else {
                self.wavFileCopy()

            }
        })
        print("OK END")
    }
    
    @IBAction func playButtonTap(_ sender: Any) {
        
        self.playbtn()
    }
    
    func wavFileCopy() {
        var wavAudioURL:URL?
        
        let idx = asbds.index(where: {$0.projectNo == SELECT_PROJECT_NO})
        var tempAsbd:asbd?
        if idx == nil {
            tempAsbd = asbd(projectNo:SELECT_PROJECT_NO)
        } else {
            tempAsbd = asbds[idx!]
        }
        
        let u1 = AudioFileName!.deletingPathExtension()
        wavAudioURL = u1.appendingPathExtension(tempAsbd!.ext)

        if tempAsbd!.ext == "wav" {
            convertAudio(AudioFileName!, outputURL: wavAudioURL!)

        }
        let localURL = wavAudioURL!
        
        let localFileName = NSString(string:localURL.path).lastPathComponent
        let remotePath = ownCloudSaveFolder + SELECT_PROJECT_NO + "/" + (localFileName as String)
//        let remotePath = ownCloudSaveFolder + "123/" + (localFileName as String)
        
        webdav?.copyItem(localFile: localURL, to: remotePath, completionHandler: {error in
            if let error = error {
                print("ファイルコピー\(error.localizedDescription)")
                self.dispatch_async_main{
                    // クルクルストップ
                    mriProgress.stop()
                    
                    self.view.makeToast(NSLocalizedString("fileCopyError", comment: ""), duration: 3.0, position: .top)
                    //                self.ActivityIndicator.stopAnimating()
                    self.button_Control(true)
                }
            } else {
                print("copy success")
                
                // 収録フラグを立てる
                for (iSection,voiceList) in voiceLists.enumerated() {
                    let voiceListRow = voiceList.index(where: {$0.projectID == SELECT_PROJECT_NO && $0.vID == SELECT_VOICE_NO})
                    
                    if voiceListRow != nil {
                        voiceLists[iSection][voiceListRow!].isRecord = true
                    }
                }
                
                
                let iRow = voiceRecords.index(where: {$0.projectID == SELECT_PROJECT_NO && $0.vID == SELECT_VOICE_NO})
                if iRow == nil {
                    let addData = voiceIsRecord(projectID: SELECT_PROJECT_NO, vID: SELECT_VOICE_NO)
                    voiceRecords.append(addData)
                    
                    var saveVID:[Int]? = []
                    let vRecs = voiceRecords.filter({$0.projectID == SELECT_PROJECT_NO})
                    
                    if vRecs.count > 0 {
                        for vRec in vRecs {
                            saveVID!.append(vRec.vID)
                        }
                        // データを保存する。
                        
                        self.defaultStore.collection("users").document(uid).collection("projects").document(SELECT_PROJECT_NO).updateData([
                            "isRecords": saveVID!
                        ]){ err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }

                    }
                }
                
                self.dispatch_async_main {
                    // クルクルストップ
                    mriProgress.stop()
//                self.ActivityIndicator.stopAnimating()
                    self.button_Control(true)
                    self.performSegue(withIdentifier: "toVoiceListViewSegue",sender: nil)
                }
            }
        })
    }
    
    // MARK: - Navigation
    func fileproviderSucceed(_ fileProvider: FileProviderOperations, operation: FileOperationType) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("\(source) copied to \(dest).")
            
//            self.performSegue(withIdentifier: "toVoiceListViewSegue",sender: nil)
//            // クルクルストップ
//            ActivityIndicator.stopAnimating()
//            button_Control(true)
//            GradientCircularProgress().dismiss()
        case .remove(path: let path):
            print("\(path) has been deleted.")
        default:
            if let destination = operation.destination {
                print("\(operation.actionDescription) from \(operation.source) to \(destination) succeed.")
            } else {
                print("\(operation.actionDescription) on \(operation.source) succeed.")
            }
        }
    }
    
    func fileproviderFailed(_ fileProvider: FileProviderOperations, operation: FileOperationType, error: Error) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("copying \(source) to \(dest) has been failed.")
        case .remove:
            print("file can't be deleted.")
        default:
            if let destination = operation.destination {
                print("\(operation.actionDescription) from \(operation.source) to \(destination) failed.")
            } else {
                print("\(operation.actionDescription) on \(operation.source) failed.")
            }
        }
    }
    
    func fileproviderProgress(_ fileProvider: FileProviderOperations, operation: FileOperationType, progress: Float) {
        switch operation {
        case .copy(source: let source, destination: let dest) where dest.hasPrefix("file://"):
            print("Downloading \(source) to \((dest as NSString).lastPathComponent): \(progress * 100) completed.")
        case .copy(source: let source, destination: let dest) where source.hasPrefix("file://"):
            print("Uploading \((source as NSString).lastPathComponent) to \(dest): \(progress * 100) completed.")
        case .copy(source: let source, destination: let dest):
            print("Copy \(source) to \(dest): \(progress * 100) completed.")
        default:
            break
        }
        
        
    }
    
    func playbtn() {
        print(#function,isPlaying as Any)
        if isPlaying! {
            // プレイ・ポーズボタン
            playButton.setImage(FontAwesome.playImage(), for: UIControl.State())
            player?.pause()
            timer!.invalidate()
        } else {
            // プレイ・ポーズボタン
            playButton.setImage(FontAwesome.pauseImage2(), for: UIControl.State())
            player?.play()
            self.startProgressBasic()
        }
        isPlaying = !isPlaying!
    }
    
    @IBAction func redoButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "toVoiceRecordingViewSegue",sender: nil)
    }
    
    func button_Control(_ On_Off:Bool){
        
        // OKボタン
        okButton.isEnabled = On_Off
        // やり直しボタン
        redoButton.isEnabled = On_Off
        // プレイ・ポーズボタン
        playButton.isEnabled = On_Off
    }
    
    func dispatch_async_main(_ block: @escaping () -> ()) {
        DispatchQueue.main.async(execute: block)
    }
    
    func dispatch_async_global(_ block: @escaping () -> ()) {
        DispatchQueue.global().async (execute: block)
    }
}

// MARK: EZAudioPlayerDelegate
extension voiceCheckViewController: EZAudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: EZAudioPlayer!,
                     playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!,
                     withBufferSize bufferSize: UInt32,
                     withNumberOfChannels numberOfChannels: UInt32,
                     in audioFile: EZAudioFile!) {
    }
    
    func audioPlayer(_ audioPlayer: EZAudioPlayer!,
                     updatedPosition framePosition: Int64,
                     in audioFile: EZAudioFile!) {
        
        DispatchQueue.main.async(execute: {
            self.currentTimeLabel.text = audioPlayer.formattedCurrentTime
        })
    }
}


