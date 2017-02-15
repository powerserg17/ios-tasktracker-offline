//
//  Task+CoreDataProperties.swift
//  TaskTracker Offline
//
//  Created by Serhii Pianykh on 2017-02-14.
//  Copyright © 2017 Serhii Pianykh. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var creating: Bool
    @NSManaged public var details: String?
    @NSManaged public var done: Bool
    @NSManaged public var title: String?

}
