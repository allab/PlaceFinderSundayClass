//
//  BusinessTableViewCell.swift
//  PlaceFinder
//
//  Created by Alla Bondarenko on 2017-03-12.
//  Copyright © 2017 SMU Student. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    
    //UI to code connection for a tableview cell subclass. Used as a prototype of a cell 
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var distance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
