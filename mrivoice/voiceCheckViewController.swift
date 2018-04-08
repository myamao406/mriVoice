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
//import Alamofire
import FilesProvider

class voiceCheckViewController: UIViewController,UINavigationBarDelegate,FileProviderDelegate {

    @IBOutlet weak var returnBarButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var progressCircleView: UIView!
    @IBOutlet weak var audioTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.delegate = self
        navBar.barTintColor = vColor.titleBlueColor
        
        // 戻るボタン
        returnBarButton.image = FontAwesome.returnImage()
        // OKボタン
        okButton.setImage(FontAwesome.checkImage() , for: UIControlState())
        // やり直しボタン
//        var setImage = FontAwesome.redoImage().flipHorizontal()
//        setImage = imageRotatedByDegrees(oldImage: setImage,deg: 30)
        redoButton.setImage(FontAwesome.redoImage(), for: UIControlState())
        
        // プレイ・ポーズボタン
        playButton.setImage(FontAwesome.pauseImage2(), for: UIControlState())
        isPlaying = true
        
        // データアップロード前準備
        let credential = URLCredential(user: username, password: password, persistence: .permanent)
        webdav = WebDAVFileProvider(baseURL: server, credential: credential)!
        webdav?.delegate = self as FileProviderDelegate
        
        // Create the audio player
        player = EZAudioPlayer(delegate: self)
        player?.shouldLoop = false
        
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
        
        startProgressBasic()
        
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
        v = audioFileframe!
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(updateMessage),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
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
            playButton.setImage(FontAwesome.playImage(), for: UIControlState())
            return
        }
        
        progress.updateRatio(CGFloat(v))
    }
    
    @IBAction func okButtonTap(_ sender: Any) {
        var wavAudioURL:URL?
        
        let u1 = AudioFileName!.deletingPathExtension()
        wavAudioURL = u1.appendingPathExtension("wav")

        convertAudio(AudioFileName!, outputURL: wavAudioURL!)
        let localURL = wavAudioURL!

//        let localURL = AudioFileName!
        let localFileName = NSString(string:localURL.path).lastPathComponent
        let remotePath = "/Documents/" + (localFileName as String)
        
        _ = webdav?.copyItem(localFile: localURL, to: remotePath, completionHandler: nil)
        
        print("OK END")
    }
    
    @IBAction func playButtonTap(_ sender: Any) {
        
        self.playbtn()
    }
    
    
    // MARK: - Navigation
    func fileproviderSucceed(_ fileProvider: FileProviderOperations, operation: FileOperationType) {
        switch operation {
        case .copy(source: let source, destination: let dest):
            print("\(source) copied to \(dest).")
            self.performSegue(withIdentifier: "toVoiceListViewSegue",sender: nil)
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
            playButton.setImage(FontAwesome.playImage(), for: UIControlState())
            player?.pause()
            timer!.invalidate()
        } else {
            // プレイ・ポーズボタン
            playButton.setImage(FontAwesome.pauseImage2(), for: UIControlState())
            player?.play()
            self.startProgressBasic()
        }
        isPlaying = !isPlaying!
    }
    
    @IBAction func redoButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "toVoiceRecPreparationViewSegue",sender: nil)
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


