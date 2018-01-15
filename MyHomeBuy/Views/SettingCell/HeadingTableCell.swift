//
//  HeadingTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 23/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class HeadingTableCell: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
