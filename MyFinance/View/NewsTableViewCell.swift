//
//  NewsTableViewCell.swift
//  MyFinance
//
//  Created by Atakan Başaran on 5.11.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.bounds.width
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.bounds.width
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public var item: NewsViewModelItem! {
        didSet {
            self.nameLabel.text = item.title
            self.descriptionLabel.text = item.description
            
        }
    }

}
