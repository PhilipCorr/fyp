//
//  Touch+CoreDataProperties.swift
//  GlyphRecognizer
//
//  Created by Student on 17/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Touch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Touch> {
        return NSFetchRequest<Touch>(entityName: "Touch");
    }

    @NSManaged public var force: Double
    @NSManaged public var index: Int32
    @NSManaged public var timeStamp: Double
    @NSManaged public var x: Double
    @NSManaged public var y: Double
    @NSManaged public var stroke: Stroke?

}
