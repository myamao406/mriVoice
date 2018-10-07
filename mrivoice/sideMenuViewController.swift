//
//  sideMenuViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/20.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit
import FontAwesomeKit
import FirebaseAuth

class sideMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableViewSide: UITableView!
    @IBOutlet weak var mailAdressLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var subMenuUserView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subMenuUserView.backgroundColor = vColor.titleBlueColor
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userImageView.image = FontAwesome.userImage()
        userImageView.backgroundColor = vColor.darkGrayColor
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.layer.frame.height / 2
        
        if Auth.auth().currentUser == nil {
            mailAdressLabel.text = ""
        } else {
            mailAdressLabel.text = Auth.auth().currentUser!.email
        }
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
        self.tableViewSide.delegate = self
        self.tableViewSide.dataSource = self
        
        // xibをテーブルビューのセルとして使う
        tableViewSide.register(UINib(nibName: "sideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "sideMenuCell")
        
    }
    
    // 行数を返す（UITableViewDataSource）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenus.count
    }
    
    // セルにデータを設定する（UITableViewDataSource）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = sideMenus[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell") as! sideMenuTableViewCell
        
        cell.sideMenuListTitleLabel.text = cellData.menuTitle
        cell.sideMenuListTitleLabel.textColor = vColor.grayColor
        cell.sideMenuListEtcLabel.text = cellData.menuEtc
        
        switch cellData.iconName {
        case "logout":
            cell.sideMenuListImage.image = FontAwesome.logoutImage()
            cell.sideMenuListTitleLabel.textColor = vColor.recButtonRed

            break
        case "config":
            cell.sideMenuListImage.image = FontAwesome.cogImage()
            
            break
        default:
            // セルの選択不可にする
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.sideMenuListImage.image = FontAwesome.phoneImage()
            break
        }
        // セルが選択された時の背景色を消す
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの高さを返す（UITableViewDelegate）
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell") as! sideMenuTableViewCell
        return cell.bounds.height
    }
    
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let cellData = sideMenus[indexPath.row]
        
        switch cellData.iconName {
        case "logout":
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                voiceLists = []
                let appDel = UIApplication.shared.delegate as! AppDelegate
                appDel.drawerController.setDrawerState(.closed, animated: true)
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            break
        case "config":
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.drawerController.setDrawerState(.closed, animated: true)
            self.performSegue(withIdentifier: "toConfigViewSegue",sender: nil)
            break
        default:
            break
        }
        
    }
}
