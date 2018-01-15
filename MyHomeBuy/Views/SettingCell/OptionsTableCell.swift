//
//  OptionsTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 23/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class OptionsTableCell: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var optionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
