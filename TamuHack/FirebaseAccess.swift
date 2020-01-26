//
//  FirebaseAccess.swift
//  TamuHack
//
//  Created by Jeffrey Ryan on 1/26/20.
//  Copyright © 2020 Abhishek More. All rights reserved.
//

import MapKit
import Firebase

public class FireDBAccess {
    private static var instance: FireDBAccess!

    private var ref: DatabaseReference
    private var user: User
    private var shelterListeners: [ShelterListener]
    private var shelters: [ShelterEntry]

    public static func fireDBAccess() -> FireDBAccess {
        if instance == nil {
            instance = FireDBAccess()
        }

        return instance;
    }

    private init() {
        ref = Database.database().reference()
        user = Auth.auth().currentUser!
        shelterListeners = []
        shelters = []
        
        populateShelters()
    }

    public func pushShelter(name: String, type: String, capacity: Int, location: CLLocation) {
        let dataDict = ["name": name,
                    "type": type,
                    "capacity": capacity,
                    "latitude": location.coordinate.latitude,
                    "longitude": location.coordinate.longitude,
                    "email": user.email!,
                    "uid": user.uid] as [String: Any]

        ref.child("Shelters").childByAutoId().setValue(dataDict)
    }

    public func getShelters() -> [ShelterEntry] {
        return shelters
    }

    public func addShelterListener(listener: ShelterListener) {
        shelterListeners.append(listener)
    }

    public func removeShelterListener(listener: ShelterListener) {
        shelterListeners = shelterListeners.filter { $0 !== listener }
    }

    private func populateShelters() {
        ref.child("Shelters").observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let shelter = snap.value as? [String:AnyObject] {
                        let name = shelter["name"]! as! String
                        let type = shelter["type"]! as! String
                        let capacity = shelter["capacity"]! as! Int
                        let latitude = shelter["latitude"]! as! Double
                        let longitude = shelter["longitude"]! as! Double
                        let email = shelter["email"]! as! String
                        let uid = shelter["uid"]! as! String

                        let location = CLLocation(latitude: latitude, longitude: longitude)
                        let newShelter = ShelterEntry(name: name, type: type, location: location, email: email, capacity: capacity, id: uid)

                        self.shelters.append(newShelter)
                    }
                }

                for listener in self.shelterListeners {
                    listener.shelterDataChanged()
                }
            }
        })
    }
}

public protocol ShelterListener: class {
    func shelterDataChanged()
}
