//
//  NewLocationMapViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 05/02/2019.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit
import MapKit

class NewLocationMapViewController: UIViewController, MKMapViewDelegate {
    // MARK:- Outlets
    @IBOutlet weak var mapView: MKMapView!
    var newStudentLocation: [String:Any]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let sharedAPI = API.sharedAPI
    // MARK:- preparing map
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        // preparing map to show new location
        self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        let lat = CLLocationDegrees(self.appDelegate.newStudentLocation["latitude"] as! Double )
        let long = CLLocationDegrees(self.appDelegate.newStudentLocation["longitude"] as! Double)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        // configuring annotation
        annotation.coordinate = coordinate
        annotation.title = self.appDelegate.newStudentLocation["mapString"] as? String
        self.mapView.addAnnotation(annotation)
        // zooming map to new location
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
    }
    // MARK:- Actions
    @IBAction func submitNewLocation(_ sender: Any) {
        self.appDelegate.newStudentLocation["uniqueKey"] = self.appDelegate.userKey!
        // getting student's full name
        self.sharedAPI.getStudentFullName { (success, error) in
            if success!{
                self.newStudentLocation = self.appDelegate.newStudentLocation
                // posting new location
                self.sharedAPI.postNewLocation(newLocationDict: self.newStudentLocation!, completion: { (success, error) in
                    if success!{
                        print("posted successfuly")
                    } else{
                        print(error!)
                        self.showAlert(message: "Faild to post new location")
                    }
                })
            } else{
                self.showAlert(message: "Faild to get student full name")
            }
        }
    }
}
