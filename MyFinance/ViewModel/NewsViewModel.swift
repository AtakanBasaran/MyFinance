//
//  NewsViewModel.swift
//  MyFinance
//
//  Created by Atakan Başaran on 5.11.2023.
//

import Foundation
import RxSwift
import RxCocoa


class FinanceNewsViewModel {
    
    let newsList: PublishSubject<[NewsViewModelItem]> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
        
    func getNews(selectedCategory: String) {
        
        self.loading.accept(true)
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=\(selectedCategory)&apiKey=455a336215aa40d1a905569434fa2e52")!
        
        WebServiceNews().downloadNews(url: url) { result in
            self.loading.accept(false)
            switch result {
                
            case .failure(let error):
                switch error {
                case .ParseError:
                    self.error.onNext("Parse Error")
                    
                case .ServerError:
                    self.error.onNext("Server Error")
                }
                
            case .success(let news):
                let transformedList = news.articles.map { data in
                    return NewsViewModelItem(title: data.title, description: data.description ?? "More details coming soon...")
                }
                self.newsList.onNext(transformedList)
                
            }
        }
        
    }
}



struct NewsViewModelItem {
    
    let title: String
    let description: String
}
