//
//  SummaryTableViewCell.swift
//  CoreDataRecorder
//
//  Created by Student on 06/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    @IBOutlet var index: UILabel!
    @IBOutlet var TVal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
