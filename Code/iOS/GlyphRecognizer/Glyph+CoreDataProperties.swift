//
//  Glyph+CoreDataProperties.swift
//  GlyphRecognizer
//
//  Created by Student on 17/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Glyph {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Glyph> {
        return NSFetchRequest<Glyph>(entityName: "Glyph");
    }

    @NSManaged public var character: String?
    @NSManaged public var duration: Double
    @NSManaged public var finger: String?
    @NSManaged public var strokes: NSOrderedSet?
    @NSManaged public var subject: Subject?

}

// MARK: Generated accessors for strokes
extension Glyph {

    @objc(insertObject:inStrokesAtIndex:)
    @NSManaged public func insertIntoStrokes(_ value: Stroke, at idx: Int)

    @objc(removeObjectFromStrokesAtIndex:)
    @NSManaged public func removeFromStrokes(at idx: Int)

    @objc(insertStrokes:atIndexes:)
    @NSManaged public func insertIntoStrokes(_ values: [Stroke], at indexes: NSIndexSet)

    @objc(removeStrokesAtIndexes:)
    @NSManaged public func removeFromStrokes(at indexes: NSIndexSet)

    @objc(replaceObjectInStrokesAtIndex:withObject:)
    @NSManaged public func replaceStrokes(at idx: Int, with value: Stroke)

    @objc(replaceStrokesAtIndexes:withStrokes:)
    @NSManaged public func replaceStrokes(at indexes: NSIndexSet, with values: [Stroke])

    @objc(addStrokesObject:)
    @NSManaged public func addToStrokes(_ value: Stroke)

    @objc(removeStrokesObject:)
    @NSManaged public func removeFromStrokes(_ value: Stroke)

    @objc(addStrokes:)
    @NSManaged public func addToStrokes(_ values: NSOrderedSet)

    @objc(removeStrokes:)
    @NSManaged public func removeFromStrokes(_ values: NSOrderedSet)

}
