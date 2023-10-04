//
//  CreditCardViewModel.swift
//  WestpacInterview
//
//  Created by Jiao, Liguo (Auckland) on 4/10/23.
//

import Foundation
import Combine

public enum CreditCardIssuer: String {
    case forbrugsforeningen
    case diners_club
}

enum NetworkError: Error {
    case noAvailableCard(description: String)
    case networkFailure(description: String)
}

class CreditCardViewModel: ObservableObject {
    @Published var creditCards: [CreditCard] = []
    @Published var bankCreditCards: [CreditCard] = []
    @Published var nonBankCreditCards: [CreditCard] = []
    @Published var isLoading: Bool = false
    @Published var error: NetworkError? = nil

    private var cancellables = Set<AnyCancellable>()

    func fetchData() {
        guard let url = URL(string: "https://random-data-api.com/api/v2/credit_cards?size=100") else {
            return
        }

        self.isLoading = true

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data -> [CreditCard] in
                guard let cards = try? JSONDecoder().decode([CreditCard].self, from: data), !cards.isEmpty else {
                    DispatchQueue.main.async {
                        self.error = NetworkError.noAvailableCard(description: "Can't find any available bank cards in your current account")
                    }
                    return []
                }
                return cards
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = NetworkError.networkFailure(description: error.localizedDescription)
                case .finished:
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] creditCards in
                self?.creditCards = creditCards
            }
            .store(in: &cancellables)
    }

    func getBankCreditCards() -> [CreditCard] {
        let result = self.creditCards
        return result.filter{
            $0.cardIssuer != CreditCardIssuer.forbrugsforeningen.rawValue &&
            $0.cardIssuer != CreditCardIssuer.diners_club.rawValue
        }
    }

    func getNonBankCreditCards() -> [CreditCard] {
        let result = self.creditCards
        return result.filter{
            $0.cardIssuer.lowercased() == CreditCardIssuer.forbrugsforeningen.rawValue ||
            $0.cardIssuer.lowercased() == CreditCardIssuer.diners_club.rawValue
        }
    }
}
