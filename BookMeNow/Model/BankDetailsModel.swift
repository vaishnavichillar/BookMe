//
//  BankDetailsModel.swift
//  BookMeNow
//
//  Created by Neshwa on 09/02/24.
//

import Foundation

struct BankDetailsModel: Codable {
    let statusCode: Int
    let message: String
    let data: BankDataClass?
}

struct BankDataClass: Codable {
    let bankdata: BankDataModel?
}

struct BankDataModel: Codable {
    let accountNo, ifscCode, bankName, accountHolderName, UPIID: String?

    enum CodingKeys: String, CodingKey {
        case accountNo = "account_no"
        case ifscCode = "ifsc_code"
        case bankName = "bank_name"
        case accountHolderName = "account_holder_name"
        case UPIID = "UPI_ID"
    }
}
