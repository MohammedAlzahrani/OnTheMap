//
//  LocationsTableViewController.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 2/2/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {
    @IBOutlet var locationTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        API.sharedAPI.getStudentLocations { (success, error) in
            if success! {
                print("success")
            } else {
                print("Failed to retrive student locations")
                self.showAlert(message: "Failed to retrive student locations")
            }
        }
    }

    @IBAction func logout(_ sender: Any) {
        API.sharedAPI.deleteSession(sessionID: appDelegate.sessionID!) { (loggedout) in
            performUIUpdatesOnMain {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.studentLocations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        // Configure the cell...
        let studentFullName = "\(appDelegate.studentLocations[indexPath.row].firstName) \(appDelegate.studentLocations[indexPath.row].lastName)"
        cell.textLabel?.text = studentFullName
        cell.detailTextLabel?.text = appDelegate.studentLocations[indexPath.row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: appDelegate.studentLocations[indexPath.row].mediaURL)
        UIApplication.shared.open(url!)
        print(url!)
    }
    @IBAction func addNewLocation(_ sender: Any) {
    }
    
    func showAlert(message:String) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}
