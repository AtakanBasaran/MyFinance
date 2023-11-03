//
//  MarketViewController.swift
//  MyFinance
//
//  Created by Atakan Başaran on 31.10.2023.
//

import UIKit
import RxSwift
import RxCocoa

class MarketViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let marketVM = FinanceMarketViewModel()
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setUpBindings()
        marketVM.getMarketStocks()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

    }
    
    @objc func refresh() {
        marketVM.getMarketStocks()
        tableView.reloadData()
    }
    
    func setUpBindings() {
        
        marketVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        marketVM
            .marketList
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: "StockCell", cellType: MarketTableViewCell.self)) {row, item, cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
        
        marketVM
            .loading
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { searchText in
                self.marketVM.filtering(with: searchText)
            })
            .disposed(by: disposeBag)
    }
    

    

    

}
