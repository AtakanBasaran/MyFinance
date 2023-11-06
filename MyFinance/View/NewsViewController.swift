//
//  NewsViewController.swift
//  MyFinance
//
//  Created by Atakan Başaran on 31.10.2023.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    let newsVM = FinanceNewsViewModel()
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    var selectedCategory = "business"
    private var categories = ["Business","Entertainment","General","Health","Science","Sports","Technology"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setUpBindings()
        newsVM.getNews(selectedCategory: selectedCategory)
        categoryLabel.text = selectedCategory.uppercased()
        
        refreshControl.addTarget(self, action: #selector(refreshing), for: .valueChanged) //loading
        tableView.addSubview(refreshControl)

    }
    
    @objc func refreshing() {
        newsVM.getNews(selectedCategory: selectedCategory)
        tableView.reloadData()
    }
    
    
    func setUpBindings() {
        newsVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { errorString in
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        newsVM
            .newsList
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: "NewsCell", cellType: NewsTableViewCell.self)) {row, item, cell in
                cell.item = item
            }
            .disposed(by: disposeBag)
        
        newsVM
            .loading
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    
    
    
    
    @IBAction func categoryButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Category\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.width - 16, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        alertController.view.addSubview(pickerView)
        
        let doneAction = UIAlertAction(title: "Select", style: .default) { _ in
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            self.selectedCategory = self.categories[selectedRow]
            self.newsVM.getNews(selectedCategory: self.selectedCategory)
            self.categoryLabel.text = self.selectedCategory.uppercased()
            self.tableView.reloadData()
        }
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension NewsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row]
    }
    
    
}
