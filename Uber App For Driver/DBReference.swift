//
//  DBProvider.swift
//  Uber App For Rider
//
//  Created by MacBook on 10/23/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider();
    
    static var Instance: DBProvider {
        return _instance;
    }
    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference();
    }
    
    var driversRef: FIRDatabaseReference {
        return dbRef.child(Constants.DRIVERS);
    }
    
    var requestRef: FIRDatabaseReference {
        return dbRef.child(Constants.UBER_REQUEST);
    }
    
    var requestAcceptedRef: FIRDatabaseReference {
        return dbRef.child(Constants.UBER_ACCEPTED);
    }
    
    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isRider: false];
        driversRef.child(withID).child(Constants.DATA).setValue(data);
    }
    
} // class







































