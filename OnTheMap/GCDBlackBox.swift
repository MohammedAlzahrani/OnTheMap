//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Mohammed ALZAHRANI on 2/1/19.
//  Copyright © 2019 Mohammed ALZAHRANI. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
