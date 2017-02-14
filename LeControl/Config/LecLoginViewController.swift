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
    func loginViewController(_ controller: LecLoginViewController, didLogInWithUserId userId: String)
}

class LecLoginViewController: UIViewController {
    
    weak var delegate: LecLoginViewControllerDelegate?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func login(_ sender: AnyObject) {
        if let userName = userNameTextField.text, let password = passwordTextField.text {
            let parameters = ["email": userName, "password": password]
            let loginUrl = environment.httpAddress + LecConstants.NetworkSubAddress.Login
            Alamofire.request(loginUrl, method: .get, parameters: parameters).responseJSON(completionHandler: { [weak weakSelf = self] (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    guard json["result"].boolValue else {
                        JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleError);
                        return
                    }
                    weakSelf?.delegate?.loginViewController(self, didLogInWithUserId: json["user_id"].stringValue)
                case .failure:
                    JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleError);
                }
            })
        }
    }
}
