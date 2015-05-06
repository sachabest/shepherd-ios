//
//  Prescription.swift
//  Shepherd
//
//  This class is part of the data model, representing a combination of a treatment or test,
//  an optional variant, and a quantity.
//
//  Created by Rohun Bansal on 4/27/15.
//  Copyright (c) 2015 Shepherd. All rights reserved.
//

class Prescription: NSObject{
    var prescription: PFObject!
    var variant: PFObject!
    var quantity = 1
    
    // computes the price of each individual unit of the Prescription
    func individualPrice() -> Double {
        if let variant = self.variant {
            return (self.variant["Price"] as! Double!)
        }
        
        return (self.prescription["Price"] as! Double!)
    }
    
    // total price = individual price * quantity
    func totalPrice() -> Double {
        return self.individualPrice() * Double(self.quantity)
    }
    
    // name of the Prescription, from the underlying test/treatment
    func getName() -> String {
        return self.prescription["Name"] as! String!
    }
    
    // whether the Prescription is for a Test or a Treatment
    func getType() -> String {
        return self.prescription.parseClassName
    }
    
    // "Default" if no variant, otherwise a descriptive string of the Variant
    func getVariant() -> String {
        if self.variant == nil {
            return "Default"
        }
        
        return (self.variant["Amount"] as! Int!).description + " " + (self.variant["Units"] as! String!)
    }
    
    // Prescription equality based on 1) same test/treatment and/or 2) same variant if specified
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? Prescription {
            if self.variant != nil{
                return self.prescription == object.prescription && self.variant == object.variant
            }
            
            return self.prescription == object.prescription
        } else {
            return false
        }
    }
    
    // similar to isEqual, just for methods that require hashes
    override var hash: Int {
        if self.variant != nil{
            return self.prescription.hashValue * self.variant.hashValue
        }
        
        return self.prescription.hashValue
    }
}