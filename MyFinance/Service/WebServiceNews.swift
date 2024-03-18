//
//  WebServiceNews.swift
//  MyFinance
//
//  Created by Atakan Başaran on 5.11.2023.
//

import Foundation

enum newsError: Error{
    case ServerError
    case ParseError
}

class WebServiceNews {
    
    func downloadNews(url: URL, completion: @escaping(Result<News,newsError>) -> () ) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(newsError.ServerError))
            } else if let data = data {
                if var newsList = try? JSONDecoder().decode(News.self, from: data) {
                    completion(.success(newsList))
                } else {
                    completion(.failure(newsError.ParseError))
                }
            }
        }.resume()
    }
}
