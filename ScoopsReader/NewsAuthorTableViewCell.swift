//
//  NewsTableViewCell.swift
//  ScoopsReader
//
//  Created by MacBook Pro on 1/3/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

import UIKit

class NewsAuthorTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var dateTextView: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}