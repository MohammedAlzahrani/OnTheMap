//
//  UIViewController+Alert.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 06/02/2019.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showAlert(message:String) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
