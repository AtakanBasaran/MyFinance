//
//  WebServiceCrypto.swift
//  MyFinance
//
//  Created by Atakan Başaran on 2.11.2023.
//

import Foundation


enum CryptoError: Error {
    case ServerError
    case ParseError
}


class WebServiceCrypto {
    
    func downloadCrypto(url: URL, completion: @escaping (Result<Crypto, CryptoError>) -> () ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(CryptoError.ServerError))
            } else if let data = data {
                do {
                    let cryptoList = try JSONDecoder().decode(Crypto.self, from: data)
                    completion(.success(cryptoList))
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(CryptoError.ParseError))
                }

            }
        }.resume()  
    }
}
