//
//  User.swift
//  drive
//
//  Created by Trevor Salom on 4/26/17.
//  Copyright © 2017 trevorsalom. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class User {
    var usersname = ""
    var email = ""
    var password = ""
    var uid = ""
    
    init(withSnapshot: FIRDataSnapshot) {
        let dict = withSnapshot.value as! [String:AnyObject]
        
        uid = withSnapshot.key
        usersname = dict["usersname"] as! String
        email = dict["email"] as! String
        password = dict["password"] as! String
    }
}
