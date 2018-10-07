//
//  countryViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/08/15.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit

class countryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate {
    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    var bcountry : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate = self
        
        navBar.barTintColor = vColor.titleBlueColor
        leftButton.title = NSLocalizedString("cancel", comment: "")
        rightButton.title = NSLocalizedString("done", comment: "")
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        bcountry = country
        
        // テーブルビューのデリゲートとデータソースになる
        self.tableViewMain.delegate = self
        self.tableViewMain.dataSource = self
        
        // trueで複数選択、falseで単一選択
        self.tableViewMain.allowsMultipleSelection = false
        // xibをテーブルビューのセルとして使う
        tableViewMain.register(UINib(nibName: "countryTableViewCell", bundle: nil), forCellReuseIdentifier: "countryListCell")
    }
    
    // MARK: - TableView
    
    // 行数を返す（UITableViewDataSource）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countrys.count
    }
    
    // セルにデータを設定する（UITableViewDataSource）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = countrys[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListCell") as! countryTableViewCell

        if bcountry == "jp" {
            cell.configValue1.text = cellData.jp
            cell.configValue2.text = cellData.en
        } else {
            cell.configValue1.text = cellData.en
            cell.configValue2.text = cellData.jp
        }
        
        if country == cellData.country {
            // チェックマークを入れる
            cell.accessoryType = .checkmark
        } else {
            // チェックマークをはずす
            cell.accessoryType = .none
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListCell") as! countryTableViewCell
        return cell.bounds.height
    }
    
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let cellData = countrys[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListCell") as! countryTableViewCell
        country = cellData.country
        
        // チェックマークを入れる
        cell.accessoryType = .checkmark
        self.tableViewMain.reloadData()
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListCell") as! countryTableViewCell
        // チェックマークを外す
        cell.accessoryType = .none
        self.tableViewMain.reloadRows(at: [indexPath], with: .none)

    }
    
    // キャンセルボタンタップ
    @IBAction func cancelButtonTap(_ sender: Any) {
        // バックアップをもとに戻す
        country = bcountry
        self.performSegue(withIdentifier: "toCounfigListSegue",sender: nil)
    }
    
    // 完了ボタンタップ
    @IBAction func doneButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "toCounfigListSegue",sender: nil)
        
    }
}
