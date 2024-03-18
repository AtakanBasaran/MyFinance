//
//  CryptoTableViewCell.swift
//  MyFinance
//
//  Created by Atakan Başaran on 2.11.2023.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!    
    @IBOutlet weak var volumeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public var item: CryptoViewModelItem! {
        didSet {
            self.nameLabel.text = "\(item.symbol)/USDT"
            
            let value = Double(item.priceUsd)!
            let roundedValue = round(value * 100)/100
            self.priceLabel.text = "$\(roundedValue)"
            
            let Newvalue = Double(item.changePercent24Hr)!
            let roundedNewValue = round(Newvalue*100)/100
            
            if roundedNewValue < 0 {
                self.changeLabel.textColor = .red
                self.changeLabel.text = "\(roundedNewValue)%"
            } else if roundedNewValue == 0 || roundedNewValue == 0.0 {
                self.changeLabel.textColor = .label
                self.changeLabel.text = "+\(roundedNewValue)%"
                
            } else {
                self.changeLabel.textColor = .systemGreen
                self.changeLabel.text = "+\(roundedNewValue)%"
            }
 
            let volumeValue = Double(item.volume) ?? 0.0  // Ensure volumeValue is not nil
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 0

            if let formattedVolume = numberFormatter.string(from: NSNumber(value: volumeValue)) {
                self.volumeLabel.text = "Volume: $\(formattedVolume)"
            } else {
                self.volumeLabel.text = "Volume: $\(volumeValue)"
            }

            
            
            
        }
    }
    

}
