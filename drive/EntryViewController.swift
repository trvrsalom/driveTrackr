//
//  EntryViewController.swift
//  drive
//
//  Created by Trevor Salom on 4/26/17.
//  Copyright © 2017 trevorsalom. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EntryViewController: UIViewController {

    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var create: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.configure()
        // Do any additional setup after loading the view.
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
