//
//  ShelterEntry.swift
//  TamuHack
//
//  Created by Abhishek More on 1/25/20.
//  Copyright © 2020 Abhishek More. All rights reserved.
//

import Foundation
import CoreLocation

public struct ShelterEntry {
    var name: String
    var type: String
    var location: CLLocation
    var email: String
    var capacity: Int
    var id: String
}
