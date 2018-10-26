//
//  voiceListViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/20.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit
import FontAwesomeKit
import KYDrawerController
import FirebaseAuth
import FirebaseFirestore

class voiceListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate {
    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    // ボタンを用意
    var addBtn: UIBarButtonItem!
    
    var logoImageView: UIImageView!
    
    var defaultStore : Firestore!
    var refreshControl:UIRefreshControl!
    var pNos:[String]?
   
    let dispatchGroup = DispatchGroup()
    let dispatchGroup2 = DispatchGroup()
    // 直列キュー / attibutes指定なし
    let dispatchQueue = DispatchQueue(label: "queue")
    let dispatchQueue2 = DispatchQueue(label: "queue2")
    
    lazy var __once: Void = {
        self.getProjectInfo()
        self.initialAnimation()
    }()

    var foldings : [(accordion:Bool,disp:Bool)] = []
    
    var dispData = [[voiceList]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navBar.delegate = self
        navBar.barTintColor = vColor.titleBlueColor
        
        //タイトル
        self.navigationItem.title = mri.title
                
        let menu =  FAKIonIcons.naviconRoundIcon(withSize: iconFont.s24)
        let menuImage = menu?.image(with: CGSize(width:iconSize.w24,height:iconSize.h24))
        leftButton.image = menuImage
        
        defaultStore = Firestore.firestore()
        let settings = defaultStore.settings
        settings.areTimestampsInSnapshotsEnabled = true
        defaultStore.settings = settings
        
        //imageView作成
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        self.logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: myBoundSize.width, height: myBoundSize.height))
        //画面centerに
        self.logoImageView.center = self.view.center
        //logo設定
        self.logoImageView.image = UIImage(named: "iTunesArtwork")
        self.logoImageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.logoImageView.backgroundColor = UIColor.white

        //viewに追加
        self.view.addSubview(self.logoImageView)
        
        loadData()
      
        // テーブルビューのデリゲートとデータソースになる
        self.tableViewMain.delegate = self
        self.tableViewMain.dataSource = self
        
        // xibをテーブルビューのセルとして使う
        tableViewMain.register(UINib(nibName: "voiceListTableViewCell", bundle: nil), forCellReuseIdentifier: "voiceListCell")
        
        // xibをテーブルビューのセルとして使う
        tableViewMain.register(UINib(nibName: "voiceListHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "voiceListHeaderCell")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableViewMain.addSubview(refreshControl)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "toLoginViewSegue",sender: nil)
        } else {
            checkMicrophoneAuthorizationStatus()
            _ = __once
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableViewMain.indexPathForSelectedRow {
            tableViewMain.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
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
    
    func loadData(){
        
        if Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "toLoginViewSegue",sender: nil)
        } else {
            uid = (Auth.auth().currentUser?.uid)!
            // ログインユーザーの情報を取得
            defaultStore.collection("users").document(uid).getDocument{(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents1: \(err)")
                }else{
                    if let rgender = querySnapshot?.data()?["gender"] {
                        gender = rgender as! String
                        print("price : \(gender) => \(country)")
                    } else {
                        print("Error getting documents2:")
                    }
                    if let rcountry = querySnapshot?.data()?["country"] {
                        country = rcountry as! String
                        print("price : \(gender) => \(country)")
                    } else {
                        print("Error getting documents3:")
                    }
                }
            }
            
            // 年齢情報を取得
            defaultStore.collection("ageLabel")
                .order(by: "ageID")
                .getDocuments{(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents1: \(err)")
                }else{
                    listLabel.ageLabel = []
                    if let querySnapshot = querySnapshot?.documents {
                        for q in querySnapshot {
                            let tAge = (jp:q.data()["ageLabel"],en:q.data()["ageLabelEn"])
                            listLabel.ageLabel.append(tAge as! (jp: String, en: String))
                        }
                        print("ageLabel => \(listLabel.ageLabel)")
                    }
                    
                }
            }

            defaultStore.collection("genderLabel")
                .order(by: "genderID")
                .getDocuments{(querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents1: \(err)")
                    }else{
                        listLabel.genderLabel = []
                        print("genderLabel => \(listLabel.genderLabel)")
                        if let querySnapshot = querySnapshot?.documents {
                            for q in querySnapshot {
                                let tGender = (jp:q.data()["genderLabel"],en:q.data()["genderLabelEn"])
                                listLabel.genderLabel.append(tGender as! (jp: String, en: String))
                            }
                            print("genderLabel => \(listLabel.genderLabel)")

                        }
                    }
            }
            
//            voiceLists = [[voiceList]]()
            foldings = []
        }
    }

    @objc func refresh()
    {
//        voiceLists = [[voiceList]]()
        self.getProjectInfo()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - TableView
    
    // 行数を返す（UITableViewDataSource）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foldings[section].accordion ? 0 : dispData[section].count
//        return foldings[section].accordion ? 0 : voiceLists[section].count
    }
    
    // セルにデータを設定する（UITableViewDataSource）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cellData = voiceLists[indexPath.section][indexPath.row]
        let cellData = dispData[indexPath.section][indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceListCell") as! voiceListTableViewCell
        
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "voiceListCell") as! voiceListTableViewCell
//        }
        
//        if foldings[indexPath.section].disp == false {
//            if cellData.isRecord {
//                cell.isHidden = true
//            }
//        } else {
            cell.ageLabel.text = getLabel.age(ageID: cellData.Age)
            cell.genderLabel.text = getLabel.gender(genderID: cellData.Gender)
            cell.voiceTitleLabel.text = cellData.Title
            cell.createdLabel.text = cellData.Created
            cell.deadLineLabel.text = cellData.Deadline
            
            if cellData.isRecord {
                cell.backgroundColor = vColor.borderColor
            } else {
                cell.backgroundColor = UIColor.clear
            }

//        }
        
        return cell
    }
    
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return dispData.count
//        return voiceLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeader.height
    }
    
    // セクションのタイトル（UITableViewDataSource）
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        let title = voiceLists[section][0].projectID
//        return title
//    }
    
    // セクションのタイトル
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceListHeaderCell") as! voiceListHeaderTableViewCell
        
        cell.titleLabel.text = dispData[section][0].projectID
//        cell.titleLabel.text = voiceLists[section][0].projectID
        cell.switchLabel.text = NSLocalizedString("recordedDisp", comment: "")
        
        // セクションのビューに対応する番号を設定する。
        cell.contentView.tag = section
        // セクションのビューにタップジェスチャーを設定する。
        cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(gestureRecognizer:))))
        
        cell.isRecordedDisp.isOn = foldings[section].disp
        
        cell.isRecordedDisp.tag = section
        cell.isRecordedDisp.addTarget(self, action: #selector(self.tapSwitch(_:)), for: .valueChanged)
        
        return cell.contentView
/*
        let posX:CGFloat = 10.0
        let posY:CGFloat = tableViewHeader.height / 2
        
        // セクションのヘッダとなるビューを作成する。
        let sectionTitleView: UIView = UIView()
        let titleLabel:UILabel = UILabel()
        
        titleLabel.frame = CGRect(x: posX, y: 0, width: tableView.frame.width * 0.8 , height: 30)
        titleLabel.layer.cornerRadius = 5.0
        titleLabel.clipsToBounds = true
        titleLabel.textAlignment = .left
        titleLabel.backgroundColor = UIColor.brown
        titleLabel.layer.borderColor = UIColor.clear.cgColor
        titleLabel.layer.borderWidth = 0.0
        
        titleLabel.layer.position = CGPoint(x:(titleLabel.frame.width / 2) + posX , y: posY)
        titleLabel.textColor = UIColor.white
        
        titleLabel.text = voiceLists[section][0].projectID
        
        sectionTitleView.addSubview(titleLabel)
        sectionTitleView.backgroundColor = vColor.greenColor

        let recordedDispSwitch = UISwitch()
        sectionTitleView.addSubview(recordedDispSwitch)
        
        
        // セクションのビューに対応する番号を設定する。
        sectionTitleView.tag = section
        // セクションのビューにタップジェスチャーを設定する。
        sectionTitleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(gestureRecognizer:))))
        
        return sectionTitleView
 */
    }
    
    // セルの高さを返す（UITableViewDelegate）
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceListCell") as! voiceListTableViewCell
/*
        let cellData = dispData[indexPath.section][indexPath.row]
//        let cellData = voiceLists[indexPath.section][indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceListCell") as! voiceListTableViewCell
        var cellHeigth = cell.bounds.height
        
        if foldings[indexPath.section].disp == false {
            if cellData.isRecord {
                cellHeigth = 0
//                cell.backgroundColor = vColor.borderColor
            }
        }
        
        return cellHeigth
*/
        return cell.bounds.height
    }
    
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
//        SELECT_PROJECT_NO = voiceLists[indexPath.section][indexPath.row].projectID
//        SELECT_VOICE_NO = voiceLists[indexPath.section][indexPath.row].vID
        SELECT_PROJECT_NO = dispData[indexPath.section][indexPath.row].projectID
        SELECT_VOICE_NO = dispData[indexPath.section][indexPath.row].vID

        self.performSegue(withIdentifier: "toVoiceRecordingViewSegue",sender: nil)
    }
    
    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        // タップされたセクションを取得する。
        guard let section = gestureRecognizer.view?.tag as Int? else {
            return
        }
        
        // フラグを設定する。
        foldings[section].accordion = foldings[section].accordion ? false : true
        
        // タップされたセクションを再読込する。
        self.tableViewMain.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
    }
    
    @objc func tapSwitch(_ sender: UISwitch) {
        // タップされたセクションを取得する。
        guard let section = sender.tag as Int? else {
            return
        }
        
        // フラグを設定する。
        foldings[section].disp = sender.isOn
        
        makeDispData()
        
        self.tableViewMain.reloadData()
//        self.tableViewMain.reloadSections(NSIndexSet(index: section) as IndexSet, with: .none)
    }
    
    // MARK: - button tap event
    
    @IBAction func dwowerButtonTap(_ sender: Any) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        
        appDel.drawerController.setDrawerState(.opened, animated: true)
    }
    
    @IBAction func searchButtonTap(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    // MARK: - segue
    // 次の画面から戻ってくるときに必要なsegue情報
    @IBAction func unwindToVoiceList(_ segue: UIStoryboardSegue) {
        if segue.identifier == "toVoiceListViewSegue" {
            print("戻ってきたよ")
            makeDispData()
            self.tableViewMain.reloadData()
        }
        
        if segue.identifier == "unwindToVoiceListSegue" {
            print("戻ってきたよ2")
            self.loadData()
            self.getProjectInfo()
        }
        
    }
    
    func setListDatas(uid:String) {
        // クルクルスタート
        mriProgress.start()
       
        print(#function,"# -> \(uid)")
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            [weak self] in
            
            // ユーザーが担当しているプロジェクトを取得する
            self?.getProjectNo(uid: uid) {
                self?.dispatchGroup.leave()
                print("getProjectNo END")
                
                if let pNos = self?.pNos {
                    if pNos.count > 0 {
                        voiceLists = [[voiceList]]()
//                        self?.foldings = []
                        for (i,pNo) in pNos.enumerated() {
                            //                                print(#function,"#\(i) -> \(pNo)")
                            
                            self?.dispatchGroup2.enter()
                            self?.dispatchQueue2.async(group: self?.dispatchGroup) {
                                [weak self] in
                                self?.getContents(projectNo: pNo,sectionNo: i){
                                    self?.dispatchGroup2.leave()
                                    print("getContents END \(i)")
                                }
                            }
                        }
                        
                        // 全ての非同期処理完了後にメインスレッドで処理
                        self?.dispatchGroup2.notify(queue: .main) {
                            print("All Process Done! 2")
                            
                            self?.makeDispData()
                            // くるくるストップ
                            mriProgress.stop()
                            self?.tableViewMain.reloadData()
                        }
                    } else {
                        // プロジェクトが存在しない。
                        voiceLists = voiceLists2
                        self?.dispData = voiceLists2
                        self?.foldings = []
                        self?.foldings.append((accordion:false,disp:true))
                        // くるくるストップ
                        mriProgress.stop()
                        self?.tableViewMain.reloadData()
                    }
                } else {
                    // プロジェクトが存在しない。
                    voiceLists = voiceLists2
                    self?.dispData = voiceLists2
                    self?.foldings = []
                    self?.foldings.append((accordion:false,disp:true))
                    // くるくるストップ
                    mriProgress.stop()
                    self?.tableViewMain.reloadData()
                }
            }
        }
        
        // 全ての非同期処理完了後にメインスレッドで処理
        dispatchGroup.notify(queue: .main) {
            print("All Process Done! 1")
        }

    }
    
    func getProjectNo(uid : String,block: @escaping () -> ()) {
        print(#function,  ": Start")
       
        pNos = []
        // ログインユーザーに割り当てられたプロジェクトがあるか？
        self.defaultStore.collection("users").document(uid).collection("projects")
            .whereField("isDisabled", isEqualTo: false)
            .getDocuments(){(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents4: \(err)")
                    block()
                    return;
                }
                
                let wSnapshot = querySnapshot!.documents

                if wSnapshot.count <= 0 {
                    block()
                    return;
                }

                voiceRecords = []
                for document in wSnapshot {
                    let pjno = document.documentID
                    
                    print(#function, "price : \(document.documentID) => \(document.data())")
                    
                    let idx = projectLists.index(where: {$0 == pjno})
                    
                    if idx == nil {
                        print(#function,"\(pjno) is Disabled!!")
                        continue;
                    }
                    
                    self.pNos?.append(pjno)
                    
                    if let rec_vIDs:[Int] = document["isRecords"] as? [Int] {
                        if rec_vIDs.count > 0 {
                            for rec_vID in rec_vIDs {
                                if voiceRecords.isEmpty {
                                    voiceRecords.append(voiceIsRecord(
                                        projectID: pjno,
                                        vID: rec_vID)
                                    )
                                } else {
                                    let iRow = voiceRecords.index(where: {$0.projectID == pjno && $0.vID == rec_vID})
                                    if iRow == nil {
                                        voiceRecords.append(voiceIsRecord(
                                            projectID: pjno,
                                            vID: rec_vID)
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
                print(#function,"loop end!!")
                block()
        }
    }
    
    func getProjectIsDisabled(block: @escaping () -> ()) {
        print(#function,  ": Start")
//        projectLists = []
        defaultStore.collection("projects")
            .whereField("isDisabled", isEqualTo: false)
            .getDocuments(){(querySnapshot,err) in
            if let err = err {
                print(#function,"Error getting documents: \(err.localizedDescription)")
                block()
                return;
            } else {
                if (querySnapshot!.documents.count) > 0 {
                    
                    asbds = []
                    projectLists = []
                    
                    for document in querySnapshot!.documents {
                        projectLists.append(document.documentID)
                        let asbdData = asbd(projectNo: document.documentID)
                        
                        if document.data()["ext"] != nil {
                            asbdData.ext = document.data()["ext"] as! String
                        }
                        if document.data()["sampleRate"] != nil {
                            asbdData.sampleRate = document.data()["sampleRate"] as! Float64
                        }
                        if document.data()["channelsPerFrame"] != nil {
                            asbdData.channelsPerFrame = document.data()["channelsPerFrame"] as! UInt32
                        }
                        if document.data()["bitsPerChannel"] != nil {
                            asbdData.bitsPerChannel = document.data()["bitsPerChannel"] as! UInt32
                        }
                        if document.data()["framesPerPacket"] != nil {
                            asbdData.framesPerPacket = document.data()["framesPerPacket"] as! UInt32
                        }

                        asbds.append(asbdData)
                    }
                    block()
                    return;
                } else {
                    block()
                    return;
                }
            }
        }
    }
    
    
    func getContents(projectNo:String,sectionNo:Int,block: @escaping () -> ()) {
        print(#function," # Start \(sectionNo) -> \(projectNo)")
//        var sNo = sectionNo
        voiceLists.append([voiceList]())
        self.foldings.append((accordion:false,disp:true))
        
        defaultStore.collection("projects").document(projectNo).collection("readingDatas")
            .order(by: "vID")
            .getDocuments(){(querySnapshot, err) in
                if let err = err {
//                    voiceLists = voiceLists2
                    print("Error getting documents6: \(err)")
                    block()
                    return;
                }
                
                print(#function," # documents.count -> \(querySnapshot!.documents.count)")
                if (querySnapshot!.documents.count) > 0 {
                    //                        print(#function," # voiceLists.count -> \(voiceLists.count)")
//                    self.foldings.append(false)
//                    voiceLists.append([voiceList]())
//                    print("append 1: \(voiceLists.count),\(sNo)")
//                    if voiceLists.count - 1 < sNo {
//                        voiceLists.append([voiceList]())
//                        print("append 2: \(voiceLists.count)")
//                        sNo = voiceLists.count - 1
//                    }
                    for document in querySnapshot!.documents {
                        
                        //                            print(#function," : \(document.documentID) => \(document.data())")
                        let voiceData = document.data()
                        let timestamp :Timestamp = voiceData["created"] as! Timestamp
                        let date: Date = timestamp.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ja_JP") // ロケールの設定
                        dateFormatter.timeStyle = .medium
                        dateFormatter.dateStyle = .medium
                        let isRec = voiceRecords.index(where: {$0.projectID == projectNo && $0.vID == document["vID"] as! Int}) == nil ? false : true
                        voiceLists[sectionNo].append(voiceList(
                            projectID: projectNo,
                            vID: voiceData["vID"] as! Int,
                            Title: voiceData["title"] as! String,
                            Age: voiceData["age"] as! Int,
                            Gender: voiceData["gender"] as! Int,
                            Deadline: voiceData["deadline"] as! String,
                            Rank: voiceData["rank"] as! Int,
                            Created: dateFormatter.string(from: date) ,
                            contents: voiceData["contents"] as! String,
                            isRecord: isRec)
                        )
                    }
                    block()
                    return;
                } else {
                    voiceLists = voiceLists2
                    self.dispData = voiceLists2
                    self.foldings = []
                    self.foldings.append((accordion:false,disp:true))
                    block()
                    return;
                }

        }
    }
    
    func getProjectInfo() {
        uid = (Auth.auth().currentUser?.uid)!
        
        self.dispatchGroup.enter()
        self.dispatchQueue.async(group: self.dispatchGroup) {
            [weak self] in
            // プロジェクトが使用可能かどうか取得する。
            self?.getProjectIsDisabled(){
                self?.dispatchGroup.leave()
                print("getProjectIsDisabled END ")
            }
            
        }
        
        // 全ての非同期処理完了後にメインスレッドで処理
        dispatchGroup.notify(queue: .main) {
            print("All Process Done! 0")
            print(projectLists)
            self.setListDatas(uid: uid)
        }

    }

    func initialAnimation() {
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (Bool) in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        self.logoImageView.alpha = 0
        }, completion: { (Bool) in
            self.logoImageView.removeFromSuperview()
            self.view.backgroundColor = UIColor.white
        })
    }
    
    func makeDispData() {
        self.dispData = [[voiceList]]()
        for (i,voiceData) in voiceLists.enumerated() {
            if self.foldings[i].disp == false {
                let isDisps = voiceData.filter({!($0.isRecord)})
                self.dispData.append(isDisps)
            } else {
                self.dispData.append(voiceData)
            }
        }
    }
    
}
