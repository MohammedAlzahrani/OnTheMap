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
    // MARK:- Outlets
    @IBOutlet weak var mapView: MKMapView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK:- Map related fuctions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        // loading locations
        API.sharedAPI.getStudentLocations { (success, error) in
            if success! {
                performUIUpdatesOnMain {
                // constructing annotations for locations
                var annotations = [MKPointAnnotation]()
                let locations = self.appDelegate.studentLocations
                for location in locations {
                    let lat = CLLocationDegrees(location.latitude )
                    let long = CLLocationDegrees(location.longitude )
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let firstName = location.firstName ?? "NA"
                    let lastName = location.lastName ?? "NA"
                    let mediaURL = location.mediaURL ?? "NA"
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
            }
            }
            // loading locations failure
            else{
                    self.showAlert(message: "Failed to retrive student locations")
            }
        }
    }
    // annotations dicoration
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
                app.open(URL(string: toOpen)!)
            }
        }
    }
    // MARK:- Actions
    @IBAction func logout(_ sender: Any) {
        // logout request
        API.sharedAPI.deleteSession(sessionID: appDelegate.sessionID!) { (loggedout) in
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }


}
