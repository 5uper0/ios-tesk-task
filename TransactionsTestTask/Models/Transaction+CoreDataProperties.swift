//
//  Transaction+CoreDataProperties.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var type: String?

}

extension Transaction : Identifiable {

}
