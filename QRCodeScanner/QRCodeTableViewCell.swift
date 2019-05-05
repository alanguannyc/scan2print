//
//  TableViewCell.swift
//  QRCodeScanner
//
//  Created by Alan Guan on 5/4/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit

class QRCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CodeLabel: UILabel!
    @IBOutlet weak var CPNumLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
