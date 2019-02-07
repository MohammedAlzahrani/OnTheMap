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
    
    static let sharedAPI = API()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func postSession(userName:String, password:String, completion: @escaping (_ success:Bool?, _ error:String?)->Void){
        let url = URL(string: APIConstants.session)
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                if (response as? HTTPURLResponse)?.statusCode == 403{
                    sendError("Account not found or invalid credentials")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data */
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            let accountInfo = parsedResult["account"] as! [String:AnyObject]
            let sessionInfo = parsedResult["session"] as! [String:AnyObject]
            guard let userKey = accountInfo["key"]  as? String else {
                sendError("user key is not found")
                return
            }
            guard let sessionID = sessionInfo["id"] as? String else {
                sendError("Session id is not found")
                return
            }
            self.appDelegate.userKey = userKey
            self.appDelegate.sessionID = sessionID
            completion(true,nil)
            
        }
        /* 7. Start the request */
        task.resume()
        
    }
    
    func deleteSession(sessionID:String, completion: @escaping (Bool?)->Void)  {
        let url = URL(string: APIConstants.session)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }
    func getStudentLocations(completion: @escaping (_ success:Bool?, _ error:String?)->Void)  {
        let url = URL(string: APIConstants.studentLocationsURL)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                completion(false, error)
            }
            guard  (error == nil) else {
                sendError("There was an error with your request")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            print(String(data: data, encoding: .utf8)!)
            var locationsDict: jsonResponse
            do{
                locationsDict = try JSONDecoder().decode(jsonResponse.self, from: data)
            } catch let jsonError{
                sendError(jsonError.localizedDescription)
                print("json error")
                print(jsonError)
                return
            }
            self.appDelegate.studentLocations = locationsDict.results
            print(locationsDict.results)
            completion(true, nil)
        }
        task.resume()
    }
    
    func getStudentFullName(completion: @escaping (_ success:Bool?, _ error:String?)->Void)  {
        guard let userKey = appDelegate.userKey else {
            print("user key is not found")
            return
        }
        let urlString = APIConstants.studentFullNameURL + userKey
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                completion(false, error)
            }
            guard  (error == nil) else {
                sendError("There was an error with your request")
                return
            }
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON: '\(newData)'")
                return
            }
            self.appDelegate.newStudentLocation["firstName"] = parsedResult["first_name"] as! String
            self.appDelegate.newStudentLocation["lastName"] = parsedResult["last_name"] as! String
            completion(true, nil)
        }
        task.resume()
    }
    func postNewLocation(newLocationDict:[String:Any], completion: @escaping (_ success:Bool?, _ error:String?)->Void){
        let url = URL(string: APIConstants.studentNewLocationURL)
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        var postBody: Data
        do{
            postBody = try JSONSerialization.data(withJSONObject: newLocationDict)
        } catch{
            print("cant convert to json")
            return
        }
        request.httpBody = postBody
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
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                if (response as? HTTPURLResponse)?.statusCode == 403{
                    sendError("Account not found or invalid credentials")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            completion(true,nil)
            
        }
        /* 7. Start the request */
        task.resume()
        
    }
}
