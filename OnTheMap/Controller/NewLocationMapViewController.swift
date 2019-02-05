//
//  NewLocationMapViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 05/02/2019.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation
class NewLocationMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var newStudentLocation: [String:Any]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let sharedAPI = API.sharedAPI
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.newStudentLocation = self.appDelegate.newStudentLocation
    }
    
    @IBAction func submitNewLocation(_ sender: Any) {
        self.appDelegate.newStudentLocation["uniqueKey"] = self.appDelegate.userKey!
        
        self.newStudentLocation!["firstName"] = "moh"
        self.newStudentLocation!["lastName"] = "ali"
        self.newStudentLocation = self.appDelegate.newStudentLocation
        print(self.newStudentLocation!)
        // do get full name first
    }

}
