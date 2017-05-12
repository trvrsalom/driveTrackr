//
//  LoginViewController.swift
//  drive
//
//  Created by Trevor Salom on 4/26/17.
//  Copyright © 2017 trevorsalom. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

    var ref: FIRDatabaseReference!
    var defaults = UserDefaults.standard
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
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
    @IBAction func loginCall(_ sender: Any) {
        if(username.text == "" && password.text == "") {
            errorLabel.text = "Please fill out all fields"
        }
        else {
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.exists()) {
                    let enumerator = snapshot.children
                    var logged = false
                    while let listObject = enumerator.nextObject() as? FIRDataSnapshot {
                        let euser = ((listObject.value! as! Dictionary<String, Any>)["username"]!) as! String
                        let epass = ((listObject.value! as! Dictionary<String, Any>)["password"]!) as! String
                        if((euser == self.username.text!) && (epass == self.password.text!)) {
                            logged = true
                            self.defaults.set(self.username.text!, forKey: "curruser")
                            continue
                        }
                    }
                    if(!logged) {
                        self.errorLabel.text = "Incorrect username or password"
                    }
                    else {
                        self.performSegue(withIdentifier: "accountLogged", sender: nil)
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }

}
