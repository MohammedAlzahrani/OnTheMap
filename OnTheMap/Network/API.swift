//
//  API.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 1/31/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import Foundation
import UIKit
class API{
    //var appDelegate: AppDelegate!
    //var userKey: Int?
    static let sharedAPI = API()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
//    init() {
//        appDelegate = UIApplication.shared.delegate as! AppDelegate
//    }
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func postSession(userName:String, password:String, completion: @escaping (_ success:Bool?, _ error:String?)->Void){
        let url = URL(string: APIConstants.session)
//        print(userName)
//        print(password)
        /* 1. Set the parameters */
        //let username = "m4.w1991@gmail.com"
        //let password = "Mm-123456"
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        //let data = "{\"udacity\":{\"username\":\(userName), \"password\":\(password)}".data(using:.utf8)
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\":\"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                completion(false, error)
                
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request ")
                return
            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(String(data: newData!, encoding: .utf8)!)
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                if (response as? HTTPURLResponse)?.statusCode == 403{
                    sendError("Account not found or invalid credentials")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            //print(String(data: newData, encoding: .utf8)!)
            //print(parsedResult!)
            let accountInfo = parsedResult["account"] as! [String:AnyObject]
            let sessionInfo = parsedResult["session"] as! [String:AnyObject]
            //print(accountInfo["key"]!)
            guard let userKey = accountInfo["key"]  as? String else {
                print("user key is not found")
                return
            }
            guard let sessionID = sessionInfo["id"] as? String else {
                print("Session id is not found")
                return
            }
//            print(userKey)
//            print(sessionID)
            self.appDelegate.userKey = userKey
            self.appDelegate.sessionID = sessionID
            completion(true,nil)
            
        }
        /* 7. Start the request */
        task.resume()
        
    }
}
