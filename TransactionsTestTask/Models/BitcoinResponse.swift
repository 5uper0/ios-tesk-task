//
//  BitcoinResponse.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//


import Foundation

struct BitcoinResponse: Decodable {
    struct BPI: Decodable {
        struct Currency: Decodable {
            let code: String
            let rate: String
            let rate_float: Double
        }
        
        let USD: Currency
        let GBP: Currency?
        let EUR: Currency?
    }
    
    let time: Time
    let bpi: BPI
    
    struct Time: Decodable {
        let updated: String
        let updatedISO: String
    }
}