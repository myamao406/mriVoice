//
//  configViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/08/14.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit

class configViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationBarDelegate{

    @IBOutlet weak var tableViewMain: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
   
    var bgender : String = ""
    var bcountry : String = ""
    var blocation : String = ""
    var bisCountDown : Bool = true
    
    var dataList:[String] = []
    
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
        // backup
        bgender = gender
        bcountry = country
        blocation = location
        bisCountDown = isCountDown
        
        if country == "jp" {
            for (i,countryData) in countrys.enumerated() {
                print(i,countryData)
                dataList.append(countryData.jp)
            }
        } else {
            for (i,countryData) in countrys.enumerated() {
                print(i,countryData)
                dataList.append(countryData.en)
            }
        }
        
        // テーブルビューのデリゲートとデータソースになる
        self.tableViewMain.delegate = self
        self.tableViewMain.dataSource = self
        
        // xibをテーブルビューのセルとして使う
        tableViewMain.register(UINib(nibName: "configListTableViewCell", bundle: nil), forCellReuseIdentifier: "configListCell")
        
    }
    
    // MARK: - TableView
    
    // 行数を返す（UITableViewDataSource）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configMenus.count
    }
    
    // セルにデータを設定する（UITableViewDataSource）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = configMenus[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "configListCell") as! configListTableViewCell
        
        cell.configLabel.text = cellData.menuTitle
        // セルの選択可能にする
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        cell.configValue1.isHidden = true
        cell.configValue2.isHidden = true
        cell.configSwitch.isHidden = true
        cell.genderSegument.isHidden = true
        cell.locationLabel.isHidden = true

        switch cellData.cellName {
        case "country":
            print(country)
            cell.configValue1.isHidden = false
            cell.configValue2.isHidden = false
            
            let countryIDX = countrys.index(where:{($0.country == country)})
            if countryIDX == nil {
                cell.configValue1.text = "日本"
                cell.configValue2.text = "Japan"
            } else {
                if country == "jp" {
                    cell.configValue1.text = countrys[countryIDX!].jp
                    cell.configValue2.text = countrys[countryIDX!].en
                    
                } else {
                    cell.configValue1.text = countrys[countryIDX!].en
                    cell.configValue2.text = countrys[countryIDX!].jp
                }
            }
            // セルが選択された時の背景色を消す
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            break
        case "gender":
            print(gender)
            // セルの選択不可にする
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.genderSegument.isHidden = false
            cell.genderSegument.setTitle(NSLocalizedString("male", comment: ""), forSegmentAt: 0)
            cell.genderSegument.setTitle(NSLocalizedString("female", comment: ""), forSegmentAt: 1)
            cell.genderSegument.selectedSegmentIndex = gender == "m" ? 0 : 1

            cell.genderSegument.addTarget(self, action: #selector(self.tapSegmented), for: .valueChanged)
            break
        case "countdown":
            print(isCountDown)
            // セルの選択不可にする
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.configSwitch.isHidden = false

            cell.configSwitch.isOn = isCountDown

            cell.configSwitch.addTarget(self, action: #selector(self.tapSwich), for: .valueChanged)
            break
        case "location":
            print(isCountDown)
            // セルの選択不可にする
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.locationLabel.isHidden = false
            let locationIDX = locations.index(where:{($0 == location)})
            if locationIDX != nil {
                cell.locationLabel.text = locations[locationIDX!]
            } else {
                cell.locationLabel.text = location
            }
            // セルが選択された時の背景色を消す
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            break
        default:
            break
        }
        
        return cell
    }
    
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの高さを返す（UITableViewDelegate）
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "configListCell") as! configListTableViewCell
        return cell.bounds.height
    }
    
    // Cell が選択された場合
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let cellData = configMenus[indexPath.row]
        switch cellData.cellName {
        case "country":
            self.performSegue(withIdentifier: "toCountryViewSegue",sender: nil)
            break
        case "gender":
            
            break
        case "countdown":
            break
            
        case "location":
            self.performSegue(withIdentifier: "toLocationViewSegue",sender: nil)
            break
        default:
            break
        }
    }
    
    @objc func tapSwich(_ sender: UISwitch) {
        isCountDown = sender.isOn
    }
    
    @objc func tapSegmented(_ sender: UISegmentedControl){
        gender = genderList[sender.selectedSegmentIndex]
    }
    
    // キャンセルボタンタップ
    @IBAction func cancelButtonTap(_ sender: Any) {
        // バックアップをもとに戻す
        gender = bgender
        country = bcountry
        isCountDown = bisCountDown
        self.performSegue(withIdentifier: "toVoiceListSegue",sender: nil)
    }
    
    // 完了ボタンタップ
    @IBAction func doneButtonTap(_ sender: Any) {
        self.performSegue(withIdentifier: "toVoiceListSegue",sender: nil)
        
    }
    // 次の画面から戻ってくるときに必要なsegue情報
    @IBAction func unwindToConfig(_ segue: UIStoryboardSegue) {
        self.tableViewMain.reloadData()
    }
}
