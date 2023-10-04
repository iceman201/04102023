//
//  BankCrediCardView.swift
//  WestpacInterview
//
//  Created by Jiao, Liguo (Auckland) on 4/10/23.
//

import SwiftUI

struct BankCreditCardListView: View {
    @EnvironmentObject var viewModel: CreditCardViewModel
    
    var body: some View {
        CreditCardListView(cards: viewModel.getBankCreditCards(),
                           backgroundColor: .green)
    }
}

struct BankCreditCardListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeLandingView()
    }
}
