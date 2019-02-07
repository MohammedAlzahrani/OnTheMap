//
//  LocationsTableViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 2/2/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {
    // MARK:- Outlets
    @IBOutlet var locationTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // loading locations
        API.sharedAPI.getStudentLocations { (success, error) in
            if success! {
                print("success")
            } else {
                self.showAlert(message: "Failed to retrive student locations")
            }
        }
    }
    // MARK:- Actions
    @IBAction func logout(_ sender: Any) {
        API.sharedAPI.deleteSession(sessionID: appDelegate.sessionID!) { (loggedout) in
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.studentLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Configure the cell...
        let firstName = appDelegate.studentLocations[indexPath.row].firstName ?? "NA"
        let lastName = appDelegate.studentLocations[indexPath.row].lastName ?? "NA"
        let studentFullName = "\(firstName) \(lastName)"
        cell.textLabel?.text = studentFullName
        cell.detailTextLabel?.text = appDelegate.studentLocations[indexPath.row].mediaURL ?? "NA"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlString = appDelegate.studentLocations[indexPath.row].mediaURL else{
            return
        }
        let url = URL(string: urlString)
        UIApplication.shared.open(url!)
    }
}
