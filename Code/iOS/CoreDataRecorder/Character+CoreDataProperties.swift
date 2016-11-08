//
//  Character+CoreDataProperties.swift
//  CoreDataRecorder
//
//  Created by Student on 07/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import Foundation
import CoreData

extension Character {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: "Character");
    }

    @NSManaged public var strokes: NSSet?
    @NSManaged public var person: Person?

}

// MARK: Generated accessors for strokes
extension Character {

    @objc(addStrokesObject:)
    @NSManaged public func addToStrokes(_ value: Stroke)

    @objc(removeStrokesObject:)
    @NSManaged public func removeFromStrokes(_ value: Stroke)

    @objc(addStrokes:)
    @NSManaged public func addToStrokes(_ values: NSSet)

    @objc(removeStrokes:)
    @NSManaged public func removeFromStrokes(_ values: NSSet)

}
