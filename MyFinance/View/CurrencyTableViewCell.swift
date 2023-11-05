//
//  CurrencyTableViewCell.swift
//  MyFinance
//
//  Created by Atakan Başaran on 1.11.2023.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelCurrency: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var inverseLabelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public var item: CurrencyViewModelItem! {
        didSet {
            self.labelCurrency.text = "\(item.baseCurrency):"
            self.labelValue.text = String(item.conversionRate)
            
            let reverseValue = 1/item.conversionRate
            let roundedValue = round(reverseValue * 100)/100
            if roundedValue == 0.0 {
                let newRoundedValue = round(reverseValue * 10000)/10000
                self.inverseLabelValue.text = "\(newRoundedValue)"
            } else {
                self.inverseLabelValue.text = "\(roundedValue)"
            }
        }
    }
    
    
    
    
}
