//
//  Meal .swift
//  FoodTracker
//
//  Created by Chandi Abey  on 8/8/16.
//  Copyright © 2016 Chandi Abey . All rights reserved.
//

import UIKit

class Meal: NSObject, NSCoding {

    //MARK: Properties - basic properties for data

    var name: String
    var photo: UIImage?
    var rating: Int
    
    
    //MARK: Types
    
    struct PropertyKey {
        
        //add properties, each constant corresponds to one of 3 properties on Meal, static indicates constant applies to structure itself (not instance of structure)
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
        
    }

    
    //MARK: Archiving Paths
    //static keyword means they apply to the class instead of an instance of the class. outside of meal class, access path using Meal.ArchiveURL.path!
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")

    
    
    
    
    // MARK: Initialization- method that prepares instance of a class for use
		 
		init?(name:  String, photo:  UIImage?, rating:  Int) {
            // Initialize stored properties, setting them equal to parametr values
            self.name = name
            self.photo = photo
            self.rating = rating
            
            super.init()

            // Initialization should fail if there is no name or if the rating is negative.
            if name.isEmpty || rating < 0 {
                return nil
            }
		}
    
    // MARK: NSCoding (means code is related to data persistence)
    //altogether encodes value of each property on Meal class and stores them in corresponding key
    
    func encodeWithCoder(aCoder:  NSCoder) {
        //encodeObject method encodes any type of object
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        //encodes an integer
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    required convenience init?(coder aDecoder:  NSCoder ) {
        
        //decodeObjectForKey method unarchives stored info about object, return value is any object which can downcast as String to assign it to a name constant
        let name =
            aDecoder.decodeObjectForKey(PropertyKey.nameKey) as!  String
        // Because photo is an optional property of Meal, use conditional cast. Downcast return value of object as UIImage
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as?  UIImage
        //because return value of decodeInteger is an int no need to downcast decoded value
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        // Must call designated initializer. passing values of constants created while archiving saved data as arguments
        self.init(name: name, photo: photo, rating: rating)
    }

    
    
    
    
    
    

}
