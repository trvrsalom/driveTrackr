//
//  CreateViewController.swift
//  drive
//
//  Created by Trevor Salom on 4/26/17.
//  Copyright © 2017 trevorsalom. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateViewController: UIViewController {

    var ref: FIRDatabaseReference!

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    
    @IBOutlet weak var warningText: UILabel!
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(_ sender: Any) {
        //self.ref.child("users").setValue(["username":"test"])
        //if(
        print(email.text == "")
        if(email.text != "" && username.text != "" && password.text != "" && passwordConfirmation.text != "" && password.text == passwordConfirmation.text) {
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()) {
                    let enumerator = snapshot.children
                    var unique = true
                    while let listObject = enumerator.nextObject() as? FIRDataSnapshot {
                        let euser = ((listObject.value! as! Dictionary<String, Any>)["username"]!)
                        let eemail = ((listObject.value! as! Dictionary<String, Any>)["email"]!)
                        if((eemail as! String) == self.email.text) {
                            unique = false
                            self.warningText.text = "That email is already in use."
                        }
                        if((euser as! String) == self.username.text) {
                            unique = false
                            self.warningText.text = "That username is taken."
                        }
                    }
                    if(unique){
                        print("Success")
                        self.defaults.set(self.username.text!, forKey: "curruser")
                            self.ref.child("users").child(self.username.text!).setValue([
                                "username": self.username.text!,
                                "email": self.email.text,
                                "password": self.password.text,
                                "drives": [],
                                "scores": [],
                                "overall": 0.5
                            ])
                        self.performSegue(withIdentifier: "accountCreated", sender: nil)
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        else if(password.text == passwordConfirmation.text) {
            warningText.text = "Passwords must match."
        }
        else {
            warningText.text = "Please fill out all information."
        }
        
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
