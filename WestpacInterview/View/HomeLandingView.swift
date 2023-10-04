//
//  CreditCardView.swift
//  WestpacInterview
//
//  Created by Jiao, Liguo (Auckland) on 4/10/23.
//

import SwiftUI
import Combine

private enum SelectedSegment: Int {
    case bank = 0
    case loyaltyCards = 1

    var description: String {
        switch self {
        case .bank:
            return "Bank"
        case .loyaltyCards:
            return "Loyalty Cards"
        }
    }
}

struct HomeLandingView: View {
    @ObservedObject var viewModel = CreditCardViewModel()
    @State private var selectedSegment = SelectedSegment.bank
    @State private var showAlert: Bool = false

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Picker(selection: $selectedSegment, label: Text("")) {
                    Text(SelectedSegment.bank.description)
                        .tag(SelectedSegment.bank)
                    Text(SelectedSegment.loyaltyCards.description).tag(SelectedSegment.loyaltyCards)
                }

                .pickerStyle(SegmentedPickerStyle())
                .padding()

                switch selectedSegment {
                case .bank:
                    BankCreditCardListView()
                        .environmentObject(viewModel)
                case .loyaltyCards:
                    NonBankCreditCardListView()
                        .environmentObject(viewModel)
                }
                Spacer()
            }
            .onAppear {
                self.showAlert = false
                viewModel.fetchData()
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Generic Error"),
                      message: Text("\(viewModel.error?.localizedDescription ?? "")"),
                      primaryButton: .default(Text("Retry"), action: {
                    viewModel.fetchData()
                }), secondaryButton: .cancel(Text("Quit"), action: {
                    exit(0)
                }))
            })
            .onReceive(viewModel.$error) { error in
                self.showAlert = true
            }
        }
    }
}

struct HomeLandingView_Previews: PreviewProvider {
    static var previews: some View {
        HomeLandingView()
    }
}
