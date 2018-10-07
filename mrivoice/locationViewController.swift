//
//  locationViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/08/30.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit

class locationViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate{

    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    var blocation : String = ""
    
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
        blocation = location
        
        // テーブルビューのデリゲートとデータソースになる
        self.tableViewMain.delegate = self
        self.tableViewMain.dataSource = self
        
        // trueで複数選択、falseで単一選択
        self.tableViewMain.allowsMultipleSelection = false
        // xibをテーブルビューのセルとして使う
        tableViewMain.register(UINib(nibName: "locationTableViewCell", bundle: nil), forCellReuseIdentifier: "locationListCell")
    }

    // MARK: - TableView
    
    // 行数を返す（UITableViewDataSource）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    // セルにデータを設定する（UITableViewDataSource）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = locations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationListCell") as! locationTableViewCell
        
        cell.locationLabel.text = cellData
        
        if location == cellData {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationListCell") as! locationTableViewCell
        return cell.bounds.height
    }
    
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let cellData = locations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationListCell") as! locationTableViewCell
        location = cellData
        
        // チェックマークを入れる
        cell.accessoryType = .checkmark
        self.tableViewMain.reloadData()
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationListCell") as! locationTableViewCell
        // チェックマークを外す
        cell.accessoryType = .none
        self.tableViewMain.reloadRows(at: [indexPath], with: .none)
        
    }
    
    // キャンセルボタンタップ
    @IBAction func cancelButtonTap(_ sender: Any) {
        // バックアップをもとに戻す
        location = blocation
        self.performSegue(withIdentifier: "toCounfigListSegue",sender: nil)
    }
    
    // 完了ボタンタップ
    @IBAction func doneButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "toCounfigListSegue",sender: nil)
        
    }
}
