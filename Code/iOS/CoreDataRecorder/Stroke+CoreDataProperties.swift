//
//  Stroke+CoreDataProperties.swift
//  CoreDataRecorder
//
//  Created by Student on 20/10/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import Foundation
import CoreData

extension Stroke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stroke> {
        return NSFetchRequest<Stroke>(entityName: "Stroke");
    }

    @NSManaged public var touches: NSSet?

}

// MARK: Generated accessors for touches
extension Stroke {

    @objc(addTouchesObject:)
    @NSManaged public func addToTouches(_ value: Touch)

    @objc(removeTouchesObject:)
    @NSManaged public func removeFromTouches(_ value: Touch)

    @objc(addTouches:)
    @NSManaged public func addToTouches(_ values: NSSet)

    @objc(removeTouches:)
    @NSManaged public func removeFromTouches(_ values: NSSet)

}
