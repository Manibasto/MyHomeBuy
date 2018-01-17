//
//  pdfTableCell.swift
//  MyHomeBuy
//
//  Created by Santosh Rawani on 12/01/18.
//  Copyright © 2018 MobileCoderz. All rights reserved.
//

import UIKit

class pdfTableCell: UITableViewCell {

    @IBOutlet weak var pdfSizeLbl: UILabel!
    @IBOutlet weak var pdfDeleteBtn: UIButton!
     @IBOutlet weak var pdfNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
