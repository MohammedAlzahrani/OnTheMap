//
//  API.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 1/31/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import Foundation

class API{
    var accountId: String?
    static let sharedAPI = API()
    func postSession(userName:String, password:String, completion: @escaping (String?)->Void){
        let url = URL(string: APIConstants.session)
        /* 1. Set the parameters */
        //let username = "m4.w1991@gmail.com"
        //let password = "Mm-123456"
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\":{\"username\":\(userName),\"password\":\(password)}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
       
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            print(data)
        }
        /* 7. Start the request */
        task.resume()
        
    }
}
