//
//  CoinViewController.swift
//  MyFinance
//
//  Created by Atakan Başaran on 31.10.2023.
//

import UIKit
import RxSwift
import RxCocoa

class CryptoViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let cryptoVM = FinanceCryptoViewModel()
    private var disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setUpBindings()
        cryptoVM.getCrypto()
        
        refreshControl.addTarget(self, action: #selector(refreshing), for: .valueChanged) //loading
        tableView.addSubview(refreshControl)

    }
    
    @objc func refreshing() {
        cryptoVM.getCrypto()
        tableView.reloadData()
    }
    
    func setUpBindings() {
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        cryptoVM
            .cryptoList
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: "CryptoCell", cellType: CryptoTableViewCell.self)) {row, item, cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
        
        cryptoVM
            .loading
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        searchBar.rx.text //Setting attributes for the search button
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { searchText in
                self.cryptoVM.filterCryptoList(with: searchText)
            })
            .disposed(by: disposeBag)
    }
}
