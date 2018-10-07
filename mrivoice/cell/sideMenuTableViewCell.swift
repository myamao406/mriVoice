//
//  sideMenuTableViewCell.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/04/19.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit

class sideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var sideMenuListImage: UIImageView!
    @IBOutlet weak var sideMenuListTitleLabel: UILabel!
    @IBOutlet weak var sideMenuListEtcLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
