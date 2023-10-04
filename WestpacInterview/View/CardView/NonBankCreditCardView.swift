//
//  NonBankCreditCardView.swift
//  WestpacInterview
//
//  Created by Jiao, Liguo (Auckland) on 4/10/23.
//

import SwiftUI

struct NonBankCreditCardListView: View {
    @EnvironmentObject var viewModel: CreditCardViewModel

    var body: some View {
        CreditCardListView(cards: viewModel.getNonBankCreditCards(), backgroundColor: .teal)
    }
}

struct NonBankCreditCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeLandingView()
    }
}
