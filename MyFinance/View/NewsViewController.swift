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
    @IBOutlet weak var buttonCountry: UIButton!
    
    
    let newsVM = FinanceNewsViewModel()
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    var selectedCategory = "business"
    var selectedCountry = "US"
    
    var activePickerView: UIPickerView?
    var countryPickerView: UIPickerView?
    var categoryPickerView: UIPickerView?

    
    
    private var categories = ["Business","Entertainment","General","Health","Science","Sports","Technology"]
    private var countries = [
        "AE", "AR", "AT", "AU", "BE", "BG", "BR", "CA", "CH", "CN",
        "CO", "CU", "CZ", "DE", "EG", "FR", "GB", "GR", "HK", "HU", "ID",
        "IE", "IL", "IN", "IT", "JP", "KR", "LT", "LV", "MA", "MX", "MY",
        "NG", "NL", "NO", "NZ", "PH", "PL", "PT", "RO", "RS", "RU", "SA",
        "SE", "SG", "SI", "SK", "TH", "TR", "TW", "UA", "US", "VE", "ZA"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pickerViews initialized
        countryPickerView = UIPickerView()
        categoryPickerView = UIPickerView()
        
        countryPickerView?.delegate = self
        countryPickerView?.dataSource = self

        categoryPickerView?.delegate = self
        categoryPickerView?.dataSource = self
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag) //tableView delegate is set with rx
        setUpBindings()
        newsVM.getNews(selectedCategory: selectedCategory, selectedCountry: selectedCountry) //initialize category and country for news
        
        categoryLabel.text = selectedCategory.uppercased()
        buttonCountry.setTitle(selectedCountry, for: .normal)
        
        refreshControl.addTarget(self, action: #selector(refreshing), for: .valueChanged) //loading
        tableView.addSubview(refreshControl)
        
    
        
    
    }
    
    @objc func refreshing() {
        newsVM.getNews(selectedCategory: selectedCategory, selectedCountry: selectedCountry)
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
    
 
    
    @IBAction func countryButton(_ sender: Any) {
        
        activePickerView = countryPickerView
        
        let alertController = UIAlertController(title: "Country\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.width - 16, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        alertController.view.addSubview(pickerView)
        
        let doneAction = UIAlertAction(title: "Select", style: .default) { _ in
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            self.selectedCountry = self.countries[selectedRow]
            self.newsVM.getNews(selectedCategory: self.selectedCategory, selectedCountry: self.selectedCountry)
            self.buttonCountry.setTitle(self.selectedCountry, for: .normal)
            self.tableView.reloadData()
        }
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func categoryButton(_ sender: Any) {
        
        activePickerView = categoryPickerView

        let alertController = UIAlertController(title: "Category\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: alertController.view.bounds.width - 16, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        alertController.view.addSubview(pickerView)
        
        let doneAction = UIAlertAction(title: "Select", style: .default) { _ in
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            self.selectedCategory = self.categories[selectedRow]
            self.newsVM.getNews(selectedCategory: self.selectedCategory, selectedCountry: self.selectedCountry)
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
        
        //Chosing category or country pickerViews according to buttons 
        if activePickerView == countryPickerView {
                return countries.count
            } else if activePickerView == categoryPickerView {
                return categories.count
            } else {
                return 0
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if activePickerView == countryPickerView {
                return countries[row]
            } else if activePickerView == categoryPickerView {
                return categories[row]
            } else {
                return nil
            }
    }
    
    
}
