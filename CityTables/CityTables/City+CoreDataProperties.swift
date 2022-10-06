//
//  City+CoreDataProperties.swift
//  CityTables
//
//  Created by Nick Meyer on 3/13/22.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var cityDescription: String?
    @NSManaged public var cityImage: NSData?

}

extension City : Identifiable {

}
