//
//  LoginViewController.swift
//  LeControl
//
//  Created by 新 范 on 16/8/25.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import Whisper
import SwiftyJSON

protocol LecLoginViewControllerDelegate: class {
    func loginViewController(controller: LecLoginViewController, didLogInWithUserId userId: String)
}

class LecLoginViewController: UIViewController {

    weak var delegate: LecLoginViewControllerDelegate?

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func login(sender: AnyObject) {
        if let userName = userNameTextField.text, password = passwordTextField.text {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(userName, forKey: "userName")
            defaults.setValue(password, forKey: "password")
            defaults.synchronize()
            
            /*
             Network.POSTLogin(userName: userName, password: password).go() { [weak weakSelf = self] response in
             switch response {
             case .Success(let json):
             print(json)
             guard json["Ok"].boolValue else {
             if let msg = json["Msg"].string{
             Whistle(Murmur(title: msg, backgroundColor: UIColor.redColor()), action: .Show(1.5))
             }
             return
             }
             weakSelf?.delegate?.loginViewController(self, didLogInWithUserId: json["UserId"].stringValue)
             case .Failure(let error):
             print(error)
             Whistle(Murmur(title: error, backgroundColor: UIColor.redColor()), action: .Show(1.5))
             }
             
             }
             */
            Network.POSTLogin(userName: "ting", password: "111111").go() { [weak weakSelf = self] response in
                switch response {
                case .Success(let json):
                    print(json)
                    guard json["Ok"].boolValue else {
                        if let msg = json["Msg"].string{
                            Whistle(Murmur(title: msg, backgroundColor: UIColor.redColor()), action: .Show(1.5))
                        }
                        return
                    }
                    weakSelf?.delegate?.loginViewController(self, didLogInWithUserId: json["UserId"].stringValue)
                case .Failure(let error):
                    print(error)
                    Whistle(Murmur(title: error, backgroundColor: UIColor.redColor()), action: .Show(1.5))
                }
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
