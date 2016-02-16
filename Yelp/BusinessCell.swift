//
//  BusinessCell.swift
//  Yelp
//
//  Created by Tejen Hasmukh Patel on 1/31/16.
//  Copyright © 2016 Tejen Patel. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    var itemNumber = 0;
    
    var business: Business! {
        didSet {
            nameLabel.text = String(itemNumber) + ". " + business.name!;
            if let url = business.imageURL {
                thumbImageView.setImageWithURL(url);
            }
            categoriesLabel.text = business.categories;
            addressLabel.text = business.address;
            ratingCountLabel.text = "\(business.reviewCount!) Reviews";
            ratingImageView.setImageWithURL(business.ratingImageURL!);
            distanceLabel.text = business.distance;
            
        }
    }
    
    func setLabelWrappingWidth(label: UILabel) {
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width; // wrapping should occur if label is >= this width
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImageView.layer.cornerRadius = 3;
        thumbImageView.clipsToBounds = true;
        
        setLabelWrappingWidth(nameLabel);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        setLabelWrappingWidth(nameLabel);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
