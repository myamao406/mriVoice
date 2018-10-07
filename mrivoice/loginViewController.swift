//
//  loginViewController.swift
//  mrivoice
//
//  Created by it_dev01(yamao) on 2018/04/17.
//  Copyright © 2018年 it_dev01(yamao). All rights reserved.
//

import UIKit
import SwiftCop
import Firebase
import FirebaseAuth
import GradientCircularProgress
import FontAwesomeKit

class loginViewController: UIViewController {

    @IBOutlet weak var loginIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    let swiftCop: SwiftCop = SwiftCop()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.setImage(FontAwesome.signInImage(), for: .normal)
        signInButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        loginIDTextField.placeholder = NSLocalizedString("mail", comment: "")
        passwordTextField.placeholder = NSLocalizedString("password", comment: "")
        
        // パスワード入力を見えなくする。
        passwordTextField.isSecureTextEntry = true
        
        swiftCop.addSuspect(Suspect(view: self.loginIDTextField, sentence: "EmptyEMail", trial: Trial.email))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTap(_ sender: Any) {
        if let guilty = swiftCop.isGuilty(loginIDTextField) {
            print(guilty.verdict())
                    AlertUtility.showErrorAlert(
                        title: NSLocalizedString("error", comment: ""),
                        message: NSLocalizedString("err_msg", comment: ""),
                        okButtonTitle: "OK",
                        viewController: self)
            
        } else {
            // 表示開始
            GradientCircularProgress().show(message: NSLocalizedString("logging", comment: ""), style: BlueIndicatorStyle())
            let email = loginIDTextField.text
            let pass = passwordTextField.text
            print(loginIDTextField.text ?? "test")
            Auth.auth().signIn(withEmail: email!, password: pass! ) { user, error in
                if error == nil && user != nil {
                    self.dismiss(animated: false, completion: nil)
                    voiceLists = []
                    self.performSegue(withIdentifier: "unwindToVoiceListSegue",sender: nil)
                    GradientCircularProgress().dismiss()
                } else {
                    print("Eoor login in: \(String(describing: error?.localizedDescription))")
                    GradientCircularProgress().dismiss()
                    AlertUtility.showErrorAlert(
                        title: NSLocalizedString("error", comment: ""),
                        message: NSLocalizedString("err_msg", comment: ""),
                        okButtonTitle: "OK",
                        viewController: self)
                }
            }
        }
    }
    
    
}
