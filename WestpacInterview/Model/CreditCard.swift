//
//  CreditCard.swift
//  WestpacInterview
//
//  Created by Jiao, Liguo (Auckland) on 4/10/23.
//

import Foundation

struct CreditCard: Codable, Identifiable {
    let id: Int
    let uid: String
    let cardNumber, cardExpiryDate, cardIssuer: String

    enum CodingKeys: String, CodingKey {
        case id, uid
        case cardNumber = "credit_card_number"
        case cardExpiryDate = "credit_card_expiry_date"
        case cardIssuer = "credit_card_type"
    }
}
