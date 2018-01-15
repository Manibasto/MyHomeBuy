//
//  CheckListTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 27/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class CheckListTableCell: UITableViewCell {

    @IBOutlet weak var detailLbl: UILabel!
    
    @IBOutlet weak var checkBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
