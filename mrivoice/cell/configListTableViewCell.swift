//
//  configListTableViewCell.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/08/14.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit

class configListTableViewCell: UITableViewCell {

    @IBOutlet weak var configLabel: UILabel!
    @IBOutlet weak var configValue1: UILabel!
    @IBOutlet weak var configValue2: UILabel!
    @IBOutlet weak var configSwitch: UISwitch!
    @IBOutlet weak var genderSegument: UISegmentedControl!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
