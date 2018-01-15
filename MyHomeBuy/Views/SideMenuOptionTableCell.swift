//
//  SideMenuOptionTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 05/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class SideMenuOptionTableCell: UITableViewCell {

    @IBOutlet weak var optionLbl: UILabel!
    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionBgImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
