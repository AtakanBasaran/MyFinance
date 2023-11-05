//
//  CryptoViewModel.swift
//  MyFinance
//
//  Created by Atakan Başaran on 2.11.2023.
//

import Foundation
import RxSwift
import RxCocoa


class FinanceCryptoViewModel {
    
    //Publishing to ViewController with Rx library
    private var originalCryptoList: [CryptoViewModelItem] = []
    let cryptoList: BehaviorRelay<[CryptoViewModelItem]> = BehaviorRelay(value: [])
    let error: PublishSubject<String> = PublishSubject()
    let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    
    func getCrypto() {
        
        self.loading.accept(true) //The loading process started
        let url = URL(string: "https://api.coincap.io/v2/assets")!
        
        WebServiceCrypto().downloadCrypto(url: url) { result in
            
            self.loading.accept(false) //The loading process finished
            switch result {
            case .failure(let error):
                switch error {
                case .ParseError:
                    self.error.onNext("Parse Error")
                case .ServerError:
                    self.error.onNext("Server Error")
                }
                
            case .success(let cryptos):
                self.originalCryptoList = cryptos.data.map { data in
                    return CryptoViewModelItem(symbol: data.symbol ?? "", priceUsd: data.priceUsd ?? "", changePercent24Hr: data.changePercent24Hr ?? "", volume: data.volumeUsd24Hr ?? "") //Map to wanted data to show in View
                }
                self.cryptoList.accept(self.originalCryptoList)
            }
        }

    }
    //Filtering for search button
    func filterCryptoList(with searchText: String) {
        
        if searchText.isEmpty {
            cryptoList.accept(originalCryptoList)
        } else {
            let filteredList = originalCryptoList.filter { $0.symbol.lowercased().contains(searchText.lowercased()) }
            cryptoList.accept(filteredList)
        }
    }
    
}



struct CryptoViewModelItem {
    
    let symbol: String
    let priceUsd: String
    let changePercent24Hr: String
    let volume: String
}
