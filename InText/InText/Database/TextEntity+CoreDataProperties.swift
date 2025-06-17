//
//  TextEntity+CoreDataProperties.swift
//  InText
//
//  Created by kerik on 14.06.2025.
//
//

import Foundation
import CoreData


extension TextEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextEntity> {
        return NSFetchRequest<TextEntity>(entityName: "TextEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var summary: String?
    @NSManaged public var keywords: String?

}

extension TextEntity : Identifiable {

}
