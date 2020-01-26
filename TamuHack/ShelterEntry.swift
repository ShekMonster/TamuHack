//
//  ShelterEntry.swift
//  TamuHack
//
//  Created by Abhishek More on 1/25/20.
//  Copyright © 2020 Abhishek More. All rights reserved.
//

import Foundation
import CoreLocation

struct ShelterEntry {
    var name: String
    var type: String
    var location: CLLocation
    var email: String
    var capacity: Int
    var id: String
}

protocol FireDBAccess {
    init(user: String, pass: String)
    
    func pushShelter(entry: ShelterEntry)
    func getShelters(limit: Int) -> [ShelterEntry]
    func getUserEmail() -> String
    
    
}
