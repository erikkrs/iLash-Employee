//
//  UberHandler.swift
//  Uber App For Driver
//
//  Created by MacBook on 10/24/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol UberController: class {
    func acceptUber(lat: Double, long: Double);
    func riderCanceledUber();
    func uberCanceled();
    func updateRidersLocation(lat: Double, long: Double);
}

class UberHandler {
    private static let _instance = UberHandler();
    
    weak var delegate: UberController?;
    
    var rider = "";
    var driver = "";
    var driver_id = "";
    
    static var Instance: UberHandler {
        return _instance;
    }
    
    func observeMessagesForDriver() {
        // RIDER REQUESTED AN UBER
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let latitude = data[Constants.LATITUDE] as? Double {
                    if let longitude = data[Constants.LONGITUDE] as? Double {
                        self.delegate?.acceptUber(lat: latitude, long: longitude);
                    }
                }
                
                if let name = data[Constants.NAME] as? String {
                    self.rider = name;
                }
                
            }
            
            // RIDER CANCELED UBER
            DBProvider.Instance.requestRef.observe(FIRDataEventType.childRemoved, with: { (snapshot: FIRDataSnapshot) in
               
                if let data = snapshot.value as? NSDictionary {
                    if let name = data[Constants.NAME] as? String {
                        if name == self.rider {
                            self.rider = "";
                            self.delegate?.riderCanceledUber();
                        }
                    }
                }
                
            });
            
        }
        
        // RIDER UPDATING LOCATION
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childChanged) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let lat = data[Constants.LATITUDE] as? Double {
                    if let long = data[Constants.LONGITUDE] as? Double {
                        self.delegate?.updateRidersLocation(lat: lat, long: long);
                    }
                }
            }
            
        }
        
        // DRIVER ACCEPTS UBER
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver {
                        self.driver_id = snapshot.key;
                    }
                }
            }
            
        }
        
        // DRIVER CANCELED UBER
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childRemoved) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver {
                        self.delegate?.uberCanceled();
                    }
                }
            }
            
        }
        
    } // observeMessagesForDriver
    
    func uberAccepted(lat: Double, long: Double) {
        let data: Dictionary<String, Any> = [Constants.NAME: driver, Constants.LATITUDE: lat, Constants.LONGITUDE: long];
        
        DBProvider.Instance.requestAcceptedRef.childByAutoId().setValue(data);
    }
    
    func cancelUberForDriver() {
        DBProvider.Instance.requestAcceptedRef.child(driver_id).removeValue();
    }
    
    func updateDriverLocation(lat: Double, long: Double) {
        DBProvider.Instance.requestAcceptedRef.child(driver_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE: long]);
    }
    
}













































