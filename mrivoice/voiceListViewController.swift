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

class voiceListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate {
    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    // ボタンを用意
    var addBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.delegate = self
        navBar.barTintColor = vColor.titleBlueColor
        
        //タイトル
        self.navigationItem.title = mri.title
        
        let menu =  FAKIonIcons.naviconRoundIcon(withSize: iconFont.s24)
        let menuImage = menu?.image(with: CGSize(width:iconSize.w24,height:iconSize.h24))
        leftButton.image = menuImage
        
        loadData()
        
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
        // テーブルビューのデリゲートとデータソースになる
        self.tableViewMain.delegate = self
        self.tableViewMain.dataSource = self
        
        // xibをテーブルビューのセルとして使う
        tableViewMain.register(UINib(nibName: "voiceListTableViewCell", bundle: nil), forCellReuseIdentifier: "voiceListCell")

    }

    // MARK: - TableView
    
    // 行数を返す（UITableViewDataSource）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voiceLists.count
    }
    
    // セルにデータを設定する（UITableViewDataSource）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = voiceLists[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceListCell") as! voiceListTableViewCell
        
        cell.ageLabel.text = listLabel.ageLabel[cellData.Age]
        cell.genderLabel.text = listLabel.genderLabel[cellData.Gender]
        cell.voiceTitleLabel.text = cellData.Title
        cell.createdLabel.text = cellData.Created
        cell.deadLineLabel.text = cellData.Deadline
        
        return cell
    }
    
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの高さを返す（UITableViewDelegate）
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceListCell") as! voiceListTableViewCell
        return cell.bounds.height
    }
    
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        SELECT_VOICE_NO = voiceLists[indexPath.row].vID
        self.performSegue(withIdentifier: "toVoiceRecPrepatationViewSegue",sender: nil)
    }
    // MARK: - button tap event
    
    @IBAction func dwowerButtonTap(_ sender: Any) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        
        appDel.drawerController.setDrawerState(.opened, animated: true)
    }
    
    // MARK: - segue
    // 次の画面から戻ってくるときに必要なsegue情報
    @IBAction func unwindToVoiceList(_ segue: UIStoryboardSegue) {
        
    }
}
