//
//  FirstViewControllerTableViewCell.swift
//  Honeycomb
//
//  Created by Niall Miner on 7/7/17.
//  Copyright © 2017 Niall Miner. All rights reserved.
//

import UIKit

class FirstViewControllerTableViewCell: UITableViewCell {
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
