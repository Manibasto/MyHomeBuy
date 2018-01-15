//
//  MileStoneSelectionTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 26/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class MileStoneSelectionTableCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var taskBtn: UIButton!
    @IBOutlet weak var tipsBtn: UIButton!
    @IBOutlet weak var mileStoneBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
