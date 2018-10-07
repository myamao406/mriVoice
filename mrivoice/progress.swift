//
//  progress.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/08/23.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import Foundation
import KRProgressHUD

open class mriProgress {
    open class func start(){
        KRProgressHUD.show()
    }
    
    open class func stop() {
//        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            KRProgressHUD.dismiss()
//        }
    }
}
