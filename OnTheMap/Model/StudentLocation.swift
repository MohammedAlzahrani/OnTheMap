//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 1/31/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    var createdAt: String
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String
    var uniqueKey: String?
    var updatedAt: String
}

struct jsonResponse: Codable {
    var results : [StudentLocation]
}
