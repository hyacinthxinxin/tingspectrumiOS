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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = LecCookies.sharedCookies.user.email
    }
    
    
    @IBAction func userNameDidChange(_ sender: UITextField) {
        if let text = sender.text {
            LecCookies.sharedCookies.user.email = text
        }
    }
    
    @IBAction func passwordDidChange(_ sender: UITextField) {
        if let text = sender.text {
            LecCookies.sharedCookies.user.password = text
        }
    }
    
    @IBAction func login(_ sender: AnyObject) {
        signUp()
    }

    
    func signUp() {
        let parameters = ["email": LecCookies.sharedCookies.user.email, "password": LecCookies.sharedCookies.user.password]
        print(parameters)
        let loginUrl = environment.httpAddress + LecConstants.NetworkSubAddressV2.Login
        
        Alamofire.request(loginUrl, method: .post, parameters: parameters).responseJSON(completionHandler: { [weak weakSelf = self] (response) in
            if let res = response.response {
                let json = JSON(res.allHeaderFields)
                LecCookies.sharedCookies.header.accessToken = json["access-token"].stringValue
                LecCookies.sharedCookies.header.client = json["client"].stringValue
                LecCookies.sharedCookies.header.expiry = json["expiry"].intValue
                LecCookies.sharedCookies.header.tokenType = json["tokenType"].stringValue
                LecCookies.sharedCookies.header.uid = json["uid"].stringValue
            }
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                guard (json["data"].dictionary != nil)  else {
                    if let errors = json["errors"].array {
                        let error = errors.first?.stringValue
                        JDStatusBarNotification.show(withStatus: error, dismissAfter: 2.0, styleName: JDStatusBarStyleError);
                    }
                    return
                }
                weakSelf?.delegate?.loginViewController(self, didLogInWithUserId: json["data", "id"].intValue)
            case .failure:
                JDStatusBarNotification.show(withStatus: "登录失败", dismissAfter: 2.0, styleName: JDStatusBarStyleError);
            }
        })
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func endEditing(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}

extension LecLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == userNameTextField) {
            passwordTextField.becomeFirstResponder()
        } else {
            perform(#selector(LecLoginViewController.signUp))
        }
        return true
    }
    
}
