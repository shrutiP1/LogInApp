//
//  Note+CoreDataProperties.swift
//  
//
//  Created by gadgetzone on 24/07/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var desciption: String?

}
