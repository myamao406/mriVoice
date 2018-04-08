//
//  voiceListTableViewCell.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/03/20.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit

class voiceListTableViewCell: UITableViewCell {

    @IBOutlet weak var voiceTitleLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
