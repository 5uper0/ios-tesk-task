//
//  BitcoinRate+CoreDataProperties.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//
//

import Foundation
import CoreData


extension BitcoinRate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BitcoinRate> {
        return NSFetchRequest<BitcoinRate>(entityName: "BitcoinRate")
    }

    @NSManaged public var rate: Double
    @NSManaged public var timestamp: Date?

}

extension BitcoinRate : Identifiable {

}
