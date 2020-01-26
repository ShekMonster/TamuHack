//
//  HomeVC.swift
//  TamuHack
//
//  Created by Abhishek More on 1/25/20.
//  Copyright © 2020 Abhishek More. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class HomeVC: UIViewController {
    
    @IBOutlet var profileButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var addResidenceLabel: UILabel!
    @IBOutlet var addLocationView: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var plusSign: UIImageView!
    @IBOutlet var profileSign: UIImageView!
    @IBOutlet var plusSignButton: UIButton!
    @IBOutlet var bottomBarView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var residenceName: UITextField!
    @IBOutlet var residenceType: UITextField!
    @IBOutlet var residenceCapacity: UITextField!
    @IBOutlet var third: UIImageView!
    @IBOutlet var second: UIImageView!
    @IBOutlet var first: UIImageView!
    @IBOutlet var fourth: UIImageView!
    
    var ref: DatabaseReference!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var userLocation: CLLocation?
    var plusSignX: CGFloat?
    var posting = false
    var locations: [ShelterEntry] = []

    
    
    let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        getShelters()
        plusSignX = self.plusSign.center.x
        addLocationView.center.y += 600
        addResidenceLabel.alpha = 0

        setLocation()
        centerMapOnLocation(location: userLocation!)

    }

    @IBAction func plusSignPressed(_ sender: Any) {
       
        if !posting {
            posting = true
            UIView.animate(withDuration: 0.5) {
                self.plusSignRight()
            }
        } else {
            posting = false
            UIView.animate(withDuration: 0.5) {
                
                self.plusSignLeft()
                
            }
        }
        
    }
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters:regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    @IBAction func sendLocationPressed(_ sender: Any) {
        
        if let name = residenceName.text {
            if let type = residenceType.text {
                if let capacity = Int(residenceCapacity.text!) {
                    if validText() {
                        newShelter(name: name, type: type, capacity: capacity, location: userLocation!)
                        animateSubmit()
                    } else {
                        textErrorAlert()
                    }
                }
            }
        }
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
    }
    
    func setLocation() {
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){

            userLocation = delegate.locationManager.location

        }
        
    }

    
    func markLocations() {
        
        for location in locations {
            let point = location.location.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = point
            annotation.title = location.name
            annotation.subtitle = location.type
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    func validText() -> Bool{
        
        if(residenceCapacity.text != "" && residenceType.text != "" && residenceName.text != "") {
            return true
        } else {
            return false
        }
        
    }
  
    
    func textErrorAlert() {
        print("Text fields cannot be empty")
    }

    func newShelter(name: String, type: String, capacity: Int, location: CLLocation) {
        
        let dict = ["name": name,
                    "type": type,
                    "capacity": capacity,
                    "latitude": location.coordinate.latitude,
                    "longitude": location.coordinate.longitude,
                    "email": user!.email,
                    "uid":user!.uid] as [String: Any]
        ref.child("Shelters").childByAutoId().setValue(dict)
        
    }
    
    func getShelters() {
        locations = []
        self.ref.child("Shelters").observe(.value, with: { (snapshot) in
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
                        self.locations.append(newShelter)
                        self.markLocations()
                    }
                }
               
            }
        })

    }
    
    func animateSubmit() {
        
        UIView.animate(withDuration: 0.75 * 4){
            self.addResidenceLabel.center.y -= 300 * 4
            self.addResidenceLabel.alpha = 0
            self.first.center.y -= 300 * 4
            self.first.alpha = 0
            self.residenceName.center.y -= 300 * 4
            self.residenceName.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIView.animate(withDuration: 0.75 * 4){
                self.second.center.y -= 393 * 4
                self.second.alpha = 0
                self.residenceType.center.y -= 393 * 4
                self.residenceType.alpha = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            UIView.animate(withDuration: 0.75 * 4){
                self.third.center.y -= 486 * 4
                self.third.alpha = 0
                self.residenceCapacity.center.y -= 486 * 4
                self.residenceCapacity.alpha = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            UIView.animate(withDuration: 0.75 * 4){
                self.fourth.center.y -= 579 * 4
                self.submitButton.center.y -= 579 * 4
                self.fourth.alpha = 0
                self.submitButton.alpha = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            UIView.animate(withDuration: 0.5) {
                self.plusSignLeft()
                self.posting = false
            }
            self.getShelters()
    
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            
            self.addResidenceLabel.center.y += 300 * 4
            self.first.center.y += 300 * 4
            self.first.alpha = 1
            self.residenceName.center.y += 300 * 4
            self.residenceName.alpha = 1
            self.second.center.y += 393 * 4
            self.second.alpha = 1
            self.residenceType.center.y += 393 * 4
            self.residenceType.alpha = 1
            self.third.center.y += 486 * 4
            self.third.alpha = 1
            self.residenceCapacity.center.y += 486 * 4
            self.residenceCapacity.alpha = 1
            self.fourth.center.y += 579 * 4
            self.fourth.alpha = 1
            self.submitButton.center.y += 579 * 4
            self.submitButton.alpha = 1
        }
        
    }
    
    func plusSignLeft() {
        
        let angle = 0
        self.plusSign.center.x = self.plusSignX!
        self.plusSignButton.center.x = self.plusSignX!
        self.plusSign.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        self.profileSign.center.x -= 100
        self.profileSign.alpha = 1
        self.blurView.alpha = 0
        self.addLocationView.center.y += 600
        self.addResidenceLabel.alpha = 0
        
        self.residenceName.text = ""
        self.residenceType.text = ""
        self.residenceCapacity.text = ""
        
        self.profileButton.isEnabled = true
        
    }
    
    func plusSignRight() {
        let angle = Double.pi / -4 - 5 * Double.pi
        self.plusSign.center.x = self.bottomBarView.center.x
        self.plusSignButton.center.x = self.bottomBarView.center.x
        self.plusSign.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        self.profileSign.center.x += 100
        self.profileSign.alpha = 0
        self.blurView.alpha = 0.9
        self.addLocationView.center.y -= 600
        self.addResidenceLabel.alpha = 1
        
        self.profileButton.isEnabled = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
}
