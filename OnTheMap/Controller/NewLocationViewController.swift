//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 04/02/2019.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController {
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func findLocation(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
