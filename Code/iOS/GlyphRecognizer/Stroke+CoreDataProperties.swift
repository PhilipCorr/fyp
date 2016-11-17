//
//  Stroke+CoreDataProperties.swift
//  GlyphRecognizer
//
//  Created by Student on 17/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Stroke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stroke> {
        return NSFetchRequest<Stroke>(entityName: "Stroke");
    }

    @NSManaged public var duration: Double
    @NSManaged public var glyph: Glyph?
    @NSManaged public var touches: NSOrderedSet?

}

// MARK: Generated accessors for touches
extension Stroke {

    @objc(insertObject:inTouchesAtIndex:)
    @NSManaged public func insertIntoTouches(_ value: Touch, at idx: Int)

    @objc(removeObjectFromTouchesAtIndex:)
    @NSManaged public func removeFromTouches(at idx: Int)

    @objc(insertTouches:atIndexes:)
    @NSManaged public func insertIntoTouches(_ values: [Touch], at indexes: NSIndexSet)

    @objc(removeTouchesAtIndexes:)
    @NSManaged public func removeFromTouches(at indexes: NSIndexSet)

    @objc(replaceObjectInTouchesAtIndex:withObject:)
    @NSManaged public func replaceTouches(at idx: Int, with value: Touch)

    @objc(replaceTouchesAtIndexes:withTouches:)
    @NSManaged public func replaceTouches(at indexes: NSIndexSet, with values: [Touch])

    @objc(addTouchesObject:)
    @NSManaged public func addToTouches(_ value: Touch)

    @objc(removeTouchesObject:)
    @NSManaged public func removeFromTouches(_ value: Touch)

    @objc(addTouches:)
    @NSManaged public func addToTouches(_ values: NSOrderedSet)

    @objc(removeTouches:)
    @NSManaged public func removeFromTouches(_ values: NSOrderedSet)

}
