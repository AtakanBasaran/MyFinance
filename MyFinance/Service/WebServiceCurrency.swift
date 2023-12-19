//
//  WebService.swift
//  MyFinance
//
//  Created by Atakan Başaran on 31.10.2023.
//

import Foundation

enum FinanceErrror: Error {
    case ServerError
    case ParseError
}

class WebServiceCurrency {
    
    func downloadCurrency(url: URL, completion: @escaping (Result <Currency, FinanceErrror>) -> () ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(FinanceErrror.ServerError))
            } else if let data = data {
                if let currencyList = try? JSONDecoder().decode(Currency.self, from: data) {
                    completion(.success(currencyList))

                } else {
                    completion(.failure(FinanceErrror.ParseError)) //data cannot parsed
                }
                
            }
        }.resume()
    }
    
    
}
