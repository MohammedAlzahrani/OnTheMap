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
//        self.mapView.delegate = self
//        let annotation = MKPointAnnotation()
//        let lat = CLLocationDegrees(self.appDelegate.newStudentLocation["latitude"] as! Double )
//        let long = CLLocationDegrees(self.appDelegate.newStudentLocation["longitude"] as! Double)
//        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        annotation.coordinate = coordinate
//        annotation.title = self.appDelegate.newStudentLocation["mapString"] as? String
//        self.mapView.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.newStudentLocation = self.appDelegate.newStudentLocation
        self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        let lat = CLLocationDegrees(self.appDelegate.newStudentLocation["latitude"] as! Double )
        let long = CLLocationDegrees(self.appDelegate.newStudentLocation["longitude"] as! Double)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        annotation.coordinate = coordinate
        annotation.title = self.appDelegate.newStudentLocation["mapString"] as? String
        self.mapView.addAnnotation(annotation)
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func submitNewLocation(_ sender: Any) {
        self.appDelegate.newStudentLocation["uniqueKey"] = self.appDelegate.userKey!
        self.sharedAPI.getStudentFullName { (success, error) in
            if success!{
//                self.newStudentLocation!["firstName"] = "moh"
//                self.newStudentLocation!["lastName"] = "ali"
                self.newStudentLocation = self.appDelegate.newStudentLocation
                print(self.newStudentLocation!)
                
                self.sharedAPI.postNewLocation(newLocationDict: self.newStudentLocation!, completion: { (success, error) in
                    if success!{
                        print("posted successfuly")
                    } else{
                        print(error!)
                        self.showAlert(message: "Faild to post new location")
                    }
                })
            } else{
                print(error!)
                self.showAlert(message: "Faild to get student full name")
            }
        }
        
        // do get full name first
    }

}
