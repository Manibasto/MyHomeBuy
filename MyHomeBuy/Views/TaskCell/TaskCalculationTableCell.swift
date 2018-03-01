//
//  TaskCalculationTableCell.swift
//  MyHomeBuy
//
//  Created by Vikas on 01/11/17.
//  Copyright © 2017 MobileCoderz. All rights reserved.
//

import UIKit

class TaskCalculationTableCell: UITableViewCell {
  
    @IBOutlet var amountTextFieldArray: [UITextField]!
    @IBOutlet weak var taskCompleteBtn: UIButton!
    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var mileStoneStatusBtn: UIButton!
    @IBOutlet weak var customView: UIView!
    @IBOutlet var btnArray: [UIButton]!
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var resultLbl: UILabel!
    
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
