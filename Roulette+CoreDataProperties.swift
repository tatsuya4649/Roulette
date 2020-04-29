//
//  Roulette+CoreDataProperties.swift
//  
//
//  Created by 下川達也 on 2020/04/25.
//
//

import Foundation
import CoreData


extension Roulette {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Roulette> {
        return NSFetchRequest<Roulette>(entityName: "Roulette")
    }

    @NSManaged public var rouletteTitle: String?
    @NSManaged public var rouletteSound: String?
    @NSManaged public var rouletteBackgroundColor: Data?
    @NSManaged public var saveDate: Date?
    @NSManaged public var elementFontColor: Data?
    @NSManaged public var elements: Data?

}
