//
//  voiceListHeaderTableViewCell.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/09/05.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit

class voiceListHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isRecordedDisp: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
