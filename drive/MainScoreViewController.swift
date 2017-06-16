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
    var auto = false;
    let activityManager = CMMotionActivityManager()
    var oldLocation : CLLocation = CLLocation.init()
    var sum = 0.0;
    var count = 0.0;
    
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
        if(CMMotionActivityManager.isActivityAvailable()) {
            self.activityManager.startActivityUpdates(to: OperationQueue.current!, withHandler: {
                activityData
                in
                self.auto = (activityData?.automotive)!
            })
        }
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
        
        if(oldLocation === nil) {
            oldLocation = locations.last!;
        }
        var currLocation = locations.last
        var speedDelta = (currLocation?.speed)! - oldLocation.speed
        var deltaT = currLocation?.timestamp.timeIntervalSince(oldLocation.timestamp)
        sum = sum + (speedDelta as! Double);
        count = count + 1;
        var average = sum/(count as! Double);
        
        var err = abs(((0.5 - average)/0.5) * 1);
        print(err);
        var score = 100 - err;
        var scoreStr = String(format: "%.0f", score)
        self.scoreLabel.text = "\(scoreStr)%";
        //ref.child("users").child(username).child("overall").setValue(score/100)
        oldLocation = locations.last!;
        /*
        if(self.auto && locations.count > 2) {
            var oldLocation = locations[locations.count-2]
            var currLocation = locations.last
            var speedDelta = (currLocation?.speed)! - oldLocation.speed
            var deltaT = currLocation?.timestamp.timeIntervalSince(oldLocation.timestamp)
            print(speedDelta)
        }*/

    }
    
}


