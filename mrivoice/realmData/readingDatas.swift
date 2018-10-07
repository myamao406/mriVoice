//
//  readingDatas.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/07/12.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation
import RealmSwift

class ageLabel: Object {
    @objc dynamic var Age: Int = 0
    @objc dynamic var ageLabel: String = ""
}

class genderLabel: Object {
    @objc dynamic var Gender: Int = 0
    @objc dynamic var genderLabel: String = ""
}

class readingDatas: Object {
    @objc dynamic var projectNo: String = ""
    @objc dynamic var vID: Int = 0
    @objc dynamic var Title: String = ""
    @objc dynamic var Age: Int = 0
//    let AgeLabel: ageLabel
    @objc dynamic var Gender: Int = 0
//    let GenderLabel: genderLabel
    @objc dynamic var Deadline: String = ""
    @objc dynamic var Rank: Int = 0
    @objc dynamic var contents: String = ""
    @objc dynamic var Created: Double = Date().timeIntervalSince1970
    @objc dynamic var pdated: Double = Date().timeIntervalSince1970
}
