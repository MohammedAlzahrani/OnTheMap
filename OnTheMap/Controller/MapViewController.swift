//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 2/2/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        API.sharedAPI.getStudentLocations { (success, error) in
            if success! {
                print(self.appDelegate.studentLocations[0].firstName)
                performUIUpdatesOnMain {
                
                var annotations = [MKPointAnnotation]()
                let locations = self.appDelegate.studentLocations
                for location in locations {
                    
        
                    let lat = CLLocationDegrees(location.latitude )
                    let long = CLLocationDegrees(location.longitude )
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = location.firstName
                    let last = location.lastName
                    let mediaURL = location.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(annotations)
            }
            }
            else{
                print("Failed to retrive student locations")
                print(error!)
               // performUIUpdatesOnMain {
                    self.showAlert(message: "Failed to retrive student locations")
                //}
            }
        }
        // Do any additional setup after loading the view.
        

    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    func showAlert(message:String) {
        performUIUpdatesOnMain {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func logout(_ sender: Any) {
        API.sharedAPI.deleteSession(sessionID: appDelegate.sessionID!) { (loggedout) in
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func refreshData(_ sender: Any) {
        API.sharedAPI.getStudentLocations { (success, error) in
            if success! {
                print("success")
            } else {
                print("Failed to refresh student locations")
            }
        }
    }
    @IBAction func addNewLocation(_ sender: Any) {
    }
    

}
