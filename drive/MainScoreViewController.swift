//
//  MainScoreViewController.swift
//  drive
//
//  Created by Trevor Salom on 5/2/17.
//  Copyright © 2017 trevorsalom. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseDatabase
import MapKit
import CoreMotion

class MainScoreViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    var ref: FIRDatabaseReference!
    var username : String = ""
    var user : Dictionary<String, Any> = [:]
    var motionManager: CMMotionManager!
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate var locations = [MKPointAnnotation]()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    @IBAction func enabledChanged(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    
    @IBAction func accuracyChanged(_ sender: UISegmentedControl) {
        let accuracyValues = [
            kCLLocationAccuracyBestForNavigation,
            kCLLocationAccuracyBest,
            kCLLocationAccuracyNearestTenMeters,
            kCLLocationAccuracyHundredMeters,
            kCLLocationAccuracyKilometer,
            kCLLocationAccuracyThreeKilometers]
        
        locationManager.desiredAccuracy = accuracyValues[sender.selectedSegmentIndex];
    }
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.startUpdatingLocation()
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        ref = FIRDatabase.database().reference()
        username = defaults.value(forKey: "curruser")! as! String
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()) {
                let enumerator = snapshot.children
                while let listObject = enumerator.nextObject() as? FIRDataSnapshot {
                    let euser = ((listObject.value! as! Dictionary<String, Any>)["username"]!) as! String
                    if(euser == self.username) {
                        self.user = listObject.value! as! Dictionary<String, Any>
                        print(self.user)
                        self.scoreLabel.text = "\(round(100.0 * (self.user["overall"] as! Float)))%"
                        continue
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        print(user)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainScoreViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // Also remove from the map
            mapView.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.shared.applicationState == .active {
            print("App is backgrounded. New location is %@", mostRecentLocation)
            mapView.showAnnotations(self.locations, animated: true)
            /*if let accelerometerData = motionManager.accelerometerData {
                print("\(accelerometerData.acceleration.y)")
            }
            else {
                print("use a phone")
            }*/
        } else {
            print("App is backgrounded. New location is %@", mostRecentLocation)
        }
    }
    
}


