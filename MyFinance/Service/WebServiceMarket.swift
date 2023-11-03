//
//  WebServiceMarket.swift
//  MyFinance
//
//  Created by Atakan Başaran on 3.11.2023.
//

import Foundation


enum MarketError: Error {
    case ServerError
    case ParseError
}


class WebServiceMarket {
    
    func downloadMarket(url: URL, completion: @escaping(Result<[StockMarket],MarketError>) -> () ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(MarketError.ServerError))
            } else if let data = data {
                if let marketList = try? JSONDecoder().decode([StockMarket].self, from: data) {
                    completion(.success(marketList))
                } else {
                    completion(.failure(MarketError.ParseError))
                }
            }
        }.resume()
        
        
    }
    
    
    
    
}
