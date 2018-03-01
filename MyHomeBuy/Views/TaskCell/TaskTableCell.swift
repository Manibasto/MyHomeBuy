//
//  TaskTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 31/10/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class TaskTableCell: UITableViewCell {

    @IBOutlet weak var taskCompleteBtn: UIButton!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var mileStoneStatusBtn: UIButton!
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet var btnArray: [UIButton]!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
