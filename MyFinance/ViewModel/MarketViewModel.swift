//
//  MarketViewModel.swift
//  MyFinance
//
//  Created by Atakan Başaran on 3.11.2023.
//

import Foundation
import RxSwift
import RxCocoa


class FinanceMarketViewModel {
    
    private var originalMarketList: [MarketViewModel] = []
    let marketList: BehaviorRelay<[MarketViewModel]> = BehaviorRelay(value: [])
    let error: PublishSubject<String> = PublishSubject()
    let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    func getMarketStocks() {
        
        self.loading.accept(true)
        let url = URL(string: "https://financialmodelingprep.com/api/v3/symbol/NASDAQ?apikey=619789890eec4bcefa46daae185c1224")!
        
        WebServiceMarket().downloadMarket(url: url) { result in
            self.loading.accept(false)
            switch result {
            case .failure(let error):
                switch error {
                case .ParseError:
                    self.error.onNext("Parse Error")
                case .ServerError:
                    self.error.onNext("Server Error")
                }
                
            case .success(let stockList):
                self.originalMarketList = stockList.map(MarketViewModel.init)
                self.marketList.accept(self.originalMarketList)
            }
        }
    }
    
    func filtering(with SearchText: String) {
        
        if SearchText.isEmpty {
            self.marketList.accept(originalMarketList)
        } else {
            let filteredList = originalMarketList.filter{$0.name!.lowercased().contains(SearchText.lowercased())}
            self.marketList.accept(filteredList)
        }
    }
    
    
}



struct MarketViewModel {
    
    let market: StockMarket
    var symbol: String? {
        market.symbol
    }
    
    var price: Double? {
        market.price
    }
    
    var changesPercentage: Double? {
        market.changesPercentage
    }
    
    var name: String? {
        market.name
    }
}
