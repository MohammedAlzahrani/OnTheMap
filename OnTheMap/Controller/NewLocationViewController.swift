//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 04/02/2019.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit
import CoreLocation

class NewLocationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    @IBAction func findLocation(_ sender: Any) {
        let address = locationNameTextField.text!
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            
            // Use your location
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            //self.appDelegate.newStudentLocation
            self.appDelegate.newStudentLocation["mapString"] = address
            self.appDelegate.newStudentLocation["latitude"] = location.coordinate.latitude
            self.appDelegate.newStudentLocation["longitude"] = location.coordinate.longitude
            print(self.appDelegate.newStudentLocation)
            // TODO:-
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let mapVC = storyboard.instantiateViewController(withIdentifier: "NewLocationMap")as! NewLocationMapViewController
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
