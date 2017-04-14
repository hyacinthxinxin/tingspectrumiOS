//
//  LoginViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import JDStatusBarNotification

protocol LecLoginViewControllerDelegate: class {
    func loginViewController(_ controller: LecLoginViewController, didLogInWithUserId userId: Int)
}

class LecLoginViewController: UIViewController {
    
    weak var delegate: LecLoginViewControllerDelegate?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            infoLabel.text = "版本号：" + version + "(" + build + ")"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults:UserDefaults = UserDefaults.standard
        if let userEmail = defaults.string(forKey: "UserEmail") {
            userNameTextField.text = userEmail
            passwordTextField.becomeFirstResponder()
        } else {
            userNameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if userNameTextField.isFirstResponder {
            userNameTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func login(_ sender: AnyObject) {
        if let userName = userNameTextField.text, let password = passwordTextField.text {
            let parameters = ["email": userName, "password": password]
            let loginUrl = environment.httpAddress + LecConstants.NetworkSubAddress.Login
            Alamofire.request(loginUrl, method: .post, parameters: parameters).responseJSON(completionHandler: { [weak weakSelf = self] (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)

                    guard (json["data"].dictionaryObject != nil) else {
                        JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleError);
                        return
                    }
                    let defaults:UserDefaults = UserDefaults.standard
                    defaults.set(userName, forKey:"UserEmail")
                    defaults.synchronize()
                    weakSelf?.delegate?.loginViewController(self, didLogInWithUserId: json["data", "id"].intValue)
                case .failure:
                    JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleError);
                }
            })
        }
    }
    
}

extension LecLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            login(passwordTextField);
        }
        return true
    }
    
}
