//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 04/02/2019.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit
import CoreLocation

class NewLocationViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationNameTextField.delegate = self
        self.urlTextField.delegate = self
        self.configureUI(enabled: false)
        // Do any additional setup after loading the view.

    }
    @IBAction func findLocation(_ sender: Any) {
        
        guard let address = locationNameTextField.text else{
            self.showAlert(message: "The location field is empty!")
            return
        }
        configureUI(enabled: true)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    self.showAlert(message: "geocoding fails")
                    self.configureUI(enabled: false)
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
            
            self.configureUI(enabled: false)
            let storyboard = UIStoryboard (name: "Main", bundle: nil)
            let mapVC = storyboard.instantiateViewController(withIdentifier: "NewLocationMap")as! NewLocationMapViewController
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func configureUI(enabled:Bool) {
        if enabled{
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.findLocationButton.isEnabled = false
        } else{
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.findLocationButton.isEnabled = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss kyboard when return is pressed
        textField.resignFirstResponder()
        return true;
    }
}
