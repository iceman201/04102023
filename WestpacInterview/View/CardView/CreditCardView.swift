//
//  CreditCardView.swift
//  WestpacInterview
//
//  Created by Jiao, Liguo (Auckland) on 4/10/23.
//

import SwiftUI

struct CreditCardListView: View {
    @EnvironmentObject var viewModel: CreditCardViewModel
    var cards: [CreditCard]
    var backgroundColor: Color

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else {
                List {
                    ForEach(cards, id: \.id) { card in
                        CreditCardRow(card: card, backgroundColor: backgroundColor)
                            .background(Color.clear)
                            .padding(.bottom, basePadding)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, basePadding)
            }
        }
    }
}

struct CreditCardRow: View {
    var card: CreditCard
    var backgroundColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: basePadding * 2)
                .fill(backgroundColor)

            VStack(alignment: .leading) {
                Text("Card Number: \(card.cardNumber)")
                Text("Issuer: \(card.cardIssuer.capitalized)")
                Text("Expiration Date: \(card.cardExpiryDate)")
            }
            .padding(EdgeInsets(top: basePadding * 2,
                                leading: 0,
                                bottom: basePadding * 2,
                                trailing: 0))
            .foregroundColor(.white)
        }
        .listRowInsets(EdgeInsets(top: basePadding,
                                  leading: basePadding,
                                  bottom: basePadding,
                                  trailing: basePadding))
    }
}

struct CreditCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeLandingView()
    }
}
