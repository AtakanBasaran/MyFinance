//
//  MarketTableViewCell.swift
//  MyFinance
//
//  Created by Atakan Başaran on 3.11.2023.
//

import UIKit

class MarketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var item: MarketViewModel! {
        didSet {
            self.symbolLabel.text = item.symbol
            self.priceLabel.text = "$\(item.price ?? 0)"
            
            if let changeValue = item.changesPercentage {
                let roundedValue = round(changeValue*10)/10
                if roundedValue < 0 {
                    self.changeLabel.textColor = .red
                    self.changeLabel.text = "\(roundedValue)%"
                } else if roundedValue == 0 || roundedValue == 0.0 {
                    self.changeLabel.textColor = .label
                    self.changeLabel.text = "+\(roundedValue)%"
                } else {
                    self.changeLabel.textColor = .systemGreen
                    self.changeLabel.text = "+\(roundedValue)%"
                }
            } else {
                self.changeLabel.textColor = .label
                self.changeLabel.text = "N/A"
            }
            
            self.nameLabel.text = item.name
            
        }
    }

}
