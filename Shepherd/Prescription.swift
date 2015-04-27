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

import Parse

class Prescription: NSObject{
    var prescription: PFObject!
    var variant: PFObject!
    var quantity = 1
    
    func individualPrice() -> Double {
        if let variant = self.variant {
            return (self.variant["Price"] as! Double!)
        }
        
        return (self.prescription["Price"] as! Double!)
    }
    
    func totalPrice() -> Double {
        return self.individualPrice() * Double(self.quantity)
    }
    
    func getName() -> String {
        return self.prescription["Name"] as! String!
    }
    
    func getType() -> String {
        return self.prescription.parseClassName
    }
    
    func getVariant() -> String {
        if self.variant == nil {
            return "Default"
        }
        
        return (self.variant["Amount"] as! Int!).description + " " + (self.variant["Units"] as! String!)
    }
    
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
    
    override var hash: Int {
        if self.variant != nil{
            return self.prescription.hashValue * self.variant.hashValue
        }
        
        return self.prescription.hashValue
    }
}