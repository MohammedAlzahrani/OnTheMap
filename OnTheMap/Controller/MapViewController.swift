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

        // Do any additional setup after loading the view.
    }
    @IBAction func logout(_ sender: Any) {
        API.sharedAPI.deleteSession(sessionID: appDelegate.sessionID!) { (loggedout) in
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    

}
