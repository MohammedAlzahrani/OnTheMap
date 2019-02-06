//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 1/18/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var debugLable: UILabel!
    let sharedAPI = API.sharedAPI
    //var appDelegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        configureUI(enabled: false)
        // Do any additional setup after loading the view, typically from a nib.
        //appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        self.debugLable.text = ""
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            debugLable.text = "email or password field is empty"
        } else{
            configureUI(enabled: true)
            sharedAPI.postSession(userName: emailTextField.text!, password: passwordTextField.text!, completion: { result,erro  in
                if result!{
                    print("logged in successfully")
                    performUIUpdatesOnMain{
                        self.debugLable.text = "logged in successfully"
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "LocationsTabBarController") as! UITabBarController
                        self.present(controller, animated: true, completion: nil)
                    }
                }
                else{
                    print("Failed to login")
                    performUIUpdatesOnMain {
                        self.debugLable.text = "Failed to login: \(erro!)"
                        self.configureUI(enabled: false)
                    }
                }
            })
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss kyboard when return is pressed
        textField.resignFirstResponder()
        return true;
    }
    func configureUI(enabled:Bool) {
        if enabled{
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.loginButton.isEnabled = false
        } else{
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.loginButton.isEnabled = true
        }
    }


}

