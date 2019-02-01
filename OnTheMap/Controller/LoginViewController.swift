//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 1/18/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugLable: UILabel!
    let sharedAPI = API.sharedAPI
    //var appDelegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            debugLable.text = "email or password field is empty"
        } else{
            sharedAPI.postSession(userName: emailTextField.text!, password: passwordTextField.text!, completion: { result,erro  in
                if result!{
                    print("loged in successfully")
                    performUIUpdatesOnMain{self.debugLable.text = "loged in successfully"}
                }
                else{
                    print("Failed to login")
                    performUIUpdatesOnMain {
                        self.debugLable.text = erro!
                    }
                }
            })
            
        }
    }

}

