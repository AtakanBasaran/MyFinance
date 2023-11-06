//
//  CurrencyViewModel.swift
//  MyFinance
//
//  Created by Atakan Başaran on 31.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

class FinanceCurrencyViewModel {

    //Publishing to ViewController with Rx library
    let currencyList: PublishSubject<CurrencyViewModel> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func getCurrency(selectedCurrency: String) {
        loading.accept(true)
        let url = URL(string: "https://v6.exchangerate-api.com/v6/4b953778eff2fa60cb639321/latest/\(selectedCurrency)")!
        
        WebServiceCurrency().downloadCurrency(url: url) { result in
            self.loading.accept(false)
            switch result {
            case .success(let currency):
                let newCurrency = CurrencyViewModel(conversionRates: currency.conversionRates)
                self.currencyList.onNext(newCurrency)
                
            case .failure(let error):
                switch error {
                case .ParseError:
                    self.error.onNext("Parse Error")
                case .ServerError:
                    self.error.onNext("Server Error")
                }
                
            }
        }
    }

}

//Map to wanted data to show in View
struct CurrencyViewModel: Sequence {
    let currencyList: [CurrencyViewModelItem]

    func makeIterator() -> IndexingIterator<[CurrencyViewModelItem]> {
        return currencyList.makeIterator()
    }
    
    init(conversionRates: [String: Double]) {
        // Map each key-value pair in the dictionary to a CurrencyViewModelItem
        self.currencyList = conversionRates.map { (baseCurrency, conversionRate) in
            return CurrencyViewModelItem(baseCurrency: baseCurrency, conversionRate: conversionRate)
        }
    }
}

struct CurrencyViewModelItem {
    let baseCurrency: String
    let conversionRate: Double
}


