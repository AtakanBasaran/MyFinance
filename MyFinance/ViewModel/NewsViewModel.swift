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
    
    //Publishing to ViewController with Rx library
    let newsList: PublishSubject<[NewsViewModelItem]> = PublishSubject()
    let error: PublishSubject<String> = PublishSubject()
    let loading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
        
    func getNews(selectedCategory: String) {
        
        self.loading.accept(true) //The loading process started
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=\(selectedCategory)&apiKey=455a336215aa40d1a905569434fa2e52")!
        
        WebServiceNews().downloadNews(url: url) { result in
            self.loading.accept(false) //The loading process finished
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
                    return NewsViewModelItem(title: data.title, description: data.description ?? "More details coming soon...") //Map to wanted data to show in View
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
