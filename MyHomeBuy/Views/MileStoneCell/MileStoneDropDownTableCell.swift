//
//  MileStoneDropDownTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 26/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class MileStoneDropDownTableCell: UITableViewCell {
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var dropDownImageView: UIImageView!
   
    @IBOutlet weak var customLbl: UILabel!
    @IBOutlet weak var customImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
