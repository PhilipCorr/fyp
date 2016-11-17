//
//  Subject+CoreDataProperties.swift
//  GlyphRecognizer
//
//  Created by Student on 17/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject");
    }

    @NSManaged public var age: Int32
    @NSManaged public var handedness: String?
    @NSManaged public var nativeLanguage: String?
    @NSManaged public var sex: String?
    @NSManaged public var glyphs: NSOrderedSet?

}

// MARK: Generated accessors for glyphs
extension Subject {

    @objc(insertObject:inGlyphsAtIndex:)
    @NSManaged public func insertIntoGlyphs(_ value: Glyph, at idx: Int)

    @objc(removeObjectFromGlyphsAtIndex:)
    @NSManaged public func removeFromGlyphs(at idx: Int)

    @objc(insertGlyphs:atIndexes:)
    @NSManaged public func insertIntoGlyphs(_ values: [Glyph], at indexes: NSIndexSet)

    @objc(removeGlyphsAtIndexes:)
    @NSManaged public func removeFromGlyphs(at indexes: NSIndexSet)

    @objc(replaceObjectInGlyphsAtIndex:withObject:)
    @NSManaged public func replaceGlyphs(at idx: Int, with value: Glyph)

    @objc(replaceGlyphsAtIndexes:withGlyphs:)
    @NSManaged public func replaceGlyphs(at indexes: NSIndexSet, with values: [Glyph])

    @objc(addGlyphsObject:)
    @NSManaged public func addToGlyphs(_ value: Glyph)

    @objc(removeGlyphsObject:)
    @NSManaged public func removeFromGlyphs(_ value: Glyph)

    @objc(addGlyphs:)
    @NSManaged public func addToGlyphs(_ values: NSOrderedSet)

    @objc(removeGlyphs:)
    @NSManaged public func removeFromGlyphs(_ values: NSOrderedSet)

}
