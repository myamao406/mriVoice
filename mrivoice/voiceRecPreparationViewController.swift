//
//  voiceRecPreparationViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/22.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit
import AVFoundation

class voiceRecPreparationViewController: UIViewController,UINavigationBarDelegate {
    
    @IBOutlet weak var returnBarButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var textSizeButton: UIButton!
    @IBOutlet weak var voiceTextView: UITextView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    
    var contentOffset = CGPoint.zero //init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.delegate = self
        navBar.barTintColor = vColor.titleBlueColor
        
        // 戻るボタン
        returnBarButton.image = FontAwesome.returnImage()
        
        // マイクボタン
        micButton.setImage(FontAwesome.micImage(), for: UIControlState())
        
        // 背景色
        micButton.backgroundColor = vColor.bargainsYellowColor
        // 角丸
        micButton.layer.cornerRadius = micButton.frame.height / 2
        
        // テキストサイズ変更ボタン
        changeText.SizeColor(size: tSize.smallText,btn:textSizeButton)
        voiceTextView.font = UIFont.systemFont(ofSize: voice_text_size[text_size_mode])
        
        setContents()
        
        checkMicrophoneAuthorizationStatus()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ステータスバーとナビゲーションバーの色を同じにする
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    // ステータスバーの文字を白にする
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
    
    // テキスト変更ボタンタップ
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
        self.performSegue(withIdentifier: "toVoiceRecordingViewSegue",sender: nil)
    }
    
    
//    @IBAction func returnView(_ sender: Any) {
//    }
    
    // 次の画面から戻ってくるときに必要なsegue情報
    @IBAction func unwindToVoiceRecPreparation(_ segue: UIStoryboardSegue) {
        // テキストサイズ変更ボタン
        changeText.SizeColor(size: text_size_mode,btn:textSizeButton)
        voiceTextView.font = UIFont.systemFont(ofSize: voice_text_size[text_size_mode])
    }
    
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
}
