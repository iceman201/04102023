//
//  WestpacInterviewTests.swift
//  WestpacInterviewTests
//
//  Created by Jiao, Liguo (Auckland) on 4/10/23.
//

import XCTest
import Combine
@testable import WestpacInterview

final class WestpacInterviewTests: XCTestCase {
    var viewModel: CreditCardViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = CreditCardViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testFetchData() {
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        var cancellables = Set<AnyCancellable>()
        viewModel.$isLoading
            .sink(receiveValue: { isLoading in
                if !isLoading {
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)

        viewModel.fetchData()
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetBankCreditCards() {
        let mockCreditCard1 = CreditCard(id: 1, uid: "uid1", cardNumber: "1111", cardExpiryDate: "12/24", cardIssuer: CreditCardIssuer.forbrugsforeningen.rawValue)
        let mockCreditCard2 = CreditCard(id: 2, uid: "uid2", cardNumber: "2222", cardExpiryDate: "12/25", cardIssuer: CreditCardIssuer.diners_club.rawValue)
        let mockCreditCard3 = CreditCard(id: 3, uid: "uid3", cardNumber: "3333", cardExpiryDate: "12/26", cardIssuer: "visa")

        viewModel.creditCards = [mockCreditCard1, mockCreditCard2, mockCreditCard3]

        let bankCreditCards = viewModel.getBankCreditCards()

        XCTAssertEqual(bankCreditCards.count, 1)
        XCTAssertFalse(bankCreditCards.contains(where: { $0.cardIssuer != "visa" }))
    }

    func testGetNonBankCreditCards() {
        let mockCreditCard1 = CreditCard(id: 1, uid: "uid1", cardNumber: "1111", cardExpiryDate: "12/24", cardIssuer: CreditCardIssuer.forbrugsforeningen.rawValue)
        let mockCreditCard2 = CreditCard(id: 2, uid: "uid2", cardNumber: "2222", cardExpiryDate: "12/25", cardIssuer: CreditCardIssuer.diners_club.rawValue)
        let mockCreditCard3 = CreditCard(id: 3, uid: "uid3", cardNumber: "3333", cardExpiryDate: "12/26", cardIssuer: "visa") // Not a bank card

        viewModel.creditCards = [mockCreditCard1, mockCreditCard2, mockCreditCard3]

        let nonBankCreditCards = viewModel.getNonBankCreditCards()

        XCTAssertEqual(nonBankCreditCards.count, 2)
        XCTAssertFalse(nonBankCreditCards.contains(where: { $0.cardIssuer == "visa" }))
    }

    func testPerformanceExample() throws {
        measure {
            viewModel.fetchData()
        }
    }

}
