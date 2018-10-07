//
//  getLabel.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/09/03.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation

open class getLabel {
    open class func age(ageID : Int) -> String {
        var ageString = ""
        if country == "jp" {
            ageString = listLabel.ageLabel[ageID].jp
        } else {
            ageString = listLabel.ageLabel[ageID].en
        }
        
        return ageString
    }
    
    open class func gender(genderID : Int) -> String {
        var genderString = ""
        if country == "jp" {
            genderString = listLabel.genderLabel[genderID].jp
        } else {
            genderString = listLabel.genderLabel[genderID].en
        }
        
        return genderString
    }
}
