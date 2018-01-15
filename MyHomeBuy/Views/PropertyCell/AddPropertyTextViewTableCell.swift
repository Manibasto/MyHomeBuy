//
//  AddPropertyTextViewTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 11/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
class AddPropertyTextViewTableCell: UITableViewCell {

    @IBOutlet weak var descTextView: KMPlaceholderTextView!
   
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
