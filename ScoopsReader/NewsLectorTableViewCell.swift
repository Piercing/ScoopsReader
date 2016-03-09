//
//  NewsLectorTableViewCell.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 4/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class NewsLectorTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    
}
